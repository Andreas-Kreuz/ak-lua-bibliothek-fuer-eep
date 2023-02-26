import { createContext, Dispatch, ReactNode, useContext, useReducer } from 'react';
import { LogEvent } from '@ak/web-shared';
import { useRoomHandler } from '../../io/useRoomHandler';

type LogState = {
  lines: { line: string; key: number }[];
  autoScroll: boolean;
};

type LogDispatch =
  | { type: 'added'; fetchedLines: string[] }
  | { type: 'cleared' }
  | { type: 'setAutoScroll'; autoScroll: boolean };

const initialState = { lines: [], autoScroll: true };

const reducer = (state: LogState, action: LogDispatch) => {
  switch (action.type) {
    case 'added': {
      const newLines = [...state.lines];
      var counter = state.lines.length > 0 ? state.lines[state.lines.length - 1].key : 0;
      for (const l of action.fetchedLines) {
        if (l.length > 0) {
          newLines.push({ line: l, key: ++counter });
        }
      }
      while (newLines.length > 5000) {
        newLines.shift();
      }
      return { ...state, lines: newLines };
    }
    case 'cleared': {
      return { ...state, lines: [] };
    }
    case 'setAutoScroll': {
      return { ...state, autoScroll: action.autoScroll };
    }
    default:
      throw Error();
  }
};

const LogContext = createContext<LogState | null>(null);

const LogDispatchContext = createContext<Dispatch<LogDispatch> | null>(null);

export const LogProvider = (props: { children: ReactNode }) => {
  const [state, dispatch] = useReducer(reducer, initialState);
  const roomName = LogEvent.Room;

  const dataHandlers = [
    {
      eventName: LogEvent.LinesAdded,
      handler: (data: string) => {
        console.log('               |⚠️- FIRED -- ', data);
        const fetchedLines = data.split('\n');
        dispatch({ type: 'added', fetchedLines });
      },
    },
    {
      eventName: LogEvent.LinesCleared,
      handler: () => {
        dispatch({ type: 'cleared' });
      },
    },
  ];

  const cleanUpHandler = () => dispatch({ type: 'cleared' });
  useRoomHandler(roomName, dataHandlers, cleanUpHandler);

  return (
    <LogContext.Provider value={state}>
      <LogDispatchContext.Provider value={dispatch}>{props.children}</LogDispatchContext.Provider>
    </LogContext.Provider>
  );
};

export function useLog() {
  return useContext(LogContext);
}

export function useLogDispatch() {
  return useContext(LogDispatchContext);
}
