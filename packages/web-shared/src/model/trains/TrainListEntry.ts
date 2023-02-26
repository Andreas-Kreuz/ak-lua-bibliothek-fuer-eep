import TrainType from './TrainType';

export interface TrainListEntry {
  id: string;
  name: string;
  route: string;
  line: string;
  destination: string;
  trainType: number;
  trackType: string;
  rollingStockCount: number;
}

export default TrainListEntry;
