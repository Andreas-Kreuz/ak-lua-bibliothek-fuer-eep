import { ActionReducerMap } from '@ngrx/store';

import * as fromCore from './core/store/core.reducers';

export interface State {
  core: fromCore.State;
}

export const reducers: ActionReducerMap<State> = {
  core: fromCore.reducer,
};
