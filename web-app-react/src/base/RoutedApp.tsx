import { Suspense, lazy } from 'react';
import { BrowserRouter as Router, RouterProvider, createBrowserRouter, Outlet } from 'react-router-dom';
import ErrorBoundary from './ErrorBoundary';

const IntersectionOverview = lazy(() => import('../mod/intersections/IntersectionOverview'));
const MainMenu = lazy(() => import('../home/MainMenu'));
const Server = lazy(() => import('../server/Server'));
const StatusGrid = lazy(() => import('../status/StatusGrid'));
const ConnectionWrapper = lazy(() => import('./ConnectionWrapper'));

const homeRoutes = [
  { path: '/', element: <MainMenu /> },
  { path: '/intersections', element: <IntersectionOverview /> },
];

export const router = createBrowserRouter([
  {
    path: '/simple',
    element: <ConnectionWrapper simple />,
    children: homeRoutes.map((r) => {
      return { path: '/simple' + r.path, element: r.element };
    }),
  },
  { path: '/', element: <ConnectionWrapper />, children: homeRoutes },
  { path: '/status', element: <StatusGrid /> },
  { path: '/server', element: <Server /> },
]);

function RoutedApp() {
  return (
    <ErrorBoundary>
      <Suspense fallback={<div>Loading...</div>}>
        <RouterProvider router={router} />
      </Suspense>
    </ErrorBoundary>
  );
}

export default RoutedApp;
