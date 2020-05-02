export class Room {
  //static readonly EepCommand = '[Command Event]';
  //static readonly Log = '[Log]';
  //static readonly Ping = '[Ping]';
  //static readonly Room = '[Room]';
  static readonly JsonUrls = '[JsonUrls]';
  //static readonly ServerSettings = '[Server Settings]';
  static readonly AvailableDataTypes = '[AvailableDataTypes]';

  static ofDataType(dataType: string): string {
    return '[Data-' + dataType + ']';
  }
}
