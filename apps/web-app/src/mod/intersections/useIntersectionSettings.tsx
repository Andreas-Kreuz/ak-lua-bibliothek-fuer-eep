import { useApiDataRoomHandler } from '../../io/useRoomHandler';
import Intersection from './model/Intersection';
import { LuaSetting, LuaSettings } from '@ak/web-shared';
import { useState } from 'react';

function useIntersectionSettings(): LuaSettings | undefined {
  const [settings, setSettings] = useState<LuaSettings | undefined>(undefined);

  useApiDataRoomHandler('intersection-module-settings', (payload: string) => {
    const data: LuaSetting<any>[] = Object.values(JSON.parse(payload));
    const mySettings = {
      moduleName: 'Einstellungen für Kreuzungen',
      settings: data,
    };
    console.log(mySettings);
    setSettings(mySettings);
  });

  return settings;
}

export default useIntersectionSettings;
