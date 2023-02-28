import { useApiDataRoomHandler, useDynamicRoomHandler, useRoomHandler } from '../../io/useRoomHandler';
import { TrainListRoom } from '@ak/web-shared';
import { Train, TrainListEntry, TrainType } from '@ak/web-shared';
import { createContext, Dispatch, ReactNode, useContext, useReducer } from 'react';

export interface State {
  trainType: TrainType;
  trainList: TrainListEntry[];
  selectedTrain?: Train;
  selectedTrainName?: string;
}

export const initialState: State = {
  trainType: TrainType.Bike,
  trainList: [],
  selectedTrain: undefined,
  selectedTrainName: undefined,
};

type Action = { type: 'trains updated'; trains: TrainListEntry[] };

const reducer = (state: State, action: Action) => {
  switch (action.type) {
    case 'trains updated': {
      return { ...state, trainList: action.trains };
    }
    default:
      throw Error();
  }
};

const TrainContext = createContext<State | null>(null);

const TrainDispatchContext = createContext<Dispatch<Action> | null>(null);

export const TrainProvider = (props: { children: ReactNode }) => {
  const [state, dispatch] = useReducer(reducer, initialState);

  useDynamicRoomHandler(TrainListRoom, 'road', (payload: string) => {
    const data: Record<string, TrainListEntry> = JSON.parse(payload);
    const trains = Object.values(data).sort((a, b) => (a.id < b.id ? -1 : 1));
    // TODO dispatch({ type: 'trains updated', trains: trains });
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
