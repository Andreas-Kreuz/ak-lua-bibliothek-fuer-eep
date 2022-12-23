import './Server.css';
import React, { useState, useEffect } from 'react';
import io from 'socket.io-client';

const socket = io('localhost:3000');

function Server() {
  const [isConnected, setIsConnected] = useState(socket.connected);

  useEffect(() => {
    socket.on('connect', () => {
      setIsConnected(true);
    });
    socket.on('disconnect', () => {
      setIsConnected(false);
    });

    return () => {
      socket.off('connect');
      socket.off('disconnect');
    };
  }, []);

  return (
    <div className="Server">
      <h1>Server</h1>
      <p>Connected: {'' + isConnected}</p>
    </div>
  );
}

export default Server;
