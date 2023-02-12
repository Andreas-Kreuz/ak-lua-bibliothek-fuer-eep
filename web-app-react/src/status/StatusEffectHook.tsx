import { useState, SetStateAction } from 'react';
import { registerRoomHandler } from '../server-io/RoomHandlerHook';

export function useServerStatus(): [SetStateAction<boolean>, SetStateAction<boolean>, SetStateAction<number>] {
  const [eepDataUpToDate, setEepDataUpToDate] = useState(false);
  const [luaDataReceived, setLuaDataReceived] = useState(false);
  const [apiEntryCount, setApiEntryCount] = useState(0);

  // Register for the rooms data
  registerRoomHandler('api-stats', (data) => {
    setEepDataUpToDate(data.eepDataUpToDate);
    setLuaDataReceived(data.luaDataReceived);
    setApiEntryCount(data.apiEntryCount);
  });

  return [eepDataUpToDate, luaDataReceived, apiEntryCount];
}
