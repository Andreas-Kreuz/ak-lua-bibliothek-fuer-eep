import './Server.css';
import { useServerStatus } from './ServerStatusEffectHook';

function Server() {
  const [isConnected] = useServerStatus();

  return (
    <div className="Server">
      <h1>Server</h1>
      <p>Connected: {'' + isConnected}</p>
    </div>
  );
}

export default Server;
