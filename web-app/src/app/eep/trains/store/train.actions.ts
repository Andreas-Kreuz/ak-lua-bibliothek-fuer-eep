import { createAction, props } from '@ngrx/store';
import { Train } from '../model/train.model';
import { RollingStock } from '../model/rolling-stock.model';
import { TrainType } from '../model/train-type.enum';

export const selectTrain = createAction('[Train] Train selected', props<{ trainName: string }>());
export const selectType = createAction('[Train] Select Type', props<{ trainType: TrainType }>());
export const setRailTrains = createAction('[Train] Set Rail Trains', props<{ railTrains: Train[] }>());
export const setRailRollingStock = createAction(
  '[Train] Set Rail Rolling Stock',
  props<{ railRollingStock: RollingStock[] }>()
);
export const setRoadTrains = createAction('[Train] Set Road Trains', props<{ roadTrains: Train[] }>());
export const setRoadRollingStock = createAction(
  '[Train] Set Road Rolling Stock',
  props<{ roadRollingStock: RollingStock[] }>()
);
export const setTramTrains = createAction('[Train] Set Tram Trains', props<{ tramTrains: Train[] }>());
export const setTramRollingStock = createAction(
  '[Train] Set Tram Rolling Stock',
  props<{ tramRollingStock: RollingStock[] }>()
);
