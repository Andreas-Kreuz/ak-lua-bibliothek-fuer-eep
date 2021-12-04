import * as fromEepData from '../../eep-data-reducer';
import { LuaSetting, LuaSettings, EepLuaSettingsDto } from 'web-shared/build/model/settings';

export default class PublicTransportSettingsSelector {
  private lastState: fromEepData.State = undefined;
  private settings: LuaSettings = new LuaSettings('Public Transport', []);

  updateFromState(state: fromEepData.State): void {
    this.settings = new LuaSettings('Public Transport', []);

    if (state === this.lastState || !state.rooms['public-transport-module-settings']) {
      return;
    }

    const settingsDict = state.rooms['public-transport-module-settings'] as unknown as Record<
      string,
      EepLuaSettingsDto<unknown>
    >;
    Object.values(settingsDict).forEach((settingDto: EepLuaSettingsDto<unknown>) => {
      const setting: LuaSetting<unknown> = {
        name: settingDto.name,
        category: settingDto.category,
        description: settingDto.description,
        eepFunction: settingDto.eepFunction,
        type: settingDto.type,
        value: settingDto.value,
      };
      this.settings.settings.push(setting);
    });
  }

  getSettings = () => this.settings;
}
