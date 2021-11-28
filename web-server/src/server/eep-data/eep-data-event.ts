export default interface EepDataEvent {
  type: 'CompleteReset' | 'DataAdded' | 'DataChanged' | 'DataRemoved' | 'ListChanged';
  payload: undefined;
  eventCounter: number;
}

export interface DataChangePayload<T> {
  room: string;
  keyId: string & keyof T;
  element: T;
}

export interface ListChangePayload<T> {
  room: string;
  keyId: string & keyof T;
  list: Record<string, T>;
}
