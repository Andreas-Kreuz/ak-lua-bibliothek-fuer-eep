import SocketService from '../../clientio/SocketService';
import EepService from '../../eep/service/EepService';
import { LogEvent, RoomEvent } from '@ak/web-shared';
import { bufferTime, Subject } from 'rxjs';
import { Server, Socket } from 'socket.io';

// Init LogHandler
export const registerLogMod = (io: Server, socketService: SocketService, eepService: EepService, debug: boolean) => {
  const logLinesSubject = new Subject<{ generation: number; sequence: number; text: string }>();
  let currentGeneration = 0;
  let currentSequence = 0;

  logLinesSubject.pipe(bufferTime(500)).forEach((entries) => {
    const currentEntries = entries.filter((entry) => entry.generation === currentGeneration);
    if (currentEntries.length > 0) {
      const room = io.sockets.adapter.rooms.get(LogEvent.Room);
      if (!room) {
        return;
      }

      for (const socketId of room) {
        const socket = io.sockets.sockets.get(socketId);
        if (!socket) {
          continue;
        }

        const joinGeneration = socket.data.logJoinGeneration ?? -1;
        const joinSequence = socket.data.logJoinSequence ?? 0;
        const visibleLines = currentEntries
          .filter((entry) => entry.generation > joinGeneration || entry.sequence > joinSequence)
          .map((entry) => entry.text);

        if (visibleLines.length > 0) {
          if (debug)
            console.log('🟨 EMIT to ' + socket.id + ': ' + LogEvent.LinesAdded, '\n📄' + visibleLines.join('\n📄'));
          socket.emit(LogEvent.LinesAdded, visibleLines.join('\n'));
        }
      }
    }
  });

  eepService.setOnNewLogLine((logLines: string) => {
    const filtered = logLines
      .split('\n')
      .filter((line) => line.trim().length > 0)
      .join('\n');
    if (filtered) {
      currentSequence++;
      logLinesSubject.next({ generation: currentGeneration, sequence: currentSequence, text: filtered });
    }
  });

  eepService.setOnLogCleared(() => {
    currentGeneration++;
    currentSequence = 0;
    if (debug) console.log('⚠️ Clear log 📄');
    io.to(LogEvent.Room).emit(LogEvent.LinesCleared);
  });

  const queueCommand = eepService.queueCommand;

  const socketConnected = (socket: Socket) => {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (rooms.room === LogEvent.Room) {
        // if (debug) console.log('🟩 JOIN 📄', LogEvent.Room, ': ', socket.id);
        socket.data.logJoinGeneration = currentGeneration;
        socket.data.logJoinSequence = currentSequence;
        const lines = eepService.getCurrentLogLines();
        if (debug) console.log('🟨 EMIT to ' + socket.id + ': 📄 ' + LogEvent.LinesAdded, lines);
        socket.emit(LogEvent.LinesAdded, lines);
      }
    });

    socket.on(RoomEvent.LeaveRoom, (rooms: { room: string }) => {
      if (rooms.room === LogEvent.Room) {
        // if (debug) console.log('🟥 LEFT 📄', LogEvent.Room, ': ', socket.id);
      }
    });

    socket.on(LogEvent.ClearLog, () => {
      if (debug) console.log('🟨 EMIT to all IO: 📄 ' + LogEvent.LinesCleared);
      queueCommand('clearlog');
      io.emit(LogEvent.LinesCleared);
    });

    socket.on(LogEvent.SendTestMessage, () => {
      queueCommand('print|Hallo von EEP-Web! Umlaute: äöüÄÖÜß');
    });
  };

  socketService.addOnSocketConnectedCallback((socket: Socket) => socketConnected(socket));
};
