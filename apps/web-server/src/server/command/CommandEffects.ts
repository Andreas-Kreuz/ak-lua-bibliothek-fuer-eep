import SocketService from '../clientio/SocketService';
import { CommandEvent, RoomEvent } from '@ak/web-shared';
import { Server, Socket } from 'socket.io';

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

    socket.on(
      CommandEvent.ChangeCamToRollingStock,
      (action: { rollingStock: string; posX: number; posY: number; posZ: number; redH: number; redV: number }) => {
        this.queueCommand('EEPRollingstockSetActive|' + action.rollingStock);
        const command =
          'EEPRollingstockSetUserCamera|' +
          action.rollingStock +
          '|' +
          action.posX +
          '|' +
          action.posY +
          '|' +
          action.posZ +
          '|' +
          action.redH +
          '|' +
          action.redV;
        this.queueCommand(command);
      }
    );

    socket.on(CommandEvent.ChangeSetting, (action: { name: string; func: string; newValue: unknown }) => {
      const command = action.func + '|' + action.newValue;
      this.queueCommand(command);
    });
  }
}
