import * as logActions from './log-file.actions';
import { createFeatureSelector, createSelector, Action, createReducer, on } from '@ngrx/store';

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

const logReducer = createReducer(
  initialState,
  on(logActions.linesCleared, (state: State) => ({ ...state, linesAsString: '', lines: [] })),
  on(logActions.linesAdded, (state: State, { lines: lines }) => {
    const newLinesAsString = state.linesAsString + lines;
    const newLines = [];
    newLines.push(...state.lines);
    for (const s of lines.split('\n')) {
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
  })
);

export const reducer = (state: State | undefined, action: Action) => logReducer(state, action);

export const logfileState$ = createFeatureSelector<State>('logViewer');

export const linesAsString$ = createSelector(logfileState$, (state: State) => state.linesAsString);
export const lines$ = createSelector(logfileState$, (state: State) => state.lines);
export const loading$ = createSelector(logfileState$, (state: State) => state.loading);
