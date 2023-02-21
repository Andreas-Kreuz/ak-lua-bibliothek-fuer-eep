import { styled } from '@mui/material/styles';
import { useEffect, useRef } from 'react';
import { useLog } from './LogProvider';

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

function LogLinesView(props: { autoScroll?: boolean }) {
  const log = useLog()?.lines;
  const log2 = useLog()?.lines;
  const messagesEndRef = useRef<HTMLDivElement | null>(null);

  const scrollToBottom = () => {
    if (props.autoScroll) {
      messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }
  };

  useEffect(() => {
    scrollToBottom();
  }, [log, props.autoScroll]);

  return (
    <List>
      {log?.map((l) => (
        <Entry key={l.key}>{l.line}</Entry>
      ))}
      <div ref={messagesEndRef} />
    </List>
  );
}

export default LogLinesView;
