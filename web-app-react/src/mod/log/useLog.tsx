import { useReducer, useState } from 'react';
import { LogEvent } from 'web-shared';
import { useRoomHandler } from '../../io/useRoomHandler';

const initialState = { lines: [] };
const reducer = (
  state: { lines: { line: string; key: number }[] },
  action: { type: 'added'; fetchedLines: string[] } | { type: 'cleared' }
) => {
  switch (action.type) {
    case 'added': {
      const newLines = [...state.lines];
      var counter = state.lines.length > 0 ? state.lines[state.lines.length - 1].key : 0;
      for (const l of action.fetchedLines) {
        if (l.length > 0) {
          newLines.push({ line: l, key: ++counter });
        }
      }
      while (newLines.length > 10) {
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

function useLog(): { line: string; key: number }[] {
  const [state, dispatch] = useReducer(reducer, initialState);

  useRoomHandler(LogEvent.Room, LogEvent.LinesAdded, (data: string) => {
    const fetchedLines = data.split('\n');
    // console.log('Dispatch:', fetchedLines);
    dispatch({ type: 'added', fetchedLines });
  });

  useRoomHandler(LogEvent.Room, LogEvent.LinesCleared, (data: string) => {
    dispatch({ type: 'cleared' });
  });

  return state.lines;
}

export default useLog;
