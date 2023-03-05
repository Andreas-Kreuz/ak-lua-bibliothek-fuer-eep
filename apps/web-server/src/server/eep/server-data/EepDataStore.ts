import { DataChangePayload } from './DataChangePayload';
import EepDataEvent from './EepDataEvent';
import { ListChangePayload } from './ListChangePayload';

export interface State {
  eventCounter: number;
  rooms: Record<string, Record<string, unknown>>;
}

const initialState: State = {
  eventCounter: 0,
  rooms: {},
};

export default class EepDataStore {
  private debug = false;
  private state: State = initialState;

  constructor() {}

  onNewEvent(event: EepDataEvent) {
    this.state = EepDataStore.updateStateOnEepEvent(event, this.state);
  }

  init(previousState: State) {
    if (previousState && previousState.eventCounter && previousState.rooms) {
      this.state = previousState;
    } else {
      this.state = initialState;
    }
  }

  private static updateStateOnEepEvent(event: EepDataEvent, state: State): State {
    switch (event.type) {
      case 'CompleteReset':
        console.log('Resetting state');
        return {
          eventCounter: event.eventCounter,
          rooms: {},
        };
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
        // We assign the key to an unused variable to get the remaining entries
        // eslint-disable-next-line @typescript-eslint/no-unused-vars
        const { [key]: _, ...remainingEntries } = state.rooms[roomName];
        return {
          ...state,
          eventCounter: event.eventCounter,
          rooms: { ...state.rooms, [roomName]: remainingEntries },
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
    }
  }

  currentState(): Readonly<State> {
    return this.state;
  }

  getEventCounter(): number {
    return this.state.eventCounter;
  }

  hasInitialState(): boolean {
    return this.state === initialState;
  }
}
