export class RollingStock {
  constructor(public name: string,
              public trainName: string,
              public positionInTrain: number,
              public couplingFront: number,
              public couplingRear: number,
              public length: number,
              public propelled: number,
              public trackSystem: string,
              public modelType: number,
              public tag: string) {
  }
}
