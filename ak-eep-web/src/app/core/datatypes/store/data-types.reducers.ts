import { createFeatureSelector, createSelector } from '@ngrx/store';

import * as fromDataTypes from './data-types.actions';

export interface State {
  availableDataTypes: string[];
  intersectionsAvailable: boolean;
}

const initialState: State = {
  availableDataTypes: [],
  intersectionsAvailable: false
};

export function reducer(state: State = initialState, action: fromDataTypes.DataTypesActions) {
  switch (action.type) {
    case fromDataTypes.SET_DATA_TYPES:
      const l: string[] = [...action.payload];
      return {
        ...state,
        availableDataTypes: l,
        intersectionsAvailable: l.findIndex(dt => dt === 'intersections') !== -1,
      };
    default:
      return state;
  }
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

