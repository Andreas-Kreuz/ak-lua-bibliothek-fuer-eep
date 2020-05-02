import path from 'path';
import { Server, Socket } from 'socket.io';

import { LogEvent } from 'web-shared';
import SocketService from '../clientio/socket-service';

export default class LogEffects {
  constructor(
    private app: any,
    private io: Server,
    private socketService: SocketService,
    private getCurrentLogLines: () => string,
    private queueCommand: (command: string) => void
  ) {
    this.socketService.addOnRoomsJoinedCallback((socket: Socket, joinedRoom: string) =>
      this.onRoomsJoined(socket, joinedRoom)
    );
  }

  private onRoomsJoined(socket: Socket, joinedRoom: string): void {
    if (joinedRoom === LogEvent.Room) {
      console.log('EMIT ' + LogEvent.LinesAdded + ' to ' + socket.id);
      socket.emit(LogEvent.LinesAdded, this.getCurrentLogLines());

      socket.on(LogEvent.ClearLog, () => {
        this.queueCommand('clearlog');
      });
      socket.on(LogEvent.SendTestMessage, () => {
        this.queueCommand('print|Hallo von EEP-Web! Umlaute: äöüÄÖÜß');
      });
    }
  }

  onNewLogLine(line: string): void {
    // console.log('Would send log: ' + line);
    this.io.to(LogEvent.Room).emit(LogEvent.LinesAdded, line);
  }

  onLogCleared(): void {
    console.log('Clear log ');
    this.io.to(LogEvent.Room).emit(LogEvent.LinesCleared);
  }
}
