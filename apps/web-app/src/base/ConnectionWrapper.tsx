import { lazy, useMemo } from 'react';
const ClientAppMainPage = lazy(() => import('./ClientAppMainPage'));
const ClientAppMainPageWithSnack = lazy(() => import('./ClientAppMainPageWithSnack'));
const ConnectingScreen = lazy(() => import('./ConnectingScreenWrapper'));
import { useSocketIsConnected } from '../io/SocketProvider';

function ConnectionWrapper(props: { simple?: boolean }) {
  const socketIsConnected = useSocketIsConnected();

  const component = useMemo(
    () =>
      (props.simple && <ClientAppMainPage />) ||
      (socketIsConnected && <ClientAppMainPageWithSnack />) || <ConnectingScreen />,
    [props.simple, socketIsConnected],
  );

  return component;
}

export default ConnectionWrapper;
