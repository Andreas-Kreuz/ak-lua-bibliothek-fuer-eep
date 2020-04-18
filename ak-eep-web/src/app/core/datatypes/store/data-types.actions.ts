import { Action } from '@ngrx/store';

export const ROOM = '[AvailableDataTypes]';
export const SET_DATA_TYPES = '[AvailableDataTypes] Set';


export class SetDataTypes implements Action {
  readonly type = SET_DATA_TYPES;

  constructor(public payload: string[]) {
  }
}

export type DataTypesActions =
  SetDataTypes;
