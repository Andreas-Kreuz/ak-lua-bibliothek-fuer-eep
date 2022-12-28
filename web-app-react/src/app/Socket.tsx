import io from 'socket.io-client';
import { createContext, useState, useEffect } from 'react';

const socketUrl = window.location.protocol + '//' + window.location.hostname + ':3000';
export const socket = io(socketUrl, { autoConnect: false });
export const SocketContext = createContext(socket);

export function useSocketStatus() {
  const [isConnected, setIsConnected] = useState(socket.connected);

  useEffect(() => {
    socket.on('connect', () => {
      setIsConnected(true);
    });

    socket.on('disconnect', () => {
      setIsConnected(false);
    });

    if (!socket.connected) {
      console.log(socket);
      socket.connect();
    }

    return () => {
      socket.off('connect');
      socket.off('disconnect');
      setIsConnected(false);
    };
  }, []);

  return isConnected;
}
