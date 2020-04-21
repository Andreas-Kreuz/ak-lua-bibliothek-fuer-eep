import { EepData } from '../models/eep-data.model';
import { Action } from '@ngrx/store';
import { EepFreeData } from '../models/eep-free-data.model';

export const FETCH_SLOTS = '[EEP-Data] Fetch slots';
export const SET_SLOTS = '[EEP-Data] Set slots';
export const FETCH_FREE_SLOTS = '[EEP-Data] Fetch free slots';
export const SET_FREE_SLOTS = '[EEP-Data] Set free slots';

export interface FetchAction extends Action {
  payload: string;
}

export class FetchSlots implements Action, FetchAction {
  readonly type = FETCH_SLOTS;

  constructor(public payload: string) {
  }
}

export class SetSlots implements Action {
  readonly type = SET_SLOTS;

  constructor(public payload: EepData[]) {
  }
}

export class FetchFreeSlots implements Action, FetchAction {
  readonly type = FETCH_FREE_SLOTS;

  constructor(public payload: string) {
  }
}

export class SetFreeSlots implements Action {
  readonly type = SET_FREE_SLOTS;

  constructor(public payload: EepFreeData[]) {
  }
}

export type EepDataAction =
  FetchSlots
  | SetSlots
  | FetchFreeSlots
  | SetFreeSlots;
