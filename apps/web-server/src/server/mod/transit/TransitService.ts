import * as fromEepData from '../../eep/server-data/EepDataStore';
import { DynamicDataProvider } from '../../eep/server-data/dynamic/DynamicDataProvider';
import DynamicRoomService from '../../eep/server-data/dynamic/DynamicRoomService';
import TransitSettingsSelector from './TransitSettingsSelector';
import {
  // TransitLineListRoom,
  // TransitLineDetailsRoom,
  // TransitStationListRoom,
  // TransitStationDetailsRoom,
  TransitSettingsRoom,
} from '@ak/web-shared';
import { Server } from 'socket.io';

export default class TransitService implements DynamicRoomService {
  private roomDataProviders: DynamicDataProvider[] = [];
  private publicTransportSettingsSelector = new TransitSettingsSelector();

  constructor(private io: Server) {
    this.roomDataProviders.push({
      roomType: TransitSettingsRoom,
      id: 'TransitSettingsRoom',
      jsonCreator: (room: string): string => {
        const _trackType = TransitSettingsRoom.idOfRoom(room);
        const json = JSON.stringify(this.publicTransportSettingsSelector.getSettings());
        return json;
      },
    });
  }

  getUpdaters = () => [
    {
      updateFromState: (state: Readonly<fromEepData.State>) => {
        this.publicTransportSettingsSelector.updateFromState(state);
      },
    },
  ];

  getDataProviders = () => this.roomDataProviders;
}
