export default class EepTrainDto {
  constructor(
    public id: string,
    public name: string,
    public trackSystem: string,
    public trackType: string,
    public rollingStockCount: number,
    public route: string,
    public length: number,
    public line: string,
    public destination: string,
    public direction: string,
    public speed: number,
    public movesForward: boolean
  ) {}
}
