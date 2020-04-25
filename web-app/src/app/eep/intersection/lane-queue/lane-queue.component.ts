import { Component, Input, OnDestroy, OnInit } from '@angular/core';
import { Observable, Subscription } from 'rxjs';
import { Intersection } from '../models/intersection.model';
import { IntersectionSwitching } from '../models/intersection-switching.model';
import { IntersectionLane } from '../models/intersection-lane.model';
import { select, Store } from '@ngrx/store';
import * as fromRoot from '../../../app.reducers';
import { IntersectionHelper } from '../intersection-helper';
import * as fromIntersection from '../store/intersection.reducers';
import { map } from 'rxjs/operators';
import * as icons from '../../../shared/unicode-symbol.model';

@Component({
  selector: 'app-lane-queue',
  templateUrl: './lane-queue.component.html',
  styleUrls: ['./lane-queue.component.css']
})
export class LaneQueueComponent implements OnInit, OnDestroy {
  @Input() intersectionId: number;
  intersection$: Observable<Intersection>;
  switching$: Observable<IntersectionSwitching[]>;
  private switchingSub: Subscription;
  private switchings: IntersectionSwitching[];
  lanes$: Observable<IntersectionLane[]>;
  carIcon = icons.car;

  constructor(private store: Store<fromRoot.State>,
              private intersectionHelper: IntersectionHelper) {
  }

  ngOnInit() {
    this.intersection$ = this.store.pipe(
      select(fromIntersection.intersectionById$(this.intersectionId)));
    this.lanes$ = this.store.pipe(
      select(fromIntersection.laneByIntersectionId$(this.intersectionId)));
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
}
