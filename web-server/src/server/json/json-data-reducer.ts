import EepEvent, { DataChangePayload } from './eep-event';
import JsonDataEffects from './json-data-effects';

interface State {
  rooms: Record<string, Record<string, unknown>>;
}

const initialState: State = {
  rooms: {},
};

export default class JsonDataStore {
  private debug = false;
  private currentJsonContent: { [key: string]: unknown } = {};
  private urls: string[] = [];
  private dataRooms: string[] = [];
  private state: State = initialState;

  constructor(private effects: JsonDataEffects) {}

  onNewEvent(event: EepEvent) {
    switch (event.type) {
      case 'DataReset':
        {
          for (const roomName of Object.keys(this.state.rooms)) {
            this.removeDataRoom(roomName);
          }
          this.state.rooms = {};
        }
        break;
      case 'DataChanged':
        {
          const payload: DataChangePayload<unknown> = event.payload;
          const room = this.createOrReturnRoom(payload.room);
          this.createOrUpdateElement(room, payload.keyId, payload.element);
        }
        break;
      default:
        console.warn('NO SUCH event.type: ' + event.type);
        break;
    }
  }

  createOrReturnRoom(roomName: string): Record<string, unknown> {
    const oldRoom: Record<string, unknown> = this.state.rooms[roomName];
    if (oldRoom) {
      return oldRoom;
    } else {
      const room: Record<string, unknown> = {};
      this.state.rooms[roomName] = room;
      return room;
    }
  }

  createOrUpdateElement<T, K extends keyof T>(room: Record<string, T>, keyId: K, element: T): void {
    const key = element[keyId as K] as unknown as string;
    if (this.debug) console.log(keyId, key);
    let oldElement: T = room[key];
    if (!oldElement) {
      oldElement = {} as T;
    }
    const newElement = { ...oldElement, ...element } as T;
    room[key] = newElement;
  }

  getNewStateDataCopy(): { [key: string]: unknown } {
    const newMap: Record<string, unknown> = {};
    for (const room of Object.keys(this.state.rooms)) {
      newMap[room] = { ...this.state.rooms[room] };
    }
    return newMap;
  }

  calcChangedKeys(keysToCheck: string[], newJsonContent: { [key: string]: unknown }): string[] {
    const changedKeys: string[] = [];
    for (const key of keysToCheck) {
      const currentData = JSON.stringify(this.currentJsonContent[key]);
      const newData = JSON.stringify(newJsonContent[key]);
      if (currentData !== newData) {
        changedKeys.push(key);
      }
    }

    return changedKeys;
  }

  hasJsonKey(key: string): boolean {
    return Object.prototype.hasOwnProperty.call(this.currentJsonContent, key);
  }

  getJsonData(): Record<string, unknown> {
    return this.currentJsonContent;
  }

  setJsonData(newJsonContent: Record<string, unknown>): void {
    this.currentJsonContent = { ...newJsonContent };
  }

  addUrls(urls: string[]): void {
    this.urls = this.urls.concat(urls);
    this.urls.sort(this.alphabeticalSort);
  }

  removeUrls(urls: string[]): void {
    this.urls = this.urls.filter((key) => urls.indexOf(key) < 0);
  }

  getUrls(): string[] {
    return this.urls;
  }

  addDataRoom(dataType: string): void {
    this.dataRooms.push(dataType);
    this.dataRooms.sort(this.alphabeticalSort);
  }

  removeDataRoom(dataType: string): void {
    const index = this.dataRooms.indexOf(dataType);
    if (index >= 0) {
      this.dataRooms.splice(index, 1);
    }
  }

  getDataRooms(): string[] {
    return this.dataRooms;
  }

  private alphabeticalSort(a: string, b: string): number {
    if (a < b) {
      return -1;
    }
    if (a > b) {
      return 1;
    }
    return 0;
  }
}
