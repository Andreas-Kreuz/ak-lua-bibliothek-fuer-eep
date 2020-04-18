import { Action } from '@ngrx/store';
import { Train } from '../model/train.model';
import { RollingStock } from '../model/rolling-stock.model';
import { TrainType } from '../model/train-type.enum';

export enum TrainActionTypes {
  SELECT_TYPE = '[Train] Select Type',
  SET_RAIL_TRAINS = '[Train] Set Rail Trains',
  SET_RAIL_ROLLING_STOCK = '[Train] Set Rail Rolling Stock',
  SET_ROAD_TRAINS = '[Train] Set Road Trains',
  SET_ROAD_ROLLING_STOCK = '[Train] Set Road Rolling Stock',
  SET_TRAM_TRAINS = '[Train] Set Tram Trains',
  SET_TRAM_ROLLING_STOCK = '[Train] Set Tram Rolling Stock',
}


export class SelectType implements Action {
  readonly type = TrainActionTypes.SELECT_TYPE;

  constructor(public payload: TrainType) {
  }
}

export class SetRailTrains implements Action {
  readonly type = TrainActionTypes.SET_RAIL_TRAINS;

  constructor(public payload: Train[]) {
  }
}

export class SetRailRollingStock implements Action {
  readonly type = TrainActionTypes.SET_RAIL_ROLLING_STOCK;

  constructor(public payload: RollingStock[]) {
  }
}

export class SetRoadTrains implements Action {
  readonly type = TrainActionTypes.SET_ROAD_TRAINS;

  constructor(public payload: Train[]) {
  }
}

export class SetRoadRollingStock implements Action {
  readonly type = TrainActionTypes.SET_ROAD_ROLLING_STOCK;

  constructor(public payload: RollingStock[]) {
  }
}

export class SetTramTrains implements Action {
  readonly type = TrainActionTypes.SET_TRAM_TRAINS;

  constructor(public payload: Train[]) {
  }
}

export class SetTramRollingStock implements Action {
  readonly type = TrainActionTypes.SET_TRAM_ROLLING_STOCK;

  constructor(public payload: RollingStock[]) {
  }
}

export type TrainActions =
  SelectType
  | SetRailTrains
  | SetRailRollingStock
  | SetRoadTrains
  | SetRoadRollingStock
  | SetTramTrains
  | SetTramRollingStock;
