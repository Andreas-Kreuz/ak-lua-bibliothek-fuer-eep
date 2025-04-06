import { lazy } from 'react';
const AppHome = lazy(() => import('./AppHome'));
const AppHomeWithSnack = lazy(() => import('./AppHomeWithSnack'));
const ConnectingScreen = lazy(() => import('./ConnectingScreen'));
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
