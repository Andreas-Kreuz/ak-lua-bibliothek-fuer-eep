import { Socket } from 'socket.io';
import JsonDataStore from '../eep-data-reducer';

export default interface StateObserver {
  onStateChange: (store: Readonly<JsonDataStore>) => void;
  onJoinRoom: (socket: Socket, room: string) => void;
  onLeaveRoom: (socket: Socket, room: string) => void;
}
