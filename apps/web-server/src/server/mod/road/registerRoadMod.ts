import SocketService from '../../clientio/SocketService';
import EepService from '../../eep/service/EepService';
import { RoadEvent, RoomEvent } from '@ak/web-shared';
import { Socket, Server } from 'socket.io';

export const registerRoadMod = (
  _io: Server,
  socketService: SocketService,
  eepService: EepService,
  _debug: boolean
) => {
  const queueCommand = eepService.queueCommand;

  function socketConnected(socket: Socket) {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (rooms.room === RoadEvent.Room) {
        // Nothing to do here!
      }
    });

    socket.on(RoadEvent.SwitchAutomatically, (action: { intersectionName: string }) => {
      const command = 'AkKreuzungSchalteAutomatisch|' + action.intersectionName;
      queueCommand(command);
    });
    socket.on(RoadEvent.SwitchManually, (action: { intersectionName: string; switchingName: string }) => {
      const command = 'AkKreuzungSchalteManuell|' + action.intersectionName + '|' + action.switchingName;
      queueCommand(command);
    });
  }

  socketService.addOnSocketConnectedCallback((socket: Socket) => socketConnected(socket));
};
