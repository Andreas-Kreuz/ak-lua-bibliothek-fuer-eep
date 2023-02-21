import { LogProvider } from './LogProvider';
import LogPanel from './LogPanel';

const LogMod = () => {
  return (
    <LogProvider>
      <LogPanel />
    </LogProvider>
  );
};

export default LogMod;
