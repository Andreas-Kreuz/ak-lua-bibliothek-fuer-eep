import { DynamicRoom } from './rooms';

const dataRoom = new DynamicRoom('Data');
export class DataEvent {
  static roomOf(dataType: string): string {
    return dataRoom.roomId(dataType);
  }

  static eventOf(dataType: string): string {
    return dataRoom.eventIdDataChange(dataType);
  }
}
