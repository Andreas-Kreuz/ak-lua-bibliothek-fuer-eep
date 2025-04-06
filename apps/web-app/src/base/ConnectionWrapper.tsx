import { lazy } from 'react';
const ClientAppMainPage = lazy(() => import('./ClientAppMainPage'));
const ClientAppMainPageWithSnack = lazy(() => import('./ClientAppMainPageWithSnack'));
const ConnectingScreen = lazy(() => import('./ConnectingScreen'));
import { useSocketIsConnected } from '../io/SocketProvider';

function ConnectionWrapper(props: { simple?: boolean }) {
  const socketIsConnected = useSocketIsConnected();

  if (props.simple) {
    return <ClientAppMainPage />;
  } else if (socketIsConnected) {
    return <ClientAppMainPageWithSnack />;
  } else {
    return <ConnectingScreen />;
  }
}

export default ConnectionWrapper;
