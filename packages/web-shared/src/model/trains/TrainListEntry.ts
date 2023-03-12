import TrainType from './TrainType';

interface TrainListEntry {
  id: string;
  name: string;
  route: string;
  line: string;
  destination: string;
  via?: string;
  firstRollingStockName: string;
  lastRollingStockName: string;
  trainType: TrainType;
  trackType: string;
  rollingStockCount: number;
  movesForward: boolean;
}

export default TrainListEntry;
export { TrainListEntry };
