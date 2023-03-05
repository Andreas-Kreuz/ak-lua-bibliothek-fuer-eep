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
      io.to(LogEvent.Room).emit(LogEvent.LinesAdded, lines.join('\n'));
    }
  });

  eepService.setOnNewLogLine((logLines: string) => logLinesSubject.next(logLines));

  eepService.setOnLogCleared(() => {
    console.log('Clear log ');
    io.to(LogEvent.Room).emit(LogEvent.LinesCleared);
  });

  const queueCommand = eepService.queueCommand;

  const socketConnected = (socket: Socket) => {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (rooms.room === LogEvent.Room) {
        if (debug) console.log('EMIT ' + LogEvent.LinesAdded + ' to ' + socket.id);
        socket.emit(LogEvent.LinesAdded, eepService.getCurrentLogLines());
        console.log('JOINED LOG ROOM: ', socket.id);
      }
    });

    socket.on(RoomEvent.LeaveRoom, (rooms: { room: string }) => {
      if (rooms.room === LogEvent.Room) {
        // if (this.debug) console.log('EMIT ' + LogEvent.LinesAdded + ' to ' + socket.id);
        // socket.emit(LogEvent.LinesAdded, this.getCurrentLogLines());
        console.log('LEFT LOG ROOM: ', socket.id);
      }
    });

    socket.on(LogEvent.ClearLog, () => {
      queueCommand('clearlog');
      io.emit(LogEvent.LinesCleared);
    });

    socket.on(LogEvent.SendTestMessage, () => {
      queueCommand('print|Hallo von EEP-Web! Umlaute: äöüÄÖÜß');
    });
  };

  socketService.addOnSocketConnectedCallback((socket: Socket) => socketConnected(socket));
};
