import { OldTrain } from '../model/train.model';
import * as TrainActions from './train.actions';
import { Action, createFeature, createFeatureSelector, createReducer, createSelector, on, props } from '@ngrx/store';
import { RollingStock } from '../model/rolling-stock.model';
import { TrainType } from '../model/train-type.enum';
import { TrainListEntry } from 'web-shared/src/model/trains';

export interface State {
  trainType: TrainType;
  trainList: TrainListEntry[];
  selectedTrain: OldTrain;
  railTrains: OldTrain[];
  railRollingStock: RollingStock[];
  roadTrains: OldTrain[];
  roadRollingStock: RollingStock[];
  tramTrains: OldTrain[];
  tramRollingStock: RollingStock[];
  selectedTrainName: string;
}

export const initialState: State = {
  trainType: TrainType.rail,
  trainList: [],
  selectedTrain: undefined,
  railTrains: [],
  railRollingStock: [],
  roadTrains: [],
  roadRollingStock: [],
  tramTrains: [],
  tramRollingStock: [],
  selectedTrainName: undefined,
};

const trainReducer = createReducer(
  initialState,
  on(TrainActions.trainListUpdated, (state: State, { trainList }) => ({
    ...state,
    trainList,
  })),
  on(TrainActions.selectTrain, (state: State, { trainName }) => ({
    ...state,
    selectedTrainName: trainName,
  })),
  on(TrainActions.selectType, (state: State, { trainType }) => ({
    ...state,
    trainType,
  })),
  on(TrainActions.setRailTrains, (state: State, { railTrains }) => ({
    ...state,
    railTrains,
  })),
  on(TrainActions.setRailRollingStock, (state: State, { railRollingStock }) => ({
    ...state,
    railRollingStock,
  })),
  on(TrainActions.setRoadTrains, (state: State, { roadTrains }) => ({
    ...state,
    roadTrains,
  })),
  on(TrainActions.setRoadRollingStock, (state: State, { roadRollingStock }) => ({
    ...state,
    roadRollingStock,
  })),
  on(TrainActions.setTramTrains, (state: State, { tramTrains }) => ({
    ...state,
    tramTrains,
  })),
  on(TrainActions.setTramRollingStock, (state: State, { tramRollingStock }) => ({
    ...state,
    tramRollingStock,
  }))
);

export const trainFeature = createFeature({ name: 'train', reducer: trainReducer });
export const trainsState$ = createFeatureSelector<State>('train');

export const selectedTrainName = createSelector(trainsState$, (state: State) => state.selectedTrainName);
export const selectTrainType = createSelector(trainsState$, (state: State) => state.trainType);
export const selectRailTrainCount = createSelector(trainsState$, (state: State) => state.railTrains.length);
export const selectRoadTrainCount = createSelector(trainsState$, (state: State) => state.roadTrains.length);
export const selectTramTrainCount = createSelector(trainsState$, (state: State) => state.tramTrains.length);

export const selectRollingStock = createSelector(trainsState$, (state: State) => {
  const type = state.trainType;
  const rollingStocksByTrain = new Map<string, RollingStock[]>();
  let rollingStocks: RollingStock[];
  switch (type) {
    case 'rail':
      //default:
      rollingStocks = [...state.railRollingStock];
      break;
    case 'road':
      rollingStocks = [...state.roadRollingStock];
      break;
    case 'tram':
      rollingStocks = [...state.tramRollingStock];
      break;
  }

  rollingStocks.sort((a, b) => {
    const trainCompare = a.trainName.localeCompare(b.trainName);
    if (trainCompare !== 0) {
      return trainCompare;
    }
    return a.positionInTrain < b.positionInTrain ? -1 : a.positionInTrain > b.positionInTrain ? 1 : 0;
  });

  for (const rollingStock of rollingStocks) {
    let trainRs: RollingStock[];
    if (rollingStocksByTrain.has(rollingStock.trainName)) {
      trainRs = rollingStocksByTrain.get(rollingStock.trainName);
    } else {
      trainRs = [];
      rollingStocksByTrain.set(rollingStock.trainName, trainRs);
    }

    trainRs.push(rollingStock);
  }

  return rollingStocksByTrain;
});

export const selectTrains = createSelector(
  trainsState$,
  selectRollingStock,
  (state: State, rollingStockMap: Map<string, RollingStock[]>) => {
    const type = state.trainType;
    let list: OldTrain[] = null;
    switch (type) {
      case 'rail':
      default:
        list = state.railTrains;
        break;
      case 'road':
        list = state.roadTrains;
        break;
      case 'tram':
        list = state.tramTrains;
        break;
    }

    const newTrains = [];
    if (list) {
      for (const listentry of list) {
        const train = { ...listentry };
        train.rollingStock = rollingStockMap.get(train.id);

        if (train.rollingStock) {
          train.length = 0;
          for (const rollingStock of train.rollingStock) {
            train.length = train.length + rollingStock.length;
          }
        }
        newTrains.push(train);
      }
      newTrains.sort((a, b) => a.id.localeCompare(b.id));
    }
    return newTrains;
  }
);
