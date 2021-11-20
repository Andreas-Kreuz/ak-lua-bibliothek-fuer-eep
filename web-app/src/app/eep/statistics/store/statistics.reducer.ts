import { createFeatureSelector, createReducer, createSelector, on } from '@ngrx/store';
import { dataCollectorUpdate, dataInitializeUpdate, serverControllerUpdate } from './statistics.actions';
import TimeDesc from './time-desc';

export interface State {
  collectorInitStats: { times: TimeDesc[] };
  serverControllerStats: { times: TimeDesc[] }[];
  collectorRefreshStats: { times: TimeDesc[] }[];
}

const initialState: State = {
  collectorInitStats: { times: [new TimeDesc('init', 0)] },
  serverControllerStats: [],
  collectorRefreshStats: [],
};

const statisticsReducer = createReducer(
  initialState,
  on(dataInitializeUpdate, (state: State, { times }) => ({
    ...state,
    collectorInitStats: { times },
  })),
  on(dataCollectorUpdate, (state: State, { times }) => {
    const newEntry = { times };
    const lastList = state.collectorRefreshStats;
    const last9 = lastList.length > 9 ? lastList.slice(1, 10) : lastList;

    return {
      ...state,
      collectorRefreshStats: [...last9, newEntry],
    };
  }),
  on(serverControllerUpdate, (state: State, { times }) => {
    const newEntry = { times };
    const lastList = state.serverControllerStats;
    const last9 = lastList.length > 9 ? lastList.slice(1, 10) : lastList;

    return {
      ...state,
      serverControllerStats: [...last9, newEntry],
    };
  })
);

export const statisticsState$ = createFeatureSelector<State>('statistics');
export const collectorInitStats$ = createSelector(statisticsState$, (state: State) => state.collectorInitStats.times);
export const collectorRefreshStats$ = createSelector(statisticsState$, (state: State) =>
  state.collectorRefreshStats.map((l) => l.times)
);
export const serverControllerStats$ = createSelector(statisticsState$, (state: State) =>
  state.serverControllerStats.map((l) => l.times)
);

export const reducer = statisticsReducer;
