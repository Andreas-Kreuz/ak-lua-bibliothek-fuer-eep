import { useState, useEffect, useContext } from 'react';
import { ApiDataRoom, RoomEvent } from 'web-shared';
import { SocketContext } from '../base/SocketProvidedApp';
import { useSocketIsConnected } from './useSocketIsConnected';

export function useApiDataRoomHandler(apiName: string, handler: (data: any) => any): void {
  return useRoomHandler(ApiDataRoom.roomId(apiName), ApiDataRoom.eventId(apiName), handler);
}

export function useRoomHandler(roomName: string, eventName: string, handler: (data: any) => any): void {
  const socket = useContext(SocketContext);
  const socketIsConnected = useSocketIsConnected();
  const [roomJoined, setRoomJoined] = useState<boolean>(false);

  // Register for the rooms data
  useEffect(() => {
    socket.on(eventName, (payload: string) => {
      // console.log('Handle: ', eventName, '(', roomName, '):', payload);
      handler(payload);
    });

    return () => {
      socket.off(eventName);
    };
  }, [socket, socketIsConnected]);

  // Join room as soon as the socket is connected
  useEffect(() => {
    if (socketIsConnected) {
      if (roomJoined) {
        // console.log('Join Room (skipped): ', roomName);
      } else {
        // console.log('Join Room: ', roomName, 'for Event:', eventName);
        socket.emit(RoomEvent.JoinRoom, { room: roomName });
        setRoomJoined(true);
      }
    }

    return () => {
      // console.log('Leave Room: ', roomName, 'Sockect connected: ' + socket.connected);
      if (roomJoined) {
        if (socket.connected) {
          socket.emit(RoomEvent.LeaveRoom, { room: roomName });
        }
        setRoomJoined(false);
      }
    };
  }, [socket, socketIsConnected]);
}
