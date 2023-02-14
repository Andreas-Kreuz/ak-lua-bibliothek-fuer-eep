import { useState, useEffect, useContext } from 'react';
import { SocketContext } from '../base/SocketProvidedApp';

export function useSocketIsConnected() {
  const socket = useContext(SocketContext);
  const [isConnected, setIsConnected] = useState(socket.connected);

  useEffect(() => {
    socket.on('connect', () => {
      // console.log('Received "Connect": ', socket);
      setIsConnected(true);
    });

    socket.on('disconnect', () => {
      setIsConnected(false);
    });

    if (socket.connected) {
      // console.log('Already Connected: ', socket);
      setIsConnected(true);
    } else {
      socket.connect();
    }

    return () => {
      setIsConnected(false);
      socket.off('connect');
      socket.off('disconnect');
    };
  }, []);

  return isConnected;
}
