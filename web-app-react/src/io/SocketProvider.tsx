import { createContext, ReactNode, useEffect, useState } from 'react';
import { io, Socket } from 'socket.io-client';
import { useContext } from 'react';

const SocketContext = createContext<Socket>({} as Socket);
const SocketConnectedContext = createContext<boolean>(false);
const SocketUrlContext = createContext(window.location.protocol + '//' + window.location.hostname + ':3000');

function SocketProvider(props: { children: ReactNode }) {
  const socketUrl = useContext(SocketUrlContext);
  const socket = io(socketUrl, { autoConnect: true });
  const [isConnected, setIsConnected] = useState(() => socket.connected);

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
      socket.disconnect();
      socket.off('connect');
      socket.off('disconnect');
      setIsConnected(false);
    };
  }, []);

  return (
    <SocketContext.Provider value={socket}>
      <SocketConnectedContext.Provider value={isConnected}>{props.children}</SocketConnectedContext.Provider>
    </SocketContext.Provider>
  );
}

export default SocketProvider;

export function useSocket() {
  return useContext(SocketContext);
}

export function useSocketUrl() {
  return useContext(SocketUrlContext);
}

export function useSocketIsConnected() {
  return useContext(SocketConnectedContext);
}
