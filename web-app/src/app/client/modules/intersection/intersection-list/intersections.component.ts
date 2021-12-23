import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { LuaSettingChangeEvent } from 'web-shared/build/model/settings';
import { IntersectionHelper } from '../intersection-helper';
import { Intersection } from '../models/intersection.model';
import * as IntersectionAction from '../store/intersection.actions';
import * as fromIntersection from '../store/intersection.reducers';

@Component({
  selector: 'app-crossings',
  templateUrl: './intersections.component.html',
  styleUrls: ['./intersections.component.css'],
})
export class IntersectionsComponent implements OnInit {
  intersections$ = this.store.select(fromIntersection.intersections$);
  laneSelect = fromIntersection.laneByIntersectionId$;
  luaModuleSettings$ = this.store.select(fromIntersection.luaModuleSettings$);

  constructor(
    public store: Store<fromIntersection.State>,
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
