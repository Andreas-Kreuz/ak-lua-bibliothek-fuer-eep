import { Injectable, OnDestroy } from '@angular/core';
import { Store } from '@ngrx/store';
import { Subscription } from 'rxjs';
import * as PublicTransportActions from './public-transport.actions';
import * as fromPublicTransport from '../store/public-transport.reducer';
import { SocketService } from '../../../../core/socket/socket-service';
import {
  PublicTransportLineListRoom,
  PublicTransportSettingsRoom,
  PublicTransportStationListRoom,
} from 'web-shared/build/rooms';
import { LuaSetting, LuaSettings } from 'web-shared/build/model/settings';
import { LineListEntry, StationListEntry } from 'web-shared/build/model/public-transport';
import { CommandEvent } from 'web-shared';

@Injectable()
export class PublicTransportService implements OnDestroy {
  moduleSettingsSub: Subscription;
  publicTransportLineListSub: Subscription;
  publicTransportStationListSub: Subscription;

  constructor(private socket: SocketService, private store: Store<fromPublicTransport.State>) {
    console.log('##### Creating PublicTransportService');
  }

  listenToSettings(trackType: string) {
    if (this.moduleSettingsSub) {
      this.moduleSettingsSub.unsubscribe();
    }
    const observer = this.socket.listenToData(PublicTransportSettingsRoom, trackType);
    this.moduleSettingsSub = observer.subscribe((data) => {
      const moduleSettings: LuaSettings = JSON.parse(data);
      this.store.dispatch(PublicTransportActions.settingsUpdated({ moduleSettings }));
    });
  }

  changeModuleSettings(setting: LuaSetting<any>, value: any) {
    this.socket.emit(CommandEvent.ChangeSetting, { name: setting.name, func: setting.eepFunction, newValue: value });
  }

  listenToLines(trackType: string) {
    if (this.publicTransportLineListSub) {
      this.publicTransportLineListSub.unsubscribe();
    }
    const observer = this.socket.listenToData(PublicTransportLineListRoom, trackType);
    this.publicTransportLineListSub = observer.subscribe((data) => {
      const lineList: LineListEntry[] = JSON.parse(data);
      this.store.dispatch(PublicTransportActions.lineListUpdated({ lineList }));
    });
  }

  listenToStations(trackType: string) {
    if (this.publicTransportStationListSub) {
      this.publicTransportStationListSub.unsubscribe();
    }
    const observer = this.socket.listenToData(PublicTransportStationListRoom, trackType);
    this.publicTransportStationListSub = observer.subscribe((data) => {
      const stationList: StationListEntry[] = JSON.parse(data);
      this.store.dispatch(PublicTransportActions.stationListUpdated({ stationList }));
    });
  }

  connect(): void {
    console.log('##### Connecting PublicTransportService');
    this.listenToSettings('');
  }

  disconnect(): void {
    console.log('##### Disconnect PublicTransportService');
    if (this.moduleSettingsSub) {
      this.moduleSettingsSub.unsubscribe();
      this.moduleSettingsSub = undefined;
    }
    if (this.publicTransportLineListSub) {
      this.publicTransportLineListSub.unsubscribe();
      this.publicTransportLineListSub = undefined;
    }
    if (this.publicTransportStationListSub) {
      this.publicTransportStationListSub.unsubscribe();
      this.publicTransportStationListSub = undefined;
    }
  }

  ngOnDestroy(): void {
    console.log('##### Destroying PublicTransportService');
  }
}
