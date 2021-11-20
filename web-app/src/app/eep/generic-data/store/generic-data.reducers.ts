import * as fromGenericData from './generic-data.actions';
import { createFeatureSelector, createSelector } from '@ngrx/store';
import { DataType } from 'web-shared';

export interface State {
  data: { [key: string]: Record<string, unknown> };
  dataTypes: DataType[];
}

const initialState: State = {
  data: {},
  dataTypes: [],
};

export const reducer = (state: State = initialState, action: fromGenericData.GenericDataActions) => {
  switch (action.type) {
    case fromGenericData.SET_DATA:
      const type = action.payload.type;
      const values = action.payload.values;
      const newData = {
        ...state.data,
        [type]: values,
      };
      const newState = {
        ...state,
        data: newData,
      };

      return newState;
    case fromGenericData.SET_DATA_TYPES:
      return {
        ...state,
        dataTypes: action.payload,
      };
    default:
      return state;
  }
};

export const appState = createFeatureSelector('genericData');

export const selectedDataStructure = (dataName: string) =>
  createSelector(appState, (state: State) => {
    const values = [];
    const columns = [];

    const data = state.data[dataName];
    if (data) {
      for (const d of Object.keys(data)) {
        const datum = data[d];
        values.push(datum);

        const allPropertyNames = Object.keys(datum);
        for (const columnName of allPropertyNames) {
          if (columns.indexOf(columnName) < 0) {
            columns.push(columnName);
          }
        }
      }
    }

    columns.sort((a: string, b: string) => {
      if (a === 'id') {
        return -1;
      }
      if (b === 'id') {
        return 1;
      }
      if (a === 'name') {
        return b === 'id' ? 1 : -1;
      }
      if (b === 'name') {
        return a === 'id' ? -1 : 1;
      }
      if (a < b) {
        return -1;
      } else {
        return 1;
      }
    });

    values.sort((a: Record<string, unknown>, b: Record<string, unknown>) => {
      const columnName = columns[0];
      return a[columnName] < b[columnName] ? -1 : 1;
    });

    return {
      dataName,
      valueColumns: columns,
      values,
    };
  });

export const selectDataTypes$ = createSelector(appState, (state: State) => state.dataTypes);
