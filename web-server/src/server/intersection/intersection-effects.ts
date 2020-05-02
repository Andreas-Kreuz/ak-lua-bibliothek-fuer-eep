import { Server, Socket } from 'socket.io';

import { IntersectionEvent, RoomEvent } from 'web-shared';
import SocketService from '../clientio/socket-service';

export default class IntersectionEffects {
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
      if (rooms.room === IntersectionEvent.Room) {
        // Nothing to do here!
      }
    });

    socket.on(IntersectionEvent.SwitchAutomatically, (action: { intersectionName: string }) => {
      const command = 'AkKreuzungSchalteAutomatisch|' + action.intersectionName;
      this.queueCommand(command);
    });
    socket.on(IntersectionEvent.SwitchManually, (action: { intersectionName: string; switchingName: string }) => {
      const command = 'AkKreuzungSchalteManuell|' + action.intersectionName + '|' + action.switchingName;
      this.queueCommand(command);
    });
  }
}
