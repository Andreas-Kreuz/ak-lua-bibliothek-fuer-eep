import { Suspense, lazy } from 'react';
import { BrowserRouter as Router, RouterProvider, createBrowserRouter } from 'react-router-dom';
import MainMenu from '../home/MainMenu';
import { useSocketIsConnected } from '../io/useSocketIsConnected';
import IntersectionOverview from '../mod/intersections/IntersectionOverview';
import ConnectingScreen from './ConnectingScreen';
import ErrorBoundary from './ErrorBoundary';

const AppHomeWithSnack = lazy(() => import('./AppHomeWithSnack'));
const Server = lazy(() => import('../server/Server'));
const StatusGrid = lazy(() => import('../status/StatusGrid'));

const childRoutes = [
  { path: '/', element: <MainMenu /> },
  { path: '/intersections', element: <IntersectionOverview /> },
];

export const router = createBrowserRouter([
  { path: '/', element: <AppHomeWithSnack />, children: childRoutes },
  { path: '/status', element: <StatusGrid /> },
  { path: '/server', element: <Server /> },
]);

function RoutedApp() {
  const socketIsConnected = useSocketIsConnected();
  if (!socketIsConnected) {
    return <ConnectingScreen />;
  } else {
    return (
      <ErrorBoundary>
        <Suspense fallback={<div>Loading...</div>}>
          <RouterProvider router={router} />
        </Suspense>
      </ErrorBoundary>
    );
  }
}

export default RoutedApp;
