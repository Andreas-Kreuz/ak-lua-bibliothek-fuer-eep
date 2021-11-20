import * as fromGenericData from './generic-data.actions';
import { createFeatureSelector, createReducer, createSelector, on } from '@ngrx/store';
import { DataType } from 'web-shared';

export interface State {
  data: { [key: string]: Record<string, unknown> };
  dataTypes: DataType[];
}

const initialState: State = {
  data: {},
  dataTypes: [],
};

export const reducer = createReducer(
  initialState,
  on(fromGenericData.updateData, (state, { type, values }) => ({
    ...state,
    data: { ...state.data, [type]: values },
  })),
  on(fromGenericData.setDataTypes, (state, { dataTypes }) => ({ ...state, ...dataTypes }))
);

export const appState = createFeatureSelector<State>('genericData');

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
