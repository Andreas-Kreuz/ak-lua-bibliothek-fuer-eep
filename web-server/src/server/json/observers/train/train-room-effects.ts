import { Server, Socket } from 'socket.io';
import JsonDataStore from '../../json-data-reducer';
import { TrainListRoom, TrainDetailsRoom } from 'web-shared/build/model/trains';
import { TrainSelector } from './train-selector';
import { RollingStockSelector } from './rolling-stock-selector';
import StateObserver from '../state-observer';

export default class TrainRoomEffects implements StateObserver {
  private trainListRooms = new Map<Socket, string>();
  private trainDetailsRooms = new Map<Socket, string>();
  private rollingStockSelector = new RollingStockSelector();
  private trainSelector = new TrainSelector(this.rollingStockSelector);

  constructor(private io: Server) {}

  onStateChange(store: Readonly<JsonDataStore>): void {
    if (this.trainDetailsRooms.size > 0 || this.trainListRooms.size > 0) {
      this.trainSelector.updateFromState(store.currentState());

      this.trainDetailsRooms.forEach((room) => {
        const trainId = TrainDetailsRoom.entryIdOf(room);
        const json = JSON.stringify(this.trainSelector.getTrain(trainId));
        this.io.to(room).emit(room, json);
      });
      this.trainListRooms.forEach((room) => {
        const trackType = TrainListRoom.entryIdOf(room);
        const json = JSON.stringify(this.trainSelector.getTrainList(trackType));
        this.io.to(room).emit(room, json);
      });
    }
  }

  onJoinRoom(socket: Socket, roomName: string): void {
    if (TrainListRoom.matchesRoom(roomName)) {
      this.trainListRooms.set(socket, roomName);
    }
    if (TrainDetailsRoom.matchesRoom(roomName)) {
      this.trainDetailsRooms.set(socket, roomName);
    }
  }

  onLeaveRoom(socket: Socket, roomName: string): void {
    if (TrainListRoom.matchesRoom(roomName)) {
      this.trainListRooms.delete(socket);
    }
    if (TrainDetailsRoom.matchesRoom(roomName)) {
      this.trainDetailsRooms.delete(socket);
    }
  }
}
