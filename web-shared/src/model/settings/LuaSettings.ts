import LuaSetting from './LuaSetting';

export class LuaSettings {
  public constructor(public moduleName: string, public settings: LuaSetting<any>[]) {}
}

export default LuaSettings;
