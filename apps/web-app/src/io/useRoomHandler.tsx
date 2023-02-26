import { useEffect, useRef, useState } from 'react';
import { ApiDataRoom, LogEvent, RoomEvent } from '@ak/web-shared';
import { useSocket } from './SocketProvider';

export function useApiDataRoomHandler(apiName: string, handler: (data: any) => any): void {
  return useRoomHandler(ApiDataRoom.roomId(apiName), [{ eventName: ApiDataRoom.eventId(apiName), handler: handler }]);
}

export function useRoomHandler(
  roomName: string,
  dataHandlers: { eventName: string; handler: (data: any) => any }[],
  cleanUpHandler?: () => void
): void {
  const debug = true;
  const socket = useSocket();
  const [registered, setRegistered] = useState(false);
  const count = useRef(0);
  count.current = count.current + 1;
  const myNr = count.current;

  useEffect(() => {
    if (debug) console.log(roomName, myNr, 'REGISTERING EFFECT', count);
    dataHandlers.forEach((h) => {
      if (debug) console.log('               |✅- On ---  ', h.eventName);
      socket.off(h.eventName, h.handler);
      socket.on(h.eventName, h.handler);
    });

    setRegistered(true);

    return () => {
      if (debug) console.log(roomName, myNr, 'LEAVE ROOM', count);
      socket.emit(RoomEvent.LeaveRoom, { room: roomName });

      if (debug) console.log(roomName, myNr, 'REMOVING EFFECT', count);
      dataHandlers.forEach((h) => {
        if (debug) console.log('               |❌- Off ---  ', h.eventName);
        socket.off(h.eventName, h.handler);
      });
      if (cleanUpHandler) cleanUpHandler();
    };
  }, []);

  useEffect(() => {
    if (registered) {
      if (debug) console.log(roomName, myNr, 'JOIN ROOM', count);
      socket.emit(RoomEvent.JoinRoom, { room: roomName });
    }

    return () => {
      if (debug) console.log(roomName, myNr, 'LEAVE ROOM', count);
      socket.emit(RoomEvent.LeaveRoom, { room: roomName });
    };
  }, [registered]);
}
