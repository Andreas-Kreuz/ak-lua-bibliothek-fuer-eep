import { ActionReducerMap } from '@ngrx/store';

import * as fromCore from './core/store/core.reducers';
import * as fromDataTypes from './core/datatypes/store/data-types.reducers';
import * as fromTrain from './eep/trains/store/train.reducer';
import * as fromStatistics from './eep/statistics/store/statistics.reducer';

export interface State {
  core: fromCore.State;
  dataTypes: fromDataTypes.State;
  train: fromTrain.State;
  statistics: fromStatistics.State;
}

export const reducers: ActionReducerMap<State> = {
  core: fromCore.reducer,
  dataTypes: fromDataTypes.reducer,
  train: fromTrain.reducer,
  statistics: fromStatistics.reducer,
};
