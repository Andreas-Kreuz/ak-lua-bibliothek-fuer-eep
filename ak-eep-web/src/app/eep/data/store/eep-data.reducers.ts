import { createFeatureSelector, createSelector } from '@ngrx/store';
import * as fromEepData from './eep-data.actions';
import { EepData } from '../models/eep-data.model';
import { EepFreeData } from '../models/eep-free-data.model';

export interface State {
  eepData: EepData[];
  eepFreeData: EepFreeData[];
}

const initialState: State = {
  eepData: [],
  eepFreeData: [],
};

export function reducer(state: State = initialState, action: fromEepData.EepDataAction) {
  switch (action.type) {
    case fromEepData.SET_SLOTS:
      return {
        ...state,
        eepData: [...action.payload],
      };
    case fromEepData.SET_FREE_SLOTS:
      return {
        ...state,
        eepFreeData: [...action.payload],
      };
    default:
      return state;
  }
}

export const eepDataState$ = createFeatureSelector('eepData');

export const eepData$ = createSelector(
  eepDataState$,
  (state: State) => state.eepData
);

export const eepDataCount$ = createSelector(
  eepDataState$,
  (state: State) => state.eepData.length
);

export const eepFreeData$ = createSelector(
  eepDataState$,
  (state: State) => state.eepFreeData
);

export const firstEepFreeData$ = createSelector(
  eepFreeData$,
  (data: EepFreeData[]) => {
    return (data.slice(0, Math.min(data.length, 20)));
  }
);
