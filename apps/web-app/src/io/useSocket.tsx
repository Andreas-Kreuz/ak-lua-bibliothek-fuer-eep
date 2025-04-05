import { useEffect, useRef } from 'react';
import io from 'socket.io-client';

const url = window.location.protocol + '//' + window.location.hostname + ':3000';

export const useSocket = () => {
  const socket = useRef(io(url));

  useEffect(() => {
    const connectListener = () => {
      console.log('☑️  "connect" event from: ', socket.current.id);
    };
    socket.current.on('connect', connectListener);

    const disconnectListener = () => {
      console.log('✴️  "disconnect" event from: ', socket.current.id);
    };
    socket.current.on('disconnect', disconnectListener);

    return () => {
      if (socket) {
        socket.current.disconnect();
        socket.current.off('connect', connectListener);
        socket.current.off('connect', disconnectListener);
      }
    };
  }, [socket.current]);

  return socket.current;
};

export default useSocket;
