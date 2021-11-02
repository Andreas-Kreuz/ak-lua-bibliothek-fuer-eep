import { Action } from '@ngrx/store';
import { Train } from '../model/train.model';
import { RollingStock } from '../model/rolling-stock.model';
import { TrainType } from '../model/train-type.enum';

export enum TrainActionTypes {
  selectType = '[Train] Select Type',
  setRailTrains = '[Train] Set Rail Trains',
  setRailRollingStock = '[Train] Set Rail Rolling Stock',
  setRoadTrains = '[Train] Set Road Trains',
  setRoadRollingStock = '[Train] Set Road Rolling Stock',
  setTramTrains = '[Train] Set Tram Trains',
  setTramRollingStock = '[Train] Set Tram Rolling Stock',
}

export class SelectType implements Action {
  readonly type = TrainActionTypes.selectType;

  constructor(public payload: TrainType) {}
}

export class SetRailTrains implements Action {
  readonly type = TrainActionTypes.setRailTrains;

  constructor(public payload: Train[]) {}
}

export class SetRailRollingStock implements Action {
  readonly type = TrainActionTypes.setRailRollingStock;

  constructor(public payload: RollingStock[]) {}
}

export class SetRoadTrains implements Action {
  readonly type = TrainActionTypes.setRoadTrains;

  constructor(public payload: Train[]) {}
}

export class SetRoadRollingStock implements Action {
  readonly type = TrainActionTypes.setRoadRollingStock;

  constructor(public payload: RollingStock[]) {}
}

export class SetTramTrains implements Action {
  readonly type = TrainActionTypes.setTramTrains;

  constructor(public payload: Train[]) {}
}

export class SetTramRollingStock implements Action {
  readonly type = TrainActionTypes.setTramRollingStock;

  constructor(public payload: RollingStock[]) {}
}

export type TrainActions =
  | SelectType
  | SetRailTrains
  | SetRailRollingStock
  | SetRoadTrains
  | SetRoadRollingStock
  | SetTramTrains
  | SetTramRollingStock;
