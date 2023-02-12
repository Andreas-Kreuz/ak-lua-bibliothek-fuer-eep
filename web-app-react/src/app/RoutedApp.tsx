import React, { Suspense, lazy } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import ErrorBoundary from './ErrorBoundary';

const AppHomeWithSnack = lazy(() => import('./AppHomeWithSnack'));
const Server = lazy(() => import('../server/Server'));
const StatusGrid = lazy(() => import('../status/StatusGrid'));

function RoutedApp() {
  return (
    <ErrorBoundary>
      <Router>
        <Suspense fallback={<div>Loading...</div>}>
          <Routes>
            <Route path="/" element={<AppHomeWithSnack />} />
            <Route path="/status" element={<StatusGrid />} />
            <Route path="/server" element={<Server />} />
          </Routes>
        </Suspense>
      </Router>
    </ErrorBoundary>
  );
}

export default RoutedApp;
