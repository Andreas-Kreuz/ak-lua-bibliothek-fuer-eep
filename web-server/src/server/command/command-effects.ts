import path from 'path';
import { Server, Socket } from 'socket.io';

import { CommandEvent, RoomEvent } from 'web-shared';
import SocketService from '../clientio/socket-service';

export default class CommandEffects {
  constructor(
    private app: any,
    private io: Server,
    private socketService: SocketService,
    private queueCommand: (command: string) => void
  ) {
    this.socketService.addOnSocketConnectedCallback((socket: Socket) => this.socketConnected(socket));
  }

  private socketConnected(socket: Socket) {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (rooms.room === CommandEvent.Room) {
        // Nothing to do here!
      }
    });

    socket.on(CommandEvent.ChangeStaticCam, (action: { staticCam: string }) => {
      const command = 'EEPSetCamera|0|' + action.staticCam;
      this.queueCommand(command);
    });

    socket.on(CommandEvent.ChangeSetting, (action: { name: string; func: string; newValue: any }) => {
      const command = action.func + '|' + action.newValue;
      this.queueCommand(command);
    });
  }
}
