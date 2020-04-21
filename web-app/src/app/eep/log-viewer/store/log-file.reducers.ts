import * as fromLogFile from './log-file.actions';
import { createFeatureSelector, createSelector } from '@ngrx/store';

export interface State {
  loading: boolean;
  linesAsString: string;
  lines: string[];
}

const initialState: State = {
  loading: true,
  linesAsString: '',
  lines: [],
};

export function reducer(state: State = initialState, action: fromLogFile.LogFileActions) {
  switch (action.type) {
    case fromLogFile.LINES_ADDED:
      const newLinesAsString = state.linesAsString + action.payload;
      const newLines = [];
      newLines.push(...state.lines);
      for (const s of action.payload.split('\n')) {
        if (s.length > 0) {
          newLines.push(s);
        }
      }
      return {
        ...state,
        loading: false,
        linesAsString: newLinesAsString,
        lines: newLines,
      };
    case fromLogFile.CLEARED:
      return {
        ...state,
        linesAsString: '',
        lines: [],
      };
    default:
      return state;
  }
}

export const logfileState$ = createFeatureSelector('logViewer');

export const linesAsString$ = createSelector(
  logfileState$,
  (state: State) => state.linesAsString
);
export const lines$ = createSelector(
  logfileState$,
  (state: State) => state.lines
);
export const loading$ = createSelector(
  logfileState$,
  (state: State) => state.loading
);
