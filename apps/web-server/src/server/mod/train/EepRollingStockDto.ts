export default class EepRollingStockDto {
  constructor(
    public id: string,
    public name: string,
    public trainName: string,
    public positionInTrain: number,
    public couplingFront: number,
    public couplingRear: number,
    public length: number,
    public propelled: boolean,
    public trackSystem: number,
    public trackType: string,
    public modelType: number,
    public modelTypeText: string,
    public tag: string,
    public nr: string | undefined,
    public trackId: number,
    public trackDistance: number,
    public trackDirection: number,
    public posX: number,
    public posY: number,
    public posZ: number,
    public mileage: number
  ) {}
}
