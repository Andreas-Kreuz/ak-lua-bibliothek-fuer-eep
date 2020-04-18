import { Component, Input, OnDestroy, OnInit } from '@angular/core';
import { Observable, Subscription } from 'rxjs';
import { Intersection } from '../models/intersection.model';
import { IntersectionSwitching } from '../models/intersection-switching.model';
import { select, Store } from '@ngrx/store';
import * as fromRoot from '../../../app.reducers';
import * as IntersectionAction from '../store/intersection.actions';
import * as fromIntersection from '../store/intersection.reducers';
import { map } from 'rxjs/operators';
import { MatDialog } from '@angular/material/dialog';

@Component({
  selector: 'app-intersection-switching',
  templateUrl: './intersection-switching.component.html',
  styleUrls: ['./intersection-switching.component.css']
})
export class IntersectionSwitchingComponent implements OnInit, OnDestroy {
  @Input() intersectionId: number;
  intersection$: Observable<Intersection>;
  switching$: Observable<IntersectionSwitching[]>;
  private switchingSub: Subscription;
  private switchings: IntersectionSwitching[];

  constructor(private store: Store<fromRoot.State>,
              public dialog: MatDialog) {
  }

  ngOnInit() {
    this.intersection$ = this.store.pipe(
      select(fromIntersection.intersectionById$(this.intersectionId)));
    // this.lanes$ = this.store.pipe(
    //   select(fromIntersection.laneByIntersectionId$(intersectionId)));
    this.switchingSub = this.intersection$.subscribe((intersection) =>
      this.switching$ = this.store.pipe(
        select(fromIntersection.switchingNamesByIntersection$(intersection)),
        map((switchings) => {
          this.switchings = switchings;
          return switchings;
        })
      ));
  }

  ngOnDestroy(): void {
    this.switchingSub.unsubscribe();
  }

  onChangeManualSwitching(intersection: Intersection, switchingName: string) {
    if (intersection.manualSwitching) {
      this.store.dispatch(new IntersectionAction.SwitchAutomatically({
        intersection
      }));
    } else if (switchingName) {
      const switching = this.switchingFor(switchingName);
      this.switchTo(intersection, switching);
    }
  }

  switchTo(intersection: Intersection, switching: IntersectionSwitching) {
    this.store.dispatch(new IntersectionAction.SwitchManually({
      intersection: intersection, switching: switching
    }));
  }

  switchingFor(switchingName: string): IntersectionSwitching {
    for (const s of this.switchings) {
      if (s.name === switchingName) {
        return s;
      }
    }

    return null;
  }
}
