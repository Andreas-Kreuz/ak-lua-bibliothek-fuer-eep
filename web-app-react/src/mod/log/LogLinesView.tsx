import styled from '@mui/system/styled';
import useLog from './useLog';

const Ul = styled('ul')({
  m: 0,
  p: 0,
  marginBlock: 0,
  paddingInlineStart: 0,
});
const Li = styled('li')({
  fontSize: 14,
  fontFamily: 'monospace',
  listStyleType: 'none',
  whiteSpace: 'pre',
});

function LogLinesView() {
  const log = useLog();
  console.log(log);

  return (
    <Ul>
      {log.map((l) => (
        <Li key={l.key}>{l.line}</Li>
      ))}
    </Ul>
  );
}

export default LogLinesView;
