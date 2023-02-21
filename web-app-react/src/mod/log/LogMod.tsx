import { LogProvider } from './LogProvider';
import LogView from './LogView';

const LogMod = () => {
  return (
    <LogProvider>
      <LogView />
    </LogProvider>
  );
};

export default LogMod;
