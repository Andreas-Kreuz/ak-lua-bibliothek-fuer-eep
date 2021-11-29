export default interface RollingStock {
  id: string;
  name: string;
  trainName: string;
  positionInTrain: number;
  couplingFront: number;
  couplingRear: number;
  length: number;
  propelled: number;
  trackSystem: string;
  trackType: string;
  modelType: number;
  tag: string;
}
