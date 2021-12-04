import LuaSetting from './lua-setting';

export default class LuaSettings {
  public constructor(public moduleName: string, public settings: LuaSetting<any>[]) {}
}
