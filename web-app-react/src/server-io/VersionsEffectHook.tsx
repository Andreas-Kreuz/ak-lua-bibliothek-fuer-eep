import { version } from 'os';
import { env } from 'process';
import { useState, useEffect, useContext, SetStateAction } from 'react';
import { ApiDataRoom, RoomEvent } from 'web-shared';
import { SocketContext, useSocketStatus } from './Socket';

function cutOutLua(versionString: string) {
  if (versionString && versionString.startsWith('Lua ')) {
    return versionString.substring('Lua '.length);
  }
  return versionString;
}

export function useVersionStatus(): [SetStateAction<string>, SetStateAction<string>, SetStateAction<string>] {
  const socketIsConnected = useSocketStatus();
  const socket = useContext(SocketContext);
  const [roomJoined, setRoomJoined] = useState<boolean>(false);

  const [verApp, setVerApp] = useState('?');
  const [verEep, setVerEep] = useState('?');
  const [verLua, setVerLua] = useState('?');

  // Register for the rooms data
  useEffect(() => {
    const event = ApiDataRoom.eventId('eep-version');
    socket.on(event, (payload: string) => {
      console.log(payload);
      const data = JSON.parse(payload);
      setVerApp(data.versionInfo.singleVersion);
      setVerEep(data.versionInfo.eepVersion);
      setVerLua(cutOutLua(data.versionInfo.luaVersion));
    });

    return () => {
      socket.off(event);
    };
  }, [socket]);

  // Join room as soon as the socket is connected
  useEffect(() => {
    const room = ApiDataRoom.roomId('eep-version');
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

  return [verApp, verEep, verLua];
}
