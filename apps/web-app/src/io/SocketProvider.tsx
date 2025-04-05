import { createContext, ReactNode, useEffect, useRef, useState } from 'react';
import { io } from 'socket.io-client';
import { useContext } from 'react';

const socketUrl = window.location.protocol + '//' + window.location.hostname + ':3000';
const socket = io(socketUrl, { autoConnect: false });

const SocketConnectedContext = createContext<boolean>(false);
const SocketUrlContext = createContext(socketUrl);
const SocketContext = createContext(socket);

const SocketProvider = (props: { children: ReactNode }) => {
  const socket = useContext(SocketContext);
  const [isConnected, setIsConnected] = useState(() => socket.connected);

  useEffect(() => {
    socket.on('connect', () => {
      console.log('☑️  "connect" event from: ', socket.id);
      setIsConnected(true);
    });

    socket.on('disconnect', () => {
      console.log('✴️  "disconnect" event from: ', socket.id);
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
};

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
