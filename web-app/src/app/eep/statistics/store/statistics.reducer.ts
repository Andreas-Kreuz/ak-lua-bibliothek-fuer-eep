import { createFeatureSelector, createReducer, createSelector, on } from '@ngrx/store';
import { serverControllerUpdate } from './statistics.actions';
import TimeDesc from './time-desc';

export interface State {
  serverControllerStats: { times: TimeDesc[] }[];
  initializeStats: { initialize: TimeDesc[] };
}

const initialState: State = {
  serverControllerStats: [
    {
      times: [
        new TimeDesc('example', 5),
        new TimeDesc('collect', 6),
        new TimeDesc('encode', 60),
        new TimeDesc('write', 45),
      ],
    },
  ],
  initializeStats: {
    initialize: [new TimeDesc('init', 0)],
  },
};

const statisticsReducer = createReducer(
  initialState,
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

export const statisticsState$ = createFeatureSelector('statistics');
export const serverControllerStats$ = createSelector(statisticsState$, (state: State) =>
  state.serverControllerStats.map((l) => l.times)
);

export const reducer = statisticsReducer;
