import EepEvent, { DataChangePayload, ListChangePayload } from './eep-event';
import EepDataEffects from './json-data-effects';

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
  private state: State = initialState;

  constructor(private effects: EepDataEffects) {}

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
}
