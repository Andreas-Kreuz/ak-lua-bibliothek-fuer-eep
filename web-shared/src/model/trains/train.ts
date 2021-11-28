import RollingStock from './rolling-stock';
import TrainType from './train-type';

export default interface Train {
  id: string;
  name: string;
  route: string;
  line: string;
  destination: string;
  trainType: number;
  trackSystem: string;
  trackType: string;
  rollingStock: RollingStock[];
  length: number;
  direction: string;
  speed: number;
}
