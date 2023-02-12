import { useState, useEffect, useContext, SetStateAction } from 'react';
import { useRoomData } from '../server-io/RoomHandlerHook';
import { SocketContext, useSocketStatus } from '../server-io/Socket';

export function useServerStatus(): [
  SetStateAction<boolean>,
  SetStateAction<boolean>,
  SetStateAction<boolean>,
  SetStateAction<number>
] {
  const socketIsConnected = useSocketStatus();
  const socket = useContext(SocketContext);

  const [eepDataUpToDate, setEepDataUpToDate] = useState<boolean>(false);
  const [luaDataReceived, setLuaDataReceived] = useState(false);
  const [apiEntryCount, setApiEntryCount] = useState(0);

  // Register for the rooms data
  useRoomData('api-stats', (data) => {
    setEepDataUpToDate(data.eepDataUpToDate);
    setLuaDataReceived(data.luaDataReceived);
    setApiEntryCount(data.apiEntryCount);
  });

  return [socketIsConnected, eepDataUpToDate, luaDataReceived, apiEntryCount];
}
