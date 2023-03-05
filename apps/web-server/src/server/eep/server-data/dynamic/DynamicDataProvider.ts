import { DynamicRoom } from '@ak/web-shared';

export interface DynamicDataProvider {
  roomType: DynamicRoom;
  id: string;
  jsonCreator: (roomName: string) => string;
}
