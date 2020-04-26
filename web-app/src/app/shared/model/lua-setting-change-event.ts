import { LuaSetting } from './lua-setting';

export class LuaSettingChangeEvent {
  constructor(public setting: LuaSetting<any>, public newValue: any) {}
}
