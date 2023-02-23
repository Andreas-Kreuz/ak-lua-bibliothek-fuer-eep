import { useEffect, useContext } from 'react';
import { ApiDataRoom, RoomEvent } from 'web-shared';
import { useSocket } from './SocketProvider';

export function useApiDataRoomHandler(apiName: string, handler: (data: any) => any): void {
  return useRoomHandler(ApiDataRoom.roomId(apiName), [{ eventName: ApiDataRoom.eventId(apiName), handler: handler }]);
}

export function useRoomHandler(
  roomName: string,
  eventHandlers: { eventName: string; handler: (data: any) => any }[]
): void {
  const socket = useSocket();

  // Register for the rooms data
  useEffect(() => {
    eventHandlers.map((h) => {
      socket.on(h.eventName, (payload: string) => {
        h.handler(payload);
      });
    });

    return () => {
      eventHandlers.map((h) => {
        socket.off(h.eventName);
      });
    };
  }, [socket]);

  // Join the room ONCE
  useEffect(() => {
    socket.emit(RoomEvent.JoinRoom, { room: roomName });
    return () => {
      socket.emit(RoomEvent.LeaveRoom, { room: roomName });
    };
  }, [socket]);
}
