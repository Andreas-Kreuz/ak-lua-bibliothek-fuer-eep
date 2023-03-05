import SocketService from '../../clientio/SocketService';
import EepService from '../../eep/service/EepService';
import { CommandEvent, RoomEvent } from '@ak/web-shared';
import { Server, Socket } from 'socket.io';

export const registerCommandMod = (
  _io: Server,
  socketService: SocketService,
  eepService: EepService,
  _debug: boolean
) => {
  const queueCommand = eepService.queueCommand;
  const socketConnected = (socket: Socket) => {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (rooms.room === CommandEvent.Room) {
        // Nothing to do here!
      }
    });

    socket.on(CommandEvent.ChangeCamToStatic, (action: { staticCam: string }) => {
      const command = 'EEPSetCamera|0|' + action.staticCam;
      queueCommand(command);
    });

    socket.on(CommandEvent.ChangeCamToTrain, (action: { trainName: string; id?: number }) => {
      const camId = action.id ? action.id : 9;
      const command = 'EEPSetPerspectiveCamera|' + camId + '|' + action.trainName;
      queueCommand(command);
    });

    socket.on(
      CommandEvent.ChangeCamToRollingStock,
      (action: { rollingStock: string; posX: number; posY: number; posZ: number; redH: number; redV: number }) => {
        queueCommand('EEPRollingstockSetActive|' + action.rollingStock);
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
        queueCommand(command);
      }
    );

    socket.on(CommandEvent.ChangeSetting, (action: { name: string; func: string; newValue: unknown }) => {
      const command = action.func + '|' + action.newValue;
      queueCommand(command);
    });
  };

  socketService.addOnSocketConnectedCallback((socket: Socket) => socketConnected(socket));
};
