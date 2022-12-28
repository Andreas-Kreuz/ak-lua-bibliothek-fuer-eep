import RoutedApp from './RoutedApp';
import { socket, SocketContext } from './Socket';

function SocketProvidedApp() {
  return (
    <SocketContext.Provider value={socket}>
      <RoutedApp />
    </SocketContext.Provider>
  );
}

export default SocketProvidedApp;
