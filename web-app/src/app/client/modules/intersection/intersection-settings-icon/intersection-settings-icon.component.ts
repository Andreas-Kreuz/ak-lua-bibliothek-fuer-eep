import { Component, OnInit } from '@angular/core';
import { Store } from '@ngrx/store';
import { LuaSettingChangeEvent } from 'web-shared/build/model/settings';

import * as fromIntersection from '../store/intersection.reducers';
import * as IntersectionAction from '../store/intersection.actions';

@Component({
  selector: 'app-intersection-settings-icon',
  templateUrl: './intersection-settings-icon.component.html',
  styleUrls: ['./intersection-settings-icon.component.css'],
})
export class IntersectionSettingsIconComponent implements OnInit {
  luaModuleSettings$ = this.store.select(fromIntersection.luaModuleSettings$);

  constructor(private store: Store<fromIntersection.State>) {}

  ngOnInit() {}

  onSettingChanged(event: LuaSettingChangeEvent) {
    console.log(event);
    this.store.dispatch(
      IntersectionAction.changeModuleSettings({
        setting: event.setting,
        value: event.newValue,
      })
    );
  }
}
