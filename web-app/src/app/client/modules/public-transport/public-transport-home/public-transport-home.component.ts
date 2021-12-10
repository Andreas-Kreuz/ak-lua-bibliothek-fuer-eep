import { Component, OnInit } from '@angular/core';
import { Store } from '@ngrx/store';
import { LuaSettingChangeEvent } from 'web-shared/build/model/settings';

import * as PublicTransportAction from '../store/public-transport.actions';
import * as fromPublicTransport from '../store/public-transport.reducer';

@Component({
  selector: 'app-public-transport-home',
  templateUrl: './public-transport-home.component.html',
  styleUrls: ['./public-transport-home.component.css'],
})
export class PublicTransportHomeComponent implements OnInit {
  luaModuleSettings$ = this.store.select(fromPublicTransport.publicTransportFeature.selectModuleSettings);

  constructor(private store: Store<fromPublicTransport.State>) {}

  ngOnInit(): void {}

  onSettingChanged(event: LuaSettingChangeEvent) {
    // TODO
    // this.store.dispatch(
    //   PublicTransportAction.settingsUpdated({
    //     setting: event.setting,
    //     value: event.newValue,
    //   })
    // );
  }
}
