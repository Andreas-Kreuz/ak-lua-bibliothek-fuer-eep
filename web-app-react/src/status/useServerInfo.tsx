import { useState, SetStateAction } from 'react';
import { useApiDataRoomHandler } from '../io/useRoomHandler';

export function useServerStatus(): [SetStateAction<boolean>, SetStateAction<boolean>, SetStateAction<number>] {
  const [eepDataUpToDate, setEepDataUpToDate] = useState(false);
  const [luaDataReceived, setLuaDataReceived] = useState(false);
  const [apiEntryCount, setApiEntryCount] = useState(0);

  // Register for the rooms data
  useApiDataRoomHandler('api-stats', (payload: string) => {
    const data: { eepDataUpToDate: boolean; luaDataReceived: boolean; apiEntryCount: number } = JSON.parse(payload);
    setEepDataUpToDate(data.eepDataUpToDate);
    setLuaDataReceived(data.luaDataReceived);
    setApiEntryCount(data.apiEntryCount);
  });

  return [eepDataUpToDate, luaDataReceived, apiEntryCount];
}
