import './Client.css';
import React, { useState, useEffect } from 'react';
import io from 'socket.io-client';

const socket = io('localhost:3000');

function Client() {
  const [isConnected, setIsConnected] = useState(socket.connected);

  useEffect(() => {
    socket.on('connect', () => {
      console.log('Connected to socket!');
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
    <div className="Client">
      <h1>Client</h1>
      <p>Connected: {'' + isConnected}</p>
    </div>
  );
}

export default Client;
