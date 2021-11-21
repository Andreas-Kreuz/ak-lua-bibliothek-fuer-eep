import { Server, Socket } from 'socket.io';

import { CommandEvent, RoomEvent } from 'web-shared';
import SocketService from '../clientio/socket-service';

export default class CommandEffects {
  constructor(
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
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

    socket.on(CommandEvent.ChangeCamToStatic, (action: { staticCam: string }) => {
      const command = 'EEPSetCamera|0|' + action.staticCam;
      this.queueCommand(command);
    });

    socket.on(CommandEvent.ChangeCamToTrain, (action: { trainName: string; id?: number }) => {
      const camId = action.id ? action.id : 9;
      const command = 'EEPSetPerspectiveCamera|' + camId + '|' + action.trainName;
      this.queueCommand(command);
    });

    socket.on(CommandEvent.ChangeSetting, (action: { name: string; func: string; newValue: unknown }) => {
      const command = action.func + '|' + action.newValue;
      this.queueCommand(command);
    });
  }
}
