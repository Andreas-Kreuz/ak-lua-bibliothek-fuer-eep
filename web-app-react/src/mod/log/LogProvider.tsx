import { createContext, Dispatch, ReactNode, useContext, useReducer } from 'react';
import { LogEvent } from 'web-shared';
import { useRoomHandler } from '../../io/useRoomHandler';

type LogState = { lines: { line: string; key: number }[] };

type LogDispatch = { type: 'added'; fetchedLines: string[] } | { type: 'cleared' };

const initialState = { lines: [] };

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
    default:
      throw Error();
  }
};

const LogContext = createContext<LogState | null>(null);

const LogDispatchContext = createContext<Dispatch<LogDispatch> | null>(null);

export const LogProvider = (props: { children: ReactNode }) => {
  const [state, dispatch] = useReducer(reducer, initialState);

  // Register for the rooms data
  const eventHandlers = [
    {
      eventName: LogEvent.LinesAdded,
      handler: (data: string) => {
        const fetchedLines = data.split('\n');
        dispatch({ type: 'added', fetchedLines });
      },
    },
    {
      eventName: LogEvent.LinesCleared,
      handler: (data: string) => {
        dispatch({ type: 'cleared' });
      },
    },
  ];

  useRoomHandler(LogEvent.Room, eventHandlers);

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
