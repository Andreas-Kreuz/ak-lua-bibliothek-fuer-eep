import React, { Suspense, lazy } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

const Client = lazy(() => import('./AppHomeWithSnack'));
const Server = lazy(() => import('../server/Server'));

function RoutedApp() {
  return (
    <Router>
      <Suspense fallback={<div>Loading...</div>}>
        <Routes>
          <Route path="/" element={<Client />} />
          <Route path="/server" element={<Server />} />
        </Routes>
      </Suspense>
    </Router>
  );
}

export default RoutedApp;
