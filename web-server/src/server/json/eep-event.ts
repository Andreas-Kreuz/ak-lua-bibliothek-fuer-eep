export default interface EepEvent {
  type: 'CompleteReset' | 'DataAdded' | 'DataChanged' | 'DataRemoved' | 'ListChanged';
  payload: undefined;
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
