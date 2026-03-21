import useDebug from '../../io/useDebug';
import { useApiDataRoomHandler } from '../../io/useRoomHandler';
import Intersection from './model/Intersection';
import { LuaSetting, LuaSettings } from '@ak/web-shared';
import { useState } from 'react';

function useIntersectionSettings(): LuaSettings | undefined {
  const [settings, setSettings] = useState<LuaSettings | undefined>(undefined);
  const debug = useDebug();

  useApiDataRoomHandler('road-module-settings', (payload: string) => {
    const data: LuaSetting<any>[] = Object.values(JSON.parse(payload));
    const mySettings = {
      moduleName: 'Einstellungen für Kreuzungen',
      settings: data,
    };
    if (debug) console.log('                 |⚠️ FIRED ---', 'API: road-module-settings', mySettings);
    setSettings(mySettings);
  });

  return settings;
}

export default useIntersectionSettings;
