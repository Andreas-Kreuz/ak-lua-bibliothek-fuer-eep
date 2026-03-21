import LuaSetting from './LuaSetting';

export class LuaSettingChangeEvent {
  constructor(public setting: LuaSetting<any>, public newValue: any) {}
}

export default LuaSettingChangeEvent;
