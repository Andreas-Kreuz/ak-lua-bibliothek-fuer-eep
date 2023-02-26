export class LuaSetting<T> {
  public constructor(
    public category: string,
    public name: string,
    public description: string,
    public type: string,
    public value: T,
    public eepFunction: string
  ) {}
}

export default LuaSetting;
