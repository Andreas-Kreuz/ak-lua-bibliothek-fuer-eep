import { Train } from '../model/train.model';
import * as TrainActions from './train.actions';
import { Action, createFeatureSelector, createReducer, createSelector, on, props } from '@ngrx/store';
import { RollingStock } from '../model/rolling-stock.model';
import { TrainType } from '../model/train-type.enum';

export interface State {
  trainType: TrainType;
  railTrains: Train[];
  railRollingStock: RollingStock[];
  roadTrains: Train[];
  roadRollingStock: RollingStock[];
  tramTrains: Train[];
  tramRollingStock: RollingStock[];
  selectedTrainName: string;
}

export const initialState: State = {
  trainType: TrainType.rail,
  railTrains: [],
  railRollingStock: [],
  roadTrains: [],
  roadRollingStock: [],
  tramTrains: [],
  tramRollingStock: [],
  selectedTrainName: null,
};

const trainReducer = createReducer(
  initialState,
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

export const reducer = (state: State | undefined, action: Action) => trainReducer(state, action);

export const trainsState$ = createFeatureSelector('train');

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
    default:
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
    let list: Train[] = null;
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
    return newTrains;
  }
);
