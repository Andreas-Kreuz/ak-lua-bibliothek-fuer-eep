import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Store } from '@ngrx/store';
import { LuaSettingChangeEvent } from 'web-shared/build/model/settings';

import * as PublicTransportAction from '../store/public-transport.actions';
import * as fromPublicTransport from '../store/public-transport.reducer';

@Component({
  selector: 'app-public-transport-settings-icon',
  templateUrl: './public-transport-settings-icon.component.html',
  styleUrls: ['./public-transport-settings-icon.component.css'],
})
export class PublicTransportSettingsIconComponent implements OnInit {
  luaModuleSettings$ = this.store.select(fromPublicTransport.publicTransportFeature.selectModuleSettings);

  constructor(private store: Store<fromPublicTransport.State>) {}

  ngOnInit(): void {}

  onSettingChanged(event: LuaSettingChangeEvent) {
    console.log(event);
    this.store.dispatch(
      PublicTransportAction.settingChanged({
        setting: event.setting,
        value: event.newValue,
      })
    );
  }
}
