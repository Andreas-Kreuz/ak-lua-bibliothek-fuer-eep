import { useApiDataRoomHandler, useDynamicRoomHandler, useRoomHandler } from '../../io/useRoomHandler';
import { RollingStock, TrackType, TrainListRoom } from '@ak/web-shared';
import { Train, TrainListEntry, TrainType } from '@ak/web-shared';
import { createContext, Dispatch, ReactNode, useContext, useReducer } from 'react';

export interface State {
  trackType: TrackType;
  trainList: TrainListEntry[];
  rollingStock: Record<string, RollingStock>;
  selectedTrain?: Train;
  selectedTrainName?: string;
}

export const initialState: State = {
  trackType: TrackType.Road,
  trainList: [],
  rollingStock: {},
  selectedTrain: undefined,
  selectedTrainName: undefined,
};

type Action =
  | { type: 'trains updated'; trains: TrainListEntry[] }
  | { type: 'rollingstock updated'; rollingStock: Record<string, RollingStock> }
  | { type: 'set track type'; trackType: TrackType };

const reducer = (state: State, action: Action) => {
  switch (action.type) {
    case 'trains updated': {
      return { ...state, trainList: action.trains };
    }
    case 'rollingstock updated': {
      return { ...state, rollingStock: action.rollingStock };
    }
    case 'set track type': {
      return { ...state, trackType: action.trackType };
    }
    default:
      throw Error();
  }
};

const TrainContext = createContext<State | null>(null);

const TrainDispatchContext = createContext<Dispatch<Action> | null>(null);

export const TrainProvider = (props: { children: ReactNode }) => {
  const [state, dispatch] = useReducer(reducer, initialState);

  useDynamicRoomHandler(TrainListRoom, state.trackType, (payload: string) => {
    const data: Record<string, TrainListEntry> = JSON.parse(payload);
    const trains = Object.values(data).sort((a, b) => (a.id < b.id ? -1 : 1));
    dispatch({ type: 'trains updated', trains: trains });
  });

  useApiDataRoomHandler('rolling-stocks', (payload: string) => {
    const data: Record<string, RollingStock> = JSON.parse(payload);
    dispatch({
      type: 'rollingstock updated',
      rollingStock: data,
    });
  });

  return (
    <TrainContext.Provider value={state}>
      <TrainDispatchContext.Provider value={dispatch}>{props.children}</TrainDispatchContext.Provider>
    </TrainContext.Provider>
  );
};

export function useTrain() {
  return useContext(TrainContext);
}

export function useTrainDispatch() {
  return useContext(TrainDispatchContext);
}
