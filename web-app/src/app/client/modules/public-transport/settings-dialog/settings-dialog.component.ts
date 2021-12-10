import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';
import { Store } from '@ngrx/store';
import { LuaSettingChangeEvent } from 'web-shared/build/model/settings';

import * as PublicTransportAction from '../store/public-transport.actions';
import * as fromPublicTransport from '../store/public-transport.reducer';

@Component({
  selector: 'app-settings-dialog',
  templateUrl: './settings-dialog.component.html',
  styleUrls: ['./settings-dialog.component.css'],
})
export class SettingsDialogComponent implements OnInit {
  luaModuleSettings$ = this.store.select(fromPublicTransport.publicTransportFeature.selectModuleSettings);

  constructor(
    private store: Store<fromPublicTransport.State>,
    public dialogRef: MatDialogRef<SettingsDialogComponent>
  ) {}

  ngOnInit(): void {}

  onSettingChanged(event: LuaSettingChangeEvent) {
    this.store.dispatch(
      PublicTransportAction.settingChanged({
        setting: event.setting,
        value: event.newValue,
      })
    );
  }

  onDialogClose(): void {
    this.dialogRef.close();
  }
}
