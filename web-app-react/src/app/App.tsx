import React, { Suspense, lazy } from 'react';
import './App.css';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

const Client = lazy(() => import('../client/Client'));
const Server = lazy(() => import('../server/Server'));

function App() {
  return (
    <Router>
      <Suspense fallback={<div>Loading...</div>}>
        <Routes>
          <Route
            path="/"
            element={
              <div>
                <Client />
                <Server />
              </div>
            }
          />
        </Routes>
      </Suspense>
    </Router>
  );
}

export default App;
