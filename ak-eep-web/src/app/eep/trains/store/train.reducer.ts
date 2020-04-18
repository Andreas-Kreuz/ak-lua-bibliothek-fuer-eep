import { Train } from '../model/train.model';
import { TrainActions, TrainActionTypes } from './train.actions';
import { createFeatureSelector, createSelector } from '@ngrx/store';
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
}

export const initialState: State = {
  trainType: TrainType.Rail,
  railTrains: [],
  railRollingStock: [],
  roadTrains: [],
  roadRollingStock: [],
  tramTrains: [],
  tramRollingStock: [],
};

export function reducer(state = initialState, action: TrainActions): State {
  switch (action.type) {
    case TrainActionTypes.SELECT_TYPE:
      return {
        ...state,
        trainType: action.payload,
      };
    case TrainActionTypes.SET_RAIL_TRAINS:
      return {
        ...state,
        railTrains: [...action.payload],
      };
    case TrainActionTypes.SET_RAIL_ROLLING_STOCK:
      return {
        ...state,
        railRollingStock: [...action.payload],
      };
    case TrainActionTypes.SET_ROAD_TRAINS:
      return {
        ...state,
        roadTrains: [...action.payload],
      };
    case TrainActionTypes.SET_ROAD_ROLLING_STOCK:
      return {
        ...state,
        roadRollingStock: [...action.payload],
      };
    case TrainActionTypes.SET_TRAM_TRAINS:
      return {
        ...state,
        tramTrains: [...action.payload],
      };
    case TrainActionTypes.SET_TRAM_ROLLING_STOCK:
      return {
        ...state,
        tramRollingStock: [...action.payload],
      };
    default:
      return state;
  }
}

export const trainsState$ = createFeatureSelector('train');


export const selectTrainType = createSelector(
  trainsState$, (state: State) => state.trainType
);
export const selectRailTrainCount = createSelector(
  trainsState$, (state: State) => state.railTrains.length
);
export const selectRoadTrainCount = createSelector(
  trainsState$, (state: State) => state.roadTrains.length
);
export const selectTramTrainCount = createSelector(
  trainsState$, (state: State) => state.tramTrains.length
);

export const selectRollingStock = createSelector(
  trainsState$,
  (state: State) => {
    const type = state.trainType;
    const rollingStocksByTrain = new Map<string, RollingStock[]>();
    let rollingStocks: RollingStock[];
    switch (type) {
      case 'rail':
      default:
        rollingStocks = state.railRollingStock;
        break;
      case 'road':
        rollingStocks = state.roadRollingStock;
        break;
      case 'tram':
        rollingStocks = state.tramRollingStock;
        break;
    }

    rollingStocks.sort(((a, b) => {
      const trainCompare = a.trainName.localeCompare(b.trainName);
      if (trainCompare !== 0) {
        return trainCompare;
      }
      return a.positionInTrain < b.positionInTrain
        ? -1
        : (a.positionInTrain > b.positionInTrain ? 1 : 0);
    }));

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
  }
);

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

    list.sort(((a, b) => a.id.localeCompare(b.id)));
    for (const train of list) {
      train.rollingStock = rollingStockMap.get(train.id);

      if (train.rollingStock) {
        train.length = 0;
        for (const rollingStock of train.rollingStock) {
          train.length = train.length + +rollingStock.length;
        }
      }
    }
    return list;
  }
);
