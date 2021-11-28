import TrainType from './train-type';

export default interface TrainListEntry {
  id: string;
  name: string;
  route: string;
  line: string;
  destination: string;
  trainType: number;
  trackType: string;
}
