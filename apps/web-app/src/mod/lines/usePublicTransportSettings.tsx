import { useApiDataRoomHandler } from '../../io/useRoomHandler';
import { LuaSetting, LuaSettings } from '@ak/web-shared';
import { useState } from 'react';

function useIntersectionSettings(): LuaSettings | undefined {
  const [settings, setSettings] = useState<LuaSettings | undefined>(undefined);

  useApiDataRoomHandler('public-transport-module-settings', (payload: string) => {
    const data: LuaSetting<any>[] = Object.values(JSON.parse(payload));
    const mySettings = {
      moduleName: 'Einstellungen für ÖPNV',
      settings: data,
    };
    console.log(mySettings);
    setSettings(mySettings);
  });

  return settings;
}

export default useIntersectionSettings;
