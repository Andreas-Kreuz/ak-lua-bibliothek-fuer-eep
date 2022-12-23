import React, { Suspense, lazy } from 'react';
import './App.css';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { socket, SocketContext } from './server/Socket';

const Client = lazy(() => import('./client/Client'));
const Server = lazy(() => import('./server/Server'));

function App() {
  return (
    <SocketContext.Provider value={socket}>
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
    </SocketContext.Provider>
  );
}

export default App;
