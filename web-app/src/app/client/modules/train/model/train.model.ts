import { RollingStock } from './rolling-stock.model';

export class Train {
  constructor(
    public id: string,
    public trackSystem: string,
    public trackType: string,
    public rollingStock: RollingStock[],
    public rollingStockCount: number,
    public route: string,
    public length: number,
    public line: string,
    public destination: string,
    public direction: string,
    public speed: number
  ) {}
}
