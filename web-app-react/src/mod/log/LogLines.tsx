import Box from '@mui/material/Box';
import { styled } from '@mui/material/styles';
import { useEffect, useRef, useState } from 'react';
import { useLog, useLogDispatch } from './LogProvider';

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

function LogLines() {
  const logState = useLog();
  const lines = logState?.lines;
  const autoScroll = logState?.autoScroll;
  const logDispatch = useLogDispatch();
  const messagesEndRef = useRef<HTMLDivElement | null>(null);
  const listRef = useRef<HTMLUListElement>();

  const scrollToBottom = () => {
    if (autoScroll) {
      messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }
  };

  useEffect(() => {
    scrollToBottom();
  }, [lines, autoScroll]);

  return (
    <Box
      ref={listRef}
      height="14.2em"
      width="calc(100vw)"
      sx={{
        overflow: 'auto',
        pt: 1,
        px: 1,
      }}
    >
      <List>
        {lines?.map((l) => (
          <Entry key={l.key}>{l.line}</Entry>
        ))}
      </List>
      <div ref={messagesEndRef} />
    </Box>
  );
}

export default LogLines;
