import { Server, Socket } from 'socket.io';
import { SocketEvent } from 'web-shared';

export default class SocketService {
  private onRoomsJoinedCallbacks: Array<(socket: Socket, joinedRooms: string[]) => void> = [];

  constructor(private io: Server) {
    this.allowRoomJoining();
  }

  /**
   * This will allow room joining for all new incoming connections
   */
  private allowRoomJoining() {
    this.io.on('connection', (socket: Socket) => {
      console.log('CONNECT FROM ' + socket.id);

      socket.on(SocketEvent.JoinRoom, (rooms: string | string[]) => {
        socket.join(rooms);
        let joinedRooms: string[];
        if (typeof rooms === 'string') {
          joinedRooms = [rooms];
        } else {
          joinedRooms = rooms;
        }
        console.log(socket.id + ' joined rooms: "' + joinedRooms + '"');
        for (const onRoomsJoined of this.onRoomsJoinedCallbacks) {
          onRoomsJoined(socket, joinedRooms);
        }
      });

      socket.on(SocketEvent.LeaveRoom, (room: string) => {
        socket.leave(room);
      });
    });
  }

  public addOnRoomsJoinedCallback(callback: (socket: Socket, rooms: string[]) => void): void {
    this.onRoomsJoinedCallbacks.push(callback);
  }
}
