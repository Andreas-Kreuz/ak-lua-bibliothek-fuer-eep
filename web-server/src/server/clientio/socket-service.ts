import { Server, Socket } from 'socket.io';
import { RoomEvent } from 'web-shared';

export default class SocketService {
  private onRoomsJoinedCallbacks: Array<(socket: Socket, joinedRoom: string) => void> = [];

  constructor(private io: Server) {
    this.allowRoomJoining();
  }

  /**
   * This will allow room joining for all new incoming connections
   */
  private allowRoomJoining() {
    this.io.on('connection', (socket: Socket) => {
      console.log('CONNECT FROM ' + socket.id);

      socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
        socket.join(rooms.room);
        console.log(socket.id + ' joined rooms: "' + rooms.room + '" ');
        for (const onRoomsJoined of this.onRoomsJoinedCallbacks) {
          onRoomsJoined(socket, rooms.room);
        }
      });

      socket.on(RoomEvent.LeaveRoom, (room: string) => {
        socket.leave(room);
      });
    });
  }

  public addOnRoomsJoinedCallback(callback: (socket: Socket, joinedRoom: string) => void): void {
    this.onRoomsJoinedCallbacks.push(callback);
  }
}
