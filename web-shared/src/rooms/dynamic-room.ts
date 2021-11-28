export default class DynamicRoom {
  constructor(private prefix: string) {}

  roomIdFor(entryId: string): string {
    return this.prefix + entryId;
  }

  matchesRoom(roomId: string) {
    return roomId.indexOf(this.prefix) === 0;
  }

  entryIdOf(roomId: string): string {
    if (roomId.indexOf(this.prefix) === 0) {
      return roomId.substring(this.prefix.length);
    } else {
      throw new Error('roomId does not start with prefix: ' + roomId);
    }
  }
}
