export interface DataChangePayload<T> {
  room: string;
  keyId: string & keyof T;
  element: T;
}
