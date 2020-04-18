import { Phase } from './phase.enum';
import { Direction } from './direction.model';
import { TrafficType } from './traffic-type.enum';
import { CountType } from './count-type.enum';

export class IntersectionLane {
  vehicleMultiplier: number;
  id: string;
  eepSaveId: number;
  intersectionId: number;
  countType: CountType;
  waitingTrains: string[];
  type: TrafficType;
  name: string;
  phase: Phase;
  directions: Direction[];
  switchings: string[];
}
