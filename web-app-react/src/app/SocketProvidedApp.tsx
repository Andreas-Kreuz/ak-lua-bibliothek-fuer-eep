import RoutedApp from './RoutedApp';
import { socket, SocketContext } from '../server-io/Socket';

function SocketProvidedApp() {
  return (
    <SocketContext.Provider value={socket}>
      <RoutedApp />
    </SocketContext.Provider>
  );
}

export default SocketProvidedApp;
