export default class EepLuaSettingsDto<T> {
  constructor(
    public name: string,
    public category: string,
    public description: string,
    public eepFunction: string,
    public type: string,
    public value: T
  ) {}
}
