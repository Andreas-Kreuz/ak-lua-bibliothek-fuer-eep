import { LuaSetting } from './lua-setting';

export class LuaSettings {
  public constructor(
    public moduleName: string,
    public settings: LuaSetting<any>[]) { }
}
