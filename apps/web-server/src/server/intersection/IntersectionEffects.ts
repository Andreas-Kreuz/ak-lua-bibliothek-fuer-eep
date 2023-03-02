import SocketService from '../clientio/SocketService';
import { IntersectionEvent, RoomEvent } from '@ak/web-shared';
import { Server, Socket } from 'socket.io';

export default class IntersectionEffects {
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
