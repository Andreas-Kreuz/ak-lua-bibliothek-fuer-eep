import { useEffect, useContext } from 'react';
import { ApiDataRoom, RoomEvent } from 'web-shared';
import { SocketContext } from '../base/SocketProvidedApp';
import { useSocketIsConnected } from './useSocketIsConnected';

export function useApiDataRoomHandler(apiName: string, handler: (data: any) => any): void {
  return useRoomHandler(ApiDataRoom.roomId(apiName), [{ eventName: ApiDataRoom.eventId(apiName), handler: handler }]);
}

export function useRoomHandler(
  roomName: string,
  eventHandlers: { eventName: string; handler: (data: any) => any }[]
): void {
  const socket = useContext(SocketContext);
  const socketIsConnected = useSocketIsConnected();

  // Register for the rooms data
  useEffect(() => {
    eventHandlers.map((h) => {
      socket.on(h.eventName, (payload: string) => {
        h.handler(payload);
      });
    });

    socket.emit(RoomEvent.JoinRoom, { room: roomName });

    return () => {
      socket.emit(RoomEvent.LeaveRoom, { room: roomName });
      eventHandlers.map((h) => {
        socket.off(h.eventName);
      });
    };
  }, [socket, socketIsConnected]);
}
