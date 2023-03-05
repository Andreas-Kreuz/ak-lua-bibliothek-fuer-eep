export interface ListChangePayload<T> {
  room: string;
  keyId: string & keyof T;
  list: Record<string, T>;
}
