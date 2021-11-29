import { DynamicRoom } from 'web-shared/build/rooms';
import * as fromJsonData from '../eep-data-reducer';

export interface SocketDataProvider {
  roomType: DynamicRoom;
  id: string;
  jsonCreator: (roomName: string) => string;
}
export interface FeatureUpdater {
  updateFromState: (state: Readonly<fromJsonData.State>) => void;
}

export default interface FeatureUpdateService {
  getDataUpdaters(): FeatureUpdater[];
  getSocketSettings(): SocketDataProvider[];
}
