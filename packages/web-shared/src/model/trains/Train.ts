import RollingStock from './RollingStock';
import TrainType from './TrainType';

interface Train {
  id: string;
  name: string;
  route: string;
  line: string;
  destination: string;
  trainType: TrainType;
  trackSystem: string;
  trackType: string;
  rollingStock: RollingStock[];
  length: number;
  direction: string;
  speed: number;
}

export default Train;
export { Train };
