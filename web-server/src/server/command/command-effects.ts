import path from 'path';
import { Server, Socket } from 'socket.io';

import { CommandEvent } from 'web-shared';
import SocketService from '../clientio/socket-service';

export default class CommandEffects {
  constructor(
    private app: any,
    private io: Server,
    private socketService: SocketService,
    private queueCommand: (command: string) => void
  ) {
    this.io.on(CommandEvent.Send, (socket: Socket, command: string) => {
      console.log('Received command: ' + command);
      this.queueCommand(command);
      // io.to(CommandEvent.Room).emit(CommandEvent.Send, command);
    });
    this.socketService.addOnRoomsJoinedCallback((socket: Socket, joinedRoom: string) =>
      this.onRoomsJoined(socket, joinedRoom)
    );
  }

  private onRoomsJoined(socket: Socket, joinedRoom: string) {
    if (joinedRoom === CommandEvent.Room) {
      // Nothing to do here!
    }
  }
}
