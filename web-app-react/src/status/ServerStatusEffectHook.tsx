import { env } from 'process';
import { useState, useEffect, useContext, SetStateAction } from 'react';
import { ApiDataRoom, RoomEvent } from 'web-shared';
import { SocketContext, useSocketStatus } from '../app/Socket';

export function useServerStatus(): [
  SetStateAction<boolean>,
  SetStateAction<boolean>,
  SetStateAction<boolean>,
  SetStateAction<number>
] {
  const socketIsConnected = useSocketStatus();
  const socket = useContext(SocketContext);

  const [roomJoined, setRoomJoined] = useState<boolean>(false);
  const [eepDataUpToDate, setEepDataUpToDate] = useState<boolean>(false);
  const [luaDataReceived, setLuaDataReceived] = useState(false);
  const [apiEntryCount, setApiEntryCount] = useState(0);

  // Register for the rooms data
  useEffect(() => {
    const event = ApiDataRoom.eventId('api-stats');
    socket.on(event, (payload: string) => {
      console.log(payload);
      const data = JSON.parse(payload);
      setEepDataUpToDate(data.eepDataUpToDate);
      setLuaDataReceived(data.luaDataReceived);
      setApiEntryCount(data.apiEntryCount);
    });

    return () => {
      socket.off(event);
    };
  }, [socket]);

  // Join room as soon as the socket is connected
  useEffect(() => {
    const room = ApiDataRoom.roomId('api-stats');
    if (socketIsConnected) {
      if (roomJoined) {
        console.log('Skip joining ' + room);
      } else {
        socket.emit(RoomEvent.JoinRoom, { room });
        setRoomJoined(true);
      }
    }

    return () => {
      if (socketIsConnected && roomJoined) {
        socket.emit(RoomEvent.LeaveRoom, { room });
        setRoomJoined(false);
      }
    };
  }, [socket, socketIsConnected]);

  return [socketIsConnected, eepDataUpToDate, luaDataReceived, apiEntryCount];
}
