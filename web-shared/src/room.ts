export class Room {
  static readonly EEP_COMMAND = '[EEPCommand]';
  static readonly LOG = '[Log]';
  static readonly PING = '[Ping]';
  static readonly ROOM = '[Room]';
  static readonly URLS = '[URLs]';
  static readonly SERVER_SETTINGS = '[Server Settings]';
  static readonly AVAILABLE_DATA_TYPES = '[AvailableDataTypes]';

  static ofDataType(dataType: string): string {
    return '[Data-' + dataType + ']';
  }
}
