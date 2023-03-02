import * as fromEepData from '../../EepDataStore';
import FeatureUpdateService, { SocketDataProvider } from '../SocketDataProvider';
import PublicTransportSettingsSelector from './PublicTransportSettingsSelector';
import {
  // PublicTransportLineListRoom,
  // PublicTransportLineDetailsRoom,
  // PublicTransportStationListRoom,
  // PublicTransportStationDetailsRoom,
  PublicTransportSettingsRoom,
} from '@ak/web-shared';
import { Server } from 'socket.io';

export default class PublicTransportService implements FeatureUpdateService {
  private roomDataProviders: SocketDataProvider[] = [];
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

  getDataUpdaters = () => [
    {
      updateFromState: (state: Readonly<fromEepData.State>) => {
        this.publicTransportSettingsSelector.updateFromState(state);
      },
    },
  ];

  getSocketSettings = () => this.roomDataProviders;
}
