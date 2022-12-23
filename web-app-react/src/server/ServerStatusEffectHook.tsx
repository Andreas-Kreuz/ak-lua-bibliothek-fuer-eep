import { useState, useEffect, useContext } from 'react';
import { RoomEvent } from 'web-shared';
import { ApiDataRoom } from 'web-shared/build/rooms';
import { SocketContext } from './Socket';

export function useServerStatus() {
  const socket = useContext(SocketContext);
  const room = ApiDataRoom.roomId('api-stats');
  const event = ApiDataRoom.eventId('api-stats');

  const [isConnected, setIsConnected] = useState(socket.connected);
  const [eepDataUpToDate, setEepDataUpToDate] = useState(false);
  const [luaDataReceived, setLuaDataReceived] = useState(false);
  const [apiEntryCount, setApiEntryCount] = useState(0);

  useEffect(() => {
    console.log('Join Room on already connected socket ...');
    socket.emit(RoomEvent.JoinRoom, { room });

    console.log(socket);

    socket.on('connect', () => {
      setIsConnected(true);
    });

    socket.on('disconnect', () => {
      setIsConnected(false);
    });

    socket.on(event, (payload: string) => {
      console.log(payload);
      const data = JSON.parse(payload);
      setEepDataUpToDate(data.eepDataUpToDate);
      setLuaDataReceived(data.luaDataReceived);
      setApiEntryCount(data.apiEntryCount);
    });

    return () => {
      socket.emit(RoomEvent.LeaveRoom, { room });
      socket.off(event);
      socket.off('connect');
      socket.off('disconnect');
    };
  }, [event, room, socket]);

  return [isConnected, eepDataUpToDate, luaDataReceived, apiEntryCount];
}
