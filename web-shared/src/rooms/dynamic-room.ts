export default class DynamicRoom {
  private dataPrefix: string;
  private dataPostfix: string;
  private roomPrefix: string;
  private roomPostfix: string;

  constructor(private roomName: string) {
    this.dataPrefix = '[DataChange - ' + this.roomName + ": '";
    this.dataPostfix = "']";
    this.roomPrefix = '[Room - ' + roomName + ": '";
    this.roomPostfix = "']";
  }

  roomId(entryId: string): string {
    return this.roomPrefix + entryId + this.roomPostfix;
  }

  eventIdDataChange(entryId: string): string {
    return this.dataPrefix + entryId + this.dataPostfix;
  }

  matchesRoom(roomId: string) {
    return roomId.indexOf(this.roomPrefix) === 0;
  }

  entryIdOf(roomId: string): string {
    if (roomId.indexOf(this.roomPrefix) === 0) {
      return roomId.substring(this.roomPrefix.length, roomId.length - 2);
    } else {
      throw new Error('roomId does not start with prefix: ' + roomId);
    }
  }
}
