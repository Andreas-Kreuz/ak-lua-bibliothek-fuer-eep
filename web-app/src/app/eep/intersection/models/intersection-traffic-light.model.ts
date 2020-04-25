import { TrafficType } from './traffic-type.enum';

export class IntersectionTrafficLight {
  axisStructures: [];
  currentPhase: string; // Phase
  id: number;
  intersectionId: number;
  laneId: string;
  lightStructures: { [id: string]: string };
  modelId: string; // Signal Type Definition
  signalId: number;
  type: TrafficType;
}
