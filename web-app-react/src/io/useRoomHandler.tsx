import { useState, useEffect, useContext } from 'react';
import { ApiDataRoom, RoomEvent } from 'web-shared';
import { SocketContext } from '../base/SocketProvidedApp';

export function useRoomHandler(roomName: string, handler: (data: any) => any): void {
  const socket = useContext(SocketContext);
  const [roomJoined, setRoomJoined] = useState<boolean>(false);

  // Register for the rooms data
  useEffect(() => {
    const eventName = ApiDataRoom.eventId(roomName);
    socket.on(eventName, (payload: string) => {
      // console.log(payload);
      const data = JSON.parse(payload);
      handler(data);
    });

    return () => {
      socket.off(eventName);
    };
  }, [socket]);

  // Join room as soon as the socket is connected
  useEffect(() => {
    const room = ApiDataRoom.roomId(roomName);
    if (socket.connected) {
      if (roomJoined) {
        // console.log('Skip joining ' + room);
      } else {
        socket.emit(RoomEvent.JoinRoom, { room });
        setRoomJoined(true);
      }
    }

    return () => {
      if (roomJoined) {
        if (socket.connected) {
          socket.emit(RoomEvent.LeaveRoom, { room });
        }
        setRoomJoined(false);
      }
    };
  }, [socket, socket.connected]);
}
