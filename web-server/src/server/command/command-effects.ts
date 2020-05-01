import path from 'path';
import { Server, Socket } from 'socket.io';

import { Room, SocketEvent } from 'web-shared';
import SocketService from '../clientio/socket-manager';

export default class CommandEffects {
  constructor(
    private app: any,
    private io: Server,
    private socketService: SocketService,
    private queueCommand: (command: string) => void
  ) {
    this.io.on(Room.EepCommand, (socket: Socket, command: string) => {
      console.log('Received command: ' + command);
      this.queueCommand(command);
      io.to(Room.EepCommand).emit(Room.EepCommand, command);
    });
    this.socketService.addOnRoomsJoinedCallback((socket: Socket, joinedRooms: string[]) =>
      this.onRoomsJoined(socket, joinedRooms)
    );
  }

  private onRoomsJoined(socket: Socket, joinedRooms: string[]) {
    if (joinedRooms.indexOf(Room.EepCommand) > -1) {
      // Nothing to do here!
    }
  }
}
