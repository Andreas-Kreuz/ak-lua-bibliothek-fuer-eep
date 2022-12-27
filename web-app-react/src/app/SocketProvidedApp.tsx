import App from './App';
import { socket, SocketContext } from './Socket';

function SocketProvidedApp() {
  return (
    <SocketContext.Provider value={socket}>
      <App />
    </SocketContext.Provider>
  );
}

export default SocketProvidedApp;
