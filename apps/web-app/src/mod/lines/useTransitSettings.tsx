import { useApiDataRoomHandler } from '../../io/useRoomHandler';
import { LuaSetting, LuaSettings } from '@ak/web-shared';
import { useState } from 'react';
import useDebug from '../../io/useDebug';

function useIntersectionSettings(): LuaSettings | undefined {
  const [settings, setSettings] = useState<LuaSettings | undefined>(undefined);
  const debug = useDebug();

  useApiDataRoomHandler('transit-module-settings', (payload: string) => {
    const data: LuaSetting<any>[] = Object.values(JSON.parse(payload));
    const mySettings = {
      moduleName: 'Einstellungen für ÖPNV',
      settings: data,
    };
    if (debug) console.log('                 |⚠️ FIRED ---', 'API: transit-module-settings', mySettings);
    setSettings(mySettings);
  });

  return settings;
}

export default useIntersectionSettings;
