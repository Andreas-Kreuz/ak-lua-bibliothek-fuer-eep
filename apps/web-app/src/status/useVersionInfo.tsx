import { useState, SetStateAction } from 'react';
import { useApiDataRoomHandler } from '../io/useRoomHandler';
import VersionInfo from './VersionInfo';

function cutOutLua(versionString: string) {
  if (versionString && versionString.startsWith('Lua ')) {
    return versionString.substring('Lua '.length);
  }
  return versionString;
}

export interface Versions {
  appVersion: string;
  eepVersion: string;
  luaVersion: string;
}

export default function useVersionInfo(): Versions {
  const [versions, setVersions] = useState<Versions>({
    appVersion: '?',
    eepVersion: '?',
    luaVersion: '?',
  });

  // Register for the rooms data
  useApiDataRoomHandler('eep-version', (payload: string) => {
    const data = JSON.parse(payload);
    setVersions({
      appVersion: data.versionInfo.singleVersion,
      eepVersion: data.versionInfo.eepVersion,
      luaVersion: cutOutLua(data.versionInfo.luaVersion),
    });
  });

  return versions;
}
