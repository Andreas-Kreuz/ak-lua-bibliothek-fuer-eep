import React, { Suspense, lazy } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { useSocketIsConnected } from '../io/useSocketIsConnected';
import ConnectingScreen from './ConnectingScreen';
import ErrorBoundary from './ErrorBoundary';

const AppHomeWithSnack = lazy(() => import('./AppHomeWithSnack'));
const Server = lazy(() => import('../server/Server'));
const StatusGrid = lazy(() => import('../status/StatusGrid'));
const IntersectionOverview = lazy(() => import('../mod/intersections/IntersectionOverview'));

function RoutedApp() {
  const socketIsConnected = useSocketIsConnected();
  if (!socketIsConnected) {
    return <ConnectingScreen />;
  } else {
    return (
      <ErrorBoundary>
        <Router>
          <Suspense fallback={<div>Loading...</div>}>
            <Routes>
              <Route path="/" element={<AppHomeWithSnack />} />
              <Route path="/status" element={<StatusGrid />} />
              <Route path="/server" element={<Server />} />
              <Route path="/intersections" element={<IntersectionOverview />} />
            </Routes>
          </Suspense>
        </Router>
      </ErrorBoundary>
    );
  }
}

export default RoutedApp;
