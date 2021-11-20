import EepEvent, { DataChangePayload, ListChangePayload } from './eep-event';
import JsonDataEffects from './json-data-effects';
import { DataType } from 'web-shared';

export interface State {
  eventCounter: number;
  rooms: Record<string, Record<string, unknown>>;
}

const initialState: State = {
  eventCounter: 0,
  rooms: {},
};

export interface ServerData {
  roomToJson: Record<string, string>;
  urls: string[];
  urlJson: string;
}

const initialData: ServerData = {
  roomToJson: {},
  urls: [],
  urlJson: JSON.stringify([]),
};

export default class JsonDataStore {
  private debug = false;
  private data = initialData;
  private state: State = initialState;

  constructor(private effects: JsonDataEffects) {}

  onNewEvent(event: EepEvent) {
    this.state = JsonDataStore.updateStateOnEepEvent(event, this.state);
  }

  init(previousState: State) {
    if (previousState && previousState.eventCounter && previousState.rooms) {
      this.state = previousState;
    } else {
      this.state = initialState;
    }
  }

  private static updateStateOnEepEvent(event: EepEvent, state: State): State {
    switch (event.type) {
      case 'CompleteReset':
        return {
          ...state,
          eventCounter: event.eventCounter,
          rooms: {},
        };
        break;
      case 'DataAdded':
      case 'DataChanged': {
        const payload: DataChangePayload<unknown> = event.payload;
        const roomName = payload.room;
        const key = payload.element[payload.keyId];
        return {
          ...state,
          eventCounter: event.eventCounter,
          rooms: { ...state.rooms, [roomName]: { ...state.rooms[roomName], [key]: payload.element } },
        };
      }
      case 'DataRemoved': {
        const payload: DataChangePayload<unknown> = event.payload;
        const roomName = payload.room;
        const key = payload.element[payload.keyId];
        return {
          ...state,
          eventCounter: event.eventCounter,
          rooms: { ...state.rooms, [roomName]: { ...state.rooms[roomName], [key]: undefined } },
        };
      }
      case 'ListChanged': {
        const payload: ListChangePayload<unknown> = event.payload;
        const roomName = payload.room;
        const newEntries: Record<string, unknown> = {};
        for (const element of Object.values(payload.list)) {
          newEntries[element[payload.keyId]] = element;
        }
        return {
          ...state,
          eventCounter: event.eventCounter,
          rooms: { ...state.rooms, [roomName]: { ...state.rooms[roomName], ...newEntries } },
        };
      }
      default:
        console.warn('NO SUCH event.type: ' + event.type);
        return { ...state, eventCounter: event.eventCounter };
        break;
    }
  }

  currentState(): Readonly<State> {
    return this.state;
  }

  getEventCounter(): number {
    return this.state.eventCounter;
  }

  setLastAnnouncedData(data: ServerData): void {
    this.data = data;
  }

  getLastAnnouncedData() {
    return this.data;
  }

  static calculateData(state: State): ServerData {
    const urlPrefix = '/api/v1/';
    const data: ServerData = { roomToJson: {}, urls: [], urlJson: '' };
    const dataTypes: DataType[] = [];
    for (const roomName of Object.keys(state.rooms)) {
      // Update room data
      data.roomToJson[roomName] = JSON.stringify(state.rooms[roomName]);

      // Update URL data
      dataTypes.push({
        name: roomName,
        checksum: state.eventCounter.toString(),
        url: urlPrefix + roomName,
        count: Object.keys(state.rooms[roomName]).length,
        updated: true,
      });
    }

    // Add 'api-entries' Room
    dataTypes.push({
      name: 'api-entries',
      checksum: state.eventCounter.toString(),
      url: urlPrefix + 'api-entries',
      count: dataTypes.length + 1,
      updated: true,
    });
    data.roomToJson['api-entries'] = JSON.stringify(dataTypes);

    // Add URLs
    data.urls = dataTypes.map((dt) => dt.name).sort(JsonDataStore.alphabeticalSort);
    data.urlJson = JSON.stringify(data.urls);

    return data;
  }

  static calcChangedRooms(roomsToCheck: string[], oldData: ServerData, data: ServerData): string[] {
    const namesOfChangedRooms: string[] = [];
    for (const room of roomsToCheck) {
      if (oldData.roomToJson[room] !== data.roomToJson[room]) namesOfChangedRooms.push(room);
    }
    return namesOfChangedRooms;
  }

  roomAvailable(roomName: string): boolean {
    return Object.prototype.hasOwnProperty.call(this.data.roomToJson, roomName);
  }

  getAllRoomNames(): string[] {
    return Object.keys(this.data.roomToJson);
  }

  getRoomJsonString(roomName: string): string {
    return this.data.roomToJson[roomName];
  }

  getRoomJson(roomName: string): unknown {
    return this.state.rooms[roomName];
  }

  getUrlJson(): string {
    return this.data.urlJson;
  }
  getUrls(): string[] {
    return this.data.urls;
  }

  private static alphabeticalSort(a: string, b: string): number {
    if (a < b) {
      return -1;
    }
    if (a > b) {
      return 1;
    }
    return 0;
  }
}
