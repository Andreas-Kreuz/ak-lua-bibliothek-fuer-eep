import SocketService from '../../clientio/SocketService';
import EepService from '../../eep/service/EepService';
import { IntersectionEvent, RoomEvent } from '@ak/web-shared';
import { Socket, Server } from 'socket.io';

export const registerIntersectionMod = (
  _io: Server,
  socketService: SocketService,
  eepService: EepService,
  _debug: boolean
) => {
  const queueCommand = eepService.queueCommand;

  function socketConnected(socket: Socket) {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (rooms.room === IntersectionEvent.Room) {
        // Nothing to do here!
      }
    });

    socket.on(IntersectionEvent.SwitchAutomatically, (action: { intersectionName: string }) => {
      const command = 'AkKreuzungSchalteAutomatisch|' + action.intersectionName;
      queueCommand(command);
    });
    socket.on(IntersectionEvent.SwitchManually, (action: { intersectionName: string; switchingName: string }) => {
      const command = 'AkKreuzungSchalteManuell|' + action.intersectionName + '|' + action.switchingName;
      queueCommand(command);
    });
  }

  socketService.addOnSocketConnectedCallback((socket: Socket) => socketConnected(socket));
};
