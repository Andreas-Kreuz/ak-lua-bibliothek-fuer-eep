import AppHome from './AppHome';
import AppHomeWithSnack from './AppHomeWithSnack';
import ConnectingScreen from './ConnectingScreen';
import { useSocketIsConnected } from '../io/SocketProvider';

function ConnectionWrapper(props: { simple?: boolean }) {
  const socketIsConnected = useSocketIsConnected();

  if (props.simple) {
    return <AppHome />;
  } else if (socketIsConnected) {
    return <AppHomeWithSnack />;
  } else {
    return <ConnectingScreen />;
  }
}

export default ConnectionWrapper;
