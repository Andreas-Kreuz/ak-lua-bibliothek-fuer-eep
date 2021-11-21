import { SignalTypeDefinition } from './signal-type-definition.model';

export class Signal {
  id: number;
  position: number;
  model: SignalTypeDefinition;
  waitingVehiclesCount: number;

  constructor(id: number, position: number, model: SignalTypeDefinition, waitingVehiclesCount: number) {
    this.id = id;
    this.position = position;
    this.model = model;
    this.waitingVehiclesCount = waitingVehiclesCount;
  }
}
