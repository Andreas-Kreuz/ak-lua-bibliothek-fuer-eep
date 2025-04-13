import { useSocketUrl } from '../io/SocketProvider';
import ConnectingScreen from '../ui/ConnectingScreen';

function ConnectingScreenWrapper() {
  const socketUrl = useSocketUrl();
  return <ConnectingScreen url={socketUrl} />;
}

export default ConnectingScreenWrapper;
