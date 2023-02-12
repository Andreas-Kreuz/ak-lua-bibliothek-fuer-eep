import { useState, SetStateAction } from 'react';
import { registerRoomHandler } from '../server-io/RoomHandlerHook';

function cutOutLua(versionString: string) {
  if (versionString && versionString.startsWith('Lua ')) {
    return versionString.substring('Lua '.length);
  }
  return versionString;
}

export default function useVersionStatus(): [SetStateAction<string>, SetStateAction<string>, SetStateAction<string>] {
  const [verApp, setVerApp] = useState('?');
  const [verEep, setVerEep] = useState('?');
  const [verLua, setVerLua] = useState('?');

  // Register for the rooms data
  registerRoomHandler('eep-version', (data) => {
    setVerApp(data.versionInfo.singleVersion);
    setVerEep(data.versionInfo.eepVersion);
    setVerLua(cutOutLua(data.versionInfo.luaVersion));
  });

  return [verApp, verEep, verLua];
}
