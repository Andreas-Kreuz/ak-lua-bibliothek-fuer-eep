import * as fromEepData from '../../eep-data-reducer';
import { Server } from 'socket.io';
import {
  // PublicTransportLineListRoom,
  // PublicTransportLineDetailsRoom,
  // PublicTransportStationListRoom,
  // PublicTransportStationDetailsRoom,
  PublicTransportSettingsRoom,
} from 'web-shared/build/rooms';
import PublicTransportSettingsSelector from './public-transport-settings-selector';
import FeatureUpdateService, { SocketDataProvider } from '../socket-data-provider';

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
