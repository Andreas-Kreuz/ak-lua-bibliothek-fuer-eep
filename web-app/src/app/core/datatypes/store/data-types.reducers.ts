import { createFeatureSelector, createSelector, createReducer, on, Action } from '@ngrx/store';

import * as fromDataTypes from './data-types.actions';

export interface State {
  availableDataTypes: string[];
  intersectionsAvailable: boolean;
}

const initialState: State = {
  availableDataTypes: [],
  intersectionsAvailable: false
};

const featureReducer = createReducer(
  initialState,
  on(fromDataTypes.setDataTypes, (state: State, { types: availableDataTypes }) => ({
    ...state,
    availableDataTypes: availableDataTypes,
    intersectionsAvailable: availableDataTypes.findIndex(dt => dt === 'intersections') !== -1,
  })),
);

export function reducer(state: State | undefined, action: Action) {
  return featureReducer(state, action);
}

export const dataTypesState$ = createFeatureSelector('dataTypes');

export const selectDataTypes = createSelector(
  dataTypesState$,
  (state: State) => state.availableDataTypes
);
export const selectIntersectionsAvailable = createSelector(
  dataTypesState$,
  (state: State) => state.intersectionsAvailable
);

