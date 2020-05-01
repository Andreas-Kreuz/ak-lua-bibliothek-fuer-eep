export default class Room {
  static EEP_COMMAND = '[EEPCommand]';
  static LOG = '[Log]';
  static PING = '[Ping]';
  static ROOM = '[Room]';
  static URLS = '[URLs]';
  static SERVER_SETTINGS = '[Server Settings]';
  static AVAILABLE_DATA_TYPES = '[AvailableDataTypes]';

  public static ofDataType(dataType: string): string {
    return '[Data-' + dataType + ']';
  }
}
