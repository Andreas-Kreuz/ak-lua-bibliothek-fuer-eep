import { styled } from '@mui/material/styles';
import { useReducer } from 'react';
import { LogEvent, RoomEvent } from 'web-shared';
import { useRoomHandler } from '../../io/useRoomHandler';

const List = styled('ul')({
  m: 0,
  p: 0,
  marginBlock: 0,
  paddingInlineStart: 0,
});

const Entry = styled('li')({
  fontSize: 14,
  fontFamily: 'monospace',
  listStyleType: 'none',
  whiteSpace: 'pre',
});

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

function LogLinesView() {
  const [state, dispatch] = useReducer(reducer, initialState);
  const roomName = LogEvent.Room;

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

  useRoomHandler(RoomEvent.JoinRoom, eventHandlers);

  const log: { line: string; key: number }[] = state.lines;

  return (
    <List>
      {log.map((l) => (
        <Entry key={l.key}>{l.line}</Entry>
      ))}
    </List>
  );
}

export default LogLinesView;
