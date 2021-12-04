import LuaSetting from './lua-setting';

export default class LuaSettingChangeEvent {
  constructor(public setting: LuaSetting<any>, public newValue: any) {}
}
