import { createContext, ReactNode, useEffect, useRef, useState } from 'react';
import { io } from 'socket.io-client';
import { useContext } from 'react';
import useDebug from './useDebug';

const socketUrl = window.location.protocol + '//' + window.location.hostname + ':3000';
const socket = io(socketUrl, { autoConnect: false });

const SocketConnectedContext = createContext<boolean>(false);
const SocketUrlContext = createContext(socketUrl);
const SocketContext = createContext(socket);

const SocketProvider = (props: { children: ReactNode }) => {
  const socket = useContext(SocketContext);
  const [isConnected, setIsConnected] = useState(() => socket.connected);
  const debug = useDebug();

  useEffect(() => {
    const connector = () => {
      if (debug) console.log('SOCKET CONNECT    ☑️☑️☑️☑️☑️', socket.id, "'connect' received");
      setIsConnected(true);
    };

    const disconnector = () => {
      if (debug) console.log('SOCKET DISCONNECT ✴️✴️✴️✴️✴️', socket.id, "'disconnect' received");
      setIsConnected(false);
    };

    socket.on('connect', connector);

    socket.on('disconnect', disconnector);

    if (socket.connected) {
      setIsConnected(true);
    } else {
      socket.connect();
    }

    return () => {
      if (socket) {
        socket.disconnect();
        socket.off('connect', connector);
        socket.off('disconnect', disconnector);
      }
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
