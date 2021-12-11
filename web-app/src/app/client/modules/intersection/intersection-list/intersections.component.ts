import { Component, OnInit } from '@angular/core';
import { Store } from '@ngrx/store';
import { Router } from '@angular/router';
import { MatDialog } from '@angular/material/dialog';

import { Intersection } from '../models/intersection.model';
import { IntersectionHelper } from '../intersection-helper';
import { LuaSettingChangeEvent } from 'web-shared/build/model/settings';

import * as fromIntersection from '../store/intersection.reducers';
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
    private store: Store<fromIntersection.State>,
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
