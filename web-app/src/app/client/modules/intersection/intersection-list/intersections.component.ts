import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { select, Store } from '@ngrx/store';

import { Intersection } from '../models/intersection.model';
import * as fromRoot from '../../../../app.reducers';
import * as fromIntersection from '../store/intersection.reducers';
import { Router } from '@angular/router';
import { IntersectionHelper } from '../intersection-helper';
import { MatDialog } from '@angular/material/dialog';
import { LuaSettings } from '../../../../shared/model/lua-settings';
import { LuaSettingChangeEvent } from '../../../../shared/model/lua-setting-change-event';
import * as IntersectionAction from '../store/intersection.actions';

@Component({
  selector: 'app-crossings',
  templateUrl: './intersections.component.html',
  styleUrls: ['./intersections.component.css'],
})
export class IntersectionsComponent implements OnInit {
  intersections$ = this.store.select(fromIntersection.intersections$);
  luaModuleSettings$ = this.store.select(fromIntersection.luaModuleSettings$);

  constructor(
    private store: Store<fromRoot.State>,
    private router: Router,
    public intersectionHelper: IntersectionHelper,
    public dialog: MatDialog
  ) {}

  ngOnInit() {}

  trackById(index: number, intersection: Intersection) {
    if (!intersection) {
      return null;
    }
    return intersection.id;
  }

  onSettingChanged(event: LuaSettingChangeEvent) {
    this.store.dispatch(
      IntersectionAction.changeModuleSettings({
        setting: event.setting,
        value: event.newValue,
      })
    );
  }
}
