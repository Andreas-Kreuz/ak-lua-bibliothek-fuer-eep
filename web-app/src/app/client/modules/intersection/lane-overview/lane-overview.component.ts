import { Component, Input, OnDestroy, OnInit } from '@angular/core';
import { Observable, Subscription } from 'rxjs';
import { Intersection } from '../models/intersection.model';
import { IntersectionSwitching } from '../models/intersection-switching.model';
import { select, Store } from '@ngrx/store';
import * as fromRoot from '../../../../app.reducers';
import * as fromIntersection from '../store/intersection.reducers';
import { map } from 'rxjs/operators';
import { IntersectionLane } from '../models/intersection-lane.model';
import { IntersectionHelper } from '../intersection-helper';

@Component({
  selector: 'app-lane-overview',
  templateUrl: './lane-overview.component.html',
  styleUrls: ['./lane-overview.component.css'],
})
export class LaneOverviewComponent implements OnInit, OnDestroy {
  @Input() intersectionId: number;
  intersection$: Observable<Intersection>;
  switching$: Observable<IntersectionSwitching[]>;
  lanes$: Observable<IntersectionLane[]>;
  intersectionHelper: IntersectionHelper;
  private switchingSub: Subscription;
  private switchings: IntersectionSwitching[];

  constructor(private store: Store<fromRoot.State>, intersectionHelper: IntersectionHelper) {
    this.intersectionHelper = intersectionHelper;
  }

  ngOnInit() {
    this.intersection$ = this.store.select(fromIntersection.intersectionById$(this.intersectionId));
    this.lanes$ = this.store.select(fromIntersection.laneByIntersectionId$(this.intersectionId));
    this.switchingSub = this.intersection$.subscribe(
      (intersection) =>
        (this.switching$ = this.store.pipe(
          select(fromIntersection.switchingNamesByIntersection$(intersection)),
          map((switchings) => {
            this.switchings = switchings;
            return switchings;
          })
        ))
    );
  }

  ngOnDestroy(): void {
    this.switchingSub.unsubscribe();
  }
}
