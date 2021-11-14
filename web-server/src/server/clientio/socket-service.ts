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

      socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
        socket.join(rooms.room);
        if (this.debug) console.log(socket.id + ' joined rooms: "' + rooms.room + '" ');
      });

      socket.on(RoomEvent.LeaveRoom, (room: string) => {
        socket.leave(room);
      });
    });
  }

  public addOnSocketConnectedCallback(callback: (socket: Socket) => void): void {
    this.onSocketConnectedCallbacks.push(callback);
  }
}
