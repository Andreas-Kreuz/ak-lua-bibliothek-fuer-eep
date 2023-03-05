import * as fromEepData from '../../eep/server-data/EepDataStore';
import { DynamicDataProvider } from '../../eep/server-data/dynamic/DynamicDataProvider';
import DynamicRoomService from '../../eep/server-data/dynamic/DynamicRoomService';
import PublicTransportSettingsSelector from './PublicTransportSettingsSelector';
import {
  // PublicTransportLineListRoom,
  // PublicTransportLineDetailsRoom,
  // PublicTransportStationListRoom,
  // PublicTransportStationDetailsRoom,
  PublicTransportSettingsRoom,
} from '@ak/web-shared';
import { Server } from 'socket.io';

export default class PublicTransportService implements DynamicRoomService {
  private roomDataProviders: DynamicDataProvider[] = [];
  private publicTransportSettingsSelector = new PublicTransportSettingsSelector();

  constructor(private io: Server) {
    this.roomDataProviders.push({
      roomType: PublicTransportSettingsRoom,
      id: 'PublicTransportSettingsRoom',
      jsonCreator: (room: string): string => {
        const trackType = PublicTransportSettingsRoom.idOfRoom(room);
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
