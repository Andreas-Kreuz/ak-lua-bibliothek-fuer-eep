import SocketService from '../../clientio/SocketService';
import EepService from '../../eep/service/EepService';
import { LogEvent, RoomEvent } from '@ak/web-shared';
import { bufferTime, Subject } from 'rxjs';
import { Server, Socket } from 'socket.io';

// Init LogHandler
export const registerLogMod = (io: Server, socketService: SocketService, eepService: EepService, debug: boolean) => {
  const logLinesSubject = new Subject<string>();

  logLinesSubject.pipe(bufferTime(500)).forEach((lines) => {
    if (lines && lines.length > 0) {
      if (debug)
        console.log('🟨 EMIT to all IO: ' + LogEvent.LinesAdded + ' to ' + LogEvent.Room, '\n📄' + lines.join('\n📄'));
      io.to(LogEvent.Room).emit(LogEvent.LinesAdded, lines.join('\n'));
    }
  });

  eepService.setOnNewLogLine((logLines: string) => logLinesSubject.next(logLines));

  eepService.setOnLogCleared(() => {
    if (debug) console.log('⚠️ Clear log 📄');
    io.to(LogEvent.Room).emit(LogEvent.LinesCleared);
  });

  const queueCommand = eepService.queueCommand;

  const socketConnected = (socket: Socket) => {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (rooms.room === LogEvent.Room) {
        // if (debug) console.log('🟩 JOIN 📄', LogEvent.Room, ': ', socket.id);
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
