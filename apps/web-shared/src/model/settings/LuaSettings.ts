import LuaSetting from './LuaSetting';

class LuaSettings {
  public constructor(public moduleName: string, public settings: LuaSetting<any>[]) {}
}

export default LuaSettings;
export { LuaSettings };
