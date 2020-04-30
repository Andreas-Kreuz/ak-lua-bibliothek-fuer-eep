import { Server, Socket } from 'socket.io';
import Room from './room';
import SocketEvent from './socket-event';

export default class SocketManager {
  private onRoomsJoinedCallbacks: Array<(socket: Socket, joinedRooms: string[]) => void> = [];

  constructor(private io: Server) {
    this.registerMessages();
  }

  private registerMessages() {
    this.io.on('connection', (socket: Socket) => {
      socket.on(SocketEvent.JOIN_ROOM, (rooms: string | string[]) => {
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

      socket.on(SocketEvent.LEAVE_ROOM, (room: string) => {
        socket.leave(room);
      });
    });
  }

  public addOnRoomsJoinedCallback(callback: (socket: Socket, rooms: string[]) => void): void {
    this.onRoomsJoinedCallbacks.push(callback);
  }
}
