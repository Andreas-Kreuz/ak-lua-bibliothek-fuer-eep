import { DynamicDataProvider } from './DynamicDataProvider';
import { DynamicDataUpdater } from './DynamicDataUpdater';

export default interface DynamicRoomService {
  getUpdaters(): DynamicDataUpdater[];
  getDataProviders(): DynamicDataProvider[];
}
