import { Action } from '@ngrx/store';
import { DataType } from '../model/data-type';

export const FETCH_DATA_TYPES = '[Generic Data] Fetch data types';
export const SET_DATA_TYPES = '[Generic Data] Set data types';
export const FETCH_DATA = '[Generic Data] Fetch Data';
export const SET_DATA = '[Generic Data] Set Data';

export class FetchData implements Action {
  readonly type = FETCH_DATA;

  constructor(public payload: {
    name: string,
    hostName: string,
    path: string,
  }) {
  }
}

export class UpdateData implements Action {
  readonly type = SET_DATA;

  /**
   * @param payload Data of a certain type as String
   */
  constructor(public payload: { type: string, values: {} }) {
  }
}

export class FetchDataTypes implements Action {
  readonly type = FETCH_DATA_TYPES;

  constructor(public payload: string) {
  }
}

export class SetDataTypes implements Action {
  readonly type = SET_DATA_TYPES;

  /**
   * @param payload Set all data types from remote
   */
  constructor(public payload: DataType[]) {
  }
}


export type GenericDataActions =
  FetchDataTypes |
  SetDataTypes |
  FetchData |
  UpdateData;
