export default interface EepEvent {
  counter: number;
  date: string;
  type: unknown;
  payload: undefined;
}

export interface DataChangePayload<T> {
  eventId: string;
  changeType: string;
  room: string;
  keyId: string & keyof T;
  element: T;
}
