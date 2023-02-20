import styled from '@mui/system/styled';
import useLog from './useLog';

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

function LogLinesView() {
  const log = useLog();

  return (
    <List>
      {log.map((l) => (
        <Entry key={l.key}>{l.line}</Entry>
      ))}
    </List>
  );
}

export default LogLinesView;
