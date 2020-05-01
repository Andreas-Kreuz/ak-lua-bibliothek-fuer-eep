import path from 'path';
import { Server, Socket } from 'socket.io';

import { Room, SocketEvent } from 'web-shared';
import SocketService from '../clientio/socket-manager';

export default class LogEffects {
  constructor(
    private app: any,
    private io: Server,
    private socketService: SocketService,
    private getCurrentLogLines: () => string
  ) {
    this.socketService.addOnRoomsJoinedCallback((socket: Socket, joinedRooms: string[]) =>
      this.onRoomsJoined(socket, joinedRooms)
    );
  }

  private onRoomsJoined(socket: Socket, joinedRooms: string[]) {
    if (joinedRooms.indexOf(Room.Log) > -1) {
      socket.emit(Room.Log, this.getCurrentLogLines());
    }
  }

  onNewLogLine(line: string): void {
    // console.log('Would send log: ' + line);
    this.io.to(Room.Log).emit(Room.Log, line);
  }
}
