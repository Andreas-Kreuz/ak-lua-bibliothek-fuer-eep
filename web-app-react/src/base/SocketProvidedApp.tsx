import RoutedApp from './RoutedApp';
import { createContext } from 'react';
import { io } from 'socket.io-client';

export const socketUrl = window.location.protocol + '//' + window.location.hostname + ':3000';
export const socket = io(socketUrl, { autoConnect: true });
export const SocketContext = createContext(socket);

function SocketProvidedApp() {
  return (
    <SocketContext.Provider value={socket}>
      <RoutedApp />
    </SocketContext.Provider>
  );
}

export default SocketProvidedApp;
