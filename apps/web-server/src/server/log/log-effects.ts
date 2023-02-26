import { bufferTime, Subject } from 'rxjs';
import { Server, Socket } from 'socket.io';

import { LogEvent, RoomEvent } from '@ak/web-shared';
import SocketService from '../clientio/socket-service';

export default class LogEffects {
  constructor(
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    private app: any,
    private io: Server,
    private socketService: SocketService,
    private getCurrentLogLines: () => string,
    private queueCommand: (command: string) => void,
    private debug = false,
    private logLinesSubject = new Subject<string>()
  ) {
    this.socketService.addOnSocketConnectedCallback((socket: Socket) => this.socketConnected(socket));
    this.logLinesSubject.pipe(bufferTime(500)).forEach((lines) => {
      if (lines && lines.length > 0) {
        this.io.to(LogEvent.Room).emit(LogEvent.LinesAdded, lines.join('\n'));
      }
    });
  }

  private socketConnected(socket: Socket) {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (rooms.room === LogEvent.Room) {
        if (this.debug) console.log('EMIT ' + LogEvent.LinesAdded + ' to ' + socket.id);
        socket.emit(LogEvent.LinesAdded, this.getCurrentLogLines());
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
      this.queueCommand('clearlog');
      this.io.emit(LogEvent.LinesCleared);
    });

    socket.on(LogEvent.SendTestMessage, () => {
      this.queueCommand('print|Hallo von EEP-Web! Umlaute: äöüÄÖÜß');
    });
  }

  onNewLogLine(line: string): void {
    this.logLinesSubject.next(line);
  }

  onLogCleared(): void {
    console.log('Clear log ');
    this.io.to(LogEvent.Room).emit(LogEvent.LinesCleared);
  }
}
