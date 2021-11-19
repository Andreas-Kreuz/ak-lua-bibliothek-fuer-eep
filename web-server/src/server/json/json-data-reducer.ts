import EepEvent, { DataChangePayload, ListChangePayload } from './eep-event';
import JsonDataEffects from './json-data-effects';

export interface State {
  eventCounter: number;
  rooms: Record<string, Record<string, unknown>>;
}

const initialState: State = {
  eventCounter: 0,
  rooms: {},
};

export default class JsonDataStore {
  private debug = false;
  private currentJsonContent: { [key: string]: unknown } = {};
  private urls: string[] = [];
  private state: State = initialState;

  constructor(private effects: JsonDataEffects) {}

  onNewEvent(event: EepEvent) {
    this.state = this.updateStateOnEepEvent(event, this.state);
  }

  private updateStateOnEepEvent(event: EepEvent, state: State): State {
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

  currentState(): State {
    return this.state;
  }

  getEventCounter(): number {
    return this.state.eventCounter;
  }

  calcChangedRooms(roomsToCheck: string[], newJsonContent: { [key: string]: unknown }): string[] {
    const namesOfChangedRooms: string[] = [];
    for (const key of roomsToCheck) {
      const currentData = JSON.stringify(this.currentJsonContent[key]);
      const newData = JSON.stringify(newJsonContent[key]);
      if (currentData !== newData) {
        namesOfChangedRooms.push(key);
      }
    }

    return namesOfChangedRooms;
  }

  hasJsonKey(key: string): boolean {
    return Object.prototype.hasOwnProperty.call(this.currentJsonContent, key);
  }

  getJsonData(): Record<string, unknown> {
    return this.currentJsonContent;
  }

  setLastAnnouncedState(newJsonContent: Record<string, unknown>): void {
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
