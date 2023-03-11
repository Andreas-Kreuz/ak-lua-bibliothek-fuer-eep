import { useApiDataRoomHandler, useDynamicRoomHandler, useRoomHandler } from '../../io/useRoomHandler';
import { TrackType, TrainListRoom } from '@ak/web-shared';
import { Train, TrainListEntry, TrainType } from '@ak/web-shared';
import { createContext, Dispatch, ReactNode, useContext, useReducer } from 'react';

export interface State {
  trackType: TrackType;
  trainList: TrainListEntry[];
  selectedTrain?: Train;
  selectedTrainName?: string;
}

export const initialState: State = {
  trackType: TrackType.Road,
  trainList: [],
  selectedTrain: undefined,
  selectedTrainName: undefined,
};

type Action = { type: 'trains updated'; trains: TrainListEntry[] } | { type: 'set track type'; trackType: TrackType };

const reducer = (state: State, action: Action) => {
  switch (action.type) {
    case 'trains updated': {
      return { ...state, trainList: action.trains };
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
