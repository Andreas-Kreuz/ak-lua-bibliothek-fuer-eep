import { createAction, props } from '@ngrx/store';
import { OldTrain } from '../model/train.model';
import { RollingStock } from '../model/rolling-stock.model';
import { TrainType } from '../model/train-type.enum';
import { TrainListEntry } from 'web-shared/build/model/trains';
import { Train } from 'web-shared/build/model/trains';

export const initModule = createAction('[Train] Init Module');
export const destroyModule = createAction('[Train] Destroy Module');
export const trainListUpdated = createAction('[Train] Train List updated', props<{ trainList: TrainListEntry[] }>());
export const selectTrain = createAction('[Train] select Train', props<{ trainName: string }>());
export const trainSelected = createAction('[Train] Train selected', props<{ train: Train }>());
export const selectType = createAction('[Train] Select Type', props<{ trainType: TrainType }>());

// export const trainsUpdated = createAction('[Train] Trains updated', props<{ json: string }>());
// export const rollingStockUpdated = createAction('[Train] RollingStock updated', props<{ json: string }>());
// export const setRailTrains = createAction('[Train] Set Rail Trains', props<{ railTrains: OldTrain[] }>());
// export const setRailRollingStock = createAction(
//   '[Train] Set Rail Rolling Stock',
//   props<{ railRollingStock: RollingStock[] }>()
// );
// export const setRoadTrains = createAction('[Train] Set Road Trains', props<{ roadTrains: OldTrain[] }>());
// export const setRoadRollingStock = createAction(
//   '[Train] Set Road Rolling Stock',
//   props<{ roadRollingStock: RollingStock[] }>()
// );
// export const setTramTrains = createAction('[Train] Set Tram Trains', props<{ tramTrains: OldTrain[] }>());
// export const setTramRollingStock = createAction(
//   '[Train] Set Tram Rolling Stock',
//   props<{ tramRollingStock: RollingStock[] }>()
// );
