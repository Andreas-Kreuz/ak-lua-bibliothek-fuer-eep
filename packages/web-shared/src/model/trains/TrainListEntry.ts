import TrainType from './TrainType';

interface TrainListEntry {
  id: string;
  name: string;
  route: string;
  line: string;
  destination: string;
  trainType: TrainType;
  trackType: string;
  rollingStockCount: number;
}

export default TrainListEntry;
export { TrainListEntry };
