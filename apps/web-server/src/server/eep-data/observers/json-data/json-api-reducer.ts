import * as fromEepStore from '../../eep-data-reducer';
import { DataType } from '@ak/web-shared';

export interface ServerData {
  rooms: Record<string, unknown>;
  roomToJson: Record<string, string>;
  urls: string[];
  urlJson: string;
}

const initialData: ServerData = {
  rooms: {},
  roomToJson: {},
  urls: [],
  urlJson: JSON.stringify([]),
};

export default class JsonApiReducer {
  private data = initialData;

  setLastAnnouncedData(data: ServerData): void {
    this.data = data;
  }

  getLastAnnouncedData() {
    return this.data;
  }

  static calculateData(state: Readonly<fromEepStore.State>): ServerData {
    const urlPrefix = '/api/v1/';
    const data: ServerData = { roomToJson: {}, rooms: {}, urls: [], urlJson: '' };
    const dataTypes: DataType[] = [];
    data.rooms = { ...state.rooms };
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

    // Add data information
    dataTypes.push({
      name: 'api-stats',
      checksum: state.eventCounter.toString(),
      url: urlPrefix + 'api-stats',
      count: 1,
      updated: true,
    });
    data.roomToJson['api-stats'] = JSON.stringify({
      eepDataUpToDate: dataTypes.length > 1,
      luaDataReceived: dataTypes.length > 1,
      apiEntryCount: dataTypes.length + 1,
    });

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
    data.urls = dataTypes.map((dt) => dt.name).sort(JsonApiReducer.alphabeticalSort);
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
    return this.data.rooms[roomName];
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
