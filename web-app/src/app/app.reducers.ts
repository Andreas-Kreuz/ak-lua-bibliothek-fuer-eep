import { ActionReducerMap } from '@ngrx/store';

import * as fromCore from './core/store/core.reducers';
import * as fromStatistics from './eep/statistics/store/statistics.reducer';

export interface State {
  core: fromCore.State;
  statistics: fromStatistics.State;
}

export const reducers: ActionReducerMap<State> = {
  core: fromCore.reducer,
  statistics: fromStatistics.reducer,
};
