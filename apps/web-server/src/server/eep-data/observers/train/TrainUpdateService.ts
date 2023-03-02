import FeatureUpdateService, { SocketDataProvider } from '../SocketDataProvider';
import { RollingStockSelector } from './RollingStockSelector';
import { TrainSelector } from './TrainSelector';
import { TrainListRoom, TrainDetailsRoom } from '@ak/web-shared';
import { Server } from 'socket.io';

export default class TrainUpdateService implements FeatureUpdateService {
  private roomDataProviders: SocketDataProvider[] = [];
  private rollingStockSelector = new RollingStockSelector();
  private trainSelector = new TrainSelector(this.rollingStockSelector);

  constructor(private io: Server) {
    this.roomDataProviders.push({
      roomType: TrainListRoom,
      id: 'TrainListRoom',
      jsonCreator: (room: string): string => {
        const trackType = TrainListRoom.idOfRoom(room);
        const json = JSON.stringify(this.trainSelector.getTrainList(trackType));
        return json;
      },
    });
    this.roomDataProviders.push({
      roomType: TrainDetailsRoom,
      id: 'TrainDetailsRoom',
      jsonCreator: (room: string): string => {
        const trainId = TrainDetailsRoom.idOfRoom(room);
        const json = JSON.stringify(this.trainSelector.getTrain(trainId));
        return json;
      },
    });
  }

  getDataUpdaters = () => [{ updateFromState: this.trainSelector.updateFromState }];

  getSocketSettings = () => this.roomDataProviders;
}
