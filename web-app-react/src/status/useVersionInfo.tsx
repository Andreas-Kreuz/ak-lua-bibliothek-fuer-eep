import { useState, SetStateAction } from 'react';
import { useApiDataRoomHandler } from '../io/useRoomHandler';

function cutOutLua(versionString: string) {
  if (versionString && versionString.startsWith('Lua ')) {
    return versionString.substring('Lua '.length);
  }
  return versionString;
}

export default function useVersionInfo(): [SetStateAction<string>, SetStateAction<string>, SetStateAction<string>] {
  const [verApp, setVerApp] = useState('?');
  const [verEep, setVerEep] = useState('?');
  const [verLua, setVerLua] = useState('?');

  // Register for the rooms data
  useApiDataRoomHandler('eep-version', (payload: string) => {
    const data = JSON.parse(payload);
    setVerApp(data.versionInfo.singleVersion);
    setVerEep(data.versionInfo.eepVersion);
    setVerLua(cutOutLua(data.versionInfo.luaVersion));
  });

  return [verApp, verEep, verLua];
}
