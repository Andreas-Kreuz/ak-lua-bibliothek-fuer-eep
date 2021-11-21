import { createFeature, createFeatureSelector, createReducer, createSelector, on } from '@ngrx/store';
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

export const eepDataFeature = createFeature({
  name: 'eepData',
  reducer: createReducer(
    initialState,
    on(fromEepData.setSlots, (state, { slots }) => ({
      ...state,
      eepData: [...slots],
    })),
    on(fromEepData.setFreeSlots, (state, { freeSlots }) => ({
      ...state,
      eepFreeData: [...freeSlots],
    }))
  ),
});

export const eepDataState$ = createFeatureSelector<State>('eepData');

export const eepData$ = createSelector(eepDataState$, (state: State) => state.eepData);

export const eepDataCount$ = createSelector(eepDataState$, (state: State) => state.eepData.length);

export const eepFreeData$ = createSelector(eepDataState$, (state: State) => state.eepFreeData);

export const firstEepFreeData$ = createSelector(eepFreeData$, (data: EepFreeData[]) =>
  data.slice(0, Math.min(data.length, 20))
);
