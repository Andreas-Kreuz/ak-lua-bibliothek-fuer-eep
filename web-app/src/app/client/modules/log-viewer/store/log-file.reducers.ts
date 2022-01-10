import * as logActions from './log-file.actions';
import { createFeatureSelector, createSelector, Action, createReducer, on } from '@ngrx/store';

export interface State {
  loading: boolean;
  lines: string[];
}

const initialState: State = {
  loading: true,
  lines: [],
};

const logReducer = createReducer(
  initialState,
  on(logActions.linesCleared, (state: State) => ({ ...state, loading: false, lines: [] })),
  on(logActions.linesAdded, (state: State, { lines: lines }) => {
    const newLines = [...state.lines];
    const fetchedLines = lines.split('\n');
    for (const s of fetchedLines) {
      if (s.length > 0) {
        newLines.push(s);
      }
    }
    while (newLines.length > 10000) {
      newLines.shift();
    }
    return {
      ...state,
      loading: false,
      lines: newLines,
    };
  })
);

export const reducer = (state: State | undefined, action: Action) => logReducer(state, action);

export const logfileState$ = createFeatureSelector<State>('logViewer');

export const lines$ = createSelector(logfileState$, (state: State) => state.lines);
export const loading$ = createSelector(logfileState$, (state: State) => state.loading);
