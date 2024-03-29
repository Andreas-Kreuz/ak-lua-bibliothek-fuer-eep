import { Server, Socket } from 'socket.io';
import { RoomEvent } from 'web-shared';

export default class SocketService {
  private debug = false;
  private onSocketConnectedCallbacks: Array<(socket: Socket) => void> = [];

  constructor(private io: Server) {
    this.allowRoomJoining();
  }

  /**
   * This will allow room joining for all new incoming connections
   */
  private allowRoomJoining() {
    this.io.on('connection', (socket: Socket) => {
      if (this.debug) console.log('CONNECT FROM ' + socket.id);
      for (const addSocketEvents of this.onSocketConnectedCallbacks) {
        addSocketEvents(socket);
      }

      socket.on(RoomEvent.JoinRoom, (room: { room: string }) => {
        socket.join(room.room);
        if (this.debug) console.log('JOIN ' + room.room + ' from ' + socket.id);
      });

      socket.on(RoomEvent.LeaveRoom, (room: { room: string }) => {
        socket.leave(room.room);
        if (this.debug) console.log('LEFT ' + room.room + ' by ' + socket.id);
      });
    });
  }

  public addOnSocketConnectedCallback(callback: (socket: Socket) => void): void {
    this.onSocketConnectedCallbacks.push(callback);
  }
}
