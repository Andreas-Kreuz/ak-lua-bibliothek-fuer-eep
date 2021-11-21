import { Component, OnDestroy, OnInit } from '@angular/core';
import { select, Store } from '@ngrx/store';
import * as fromStatistics from './store/statistics.reducer';
import TimeDesc from './store/time-desc';
import { Observable, Subscription } from 'rxjs';

@Component({
  selector: 'app-statistics',
  templateUrl: './statistics.component.html',
  styleUrls: ['./statistics.component.css'],
})
export class StatisticsComponent implements OnInit, OnDestroy {
  collectorRefreshTimes$: Observable<TimeDesc[][]>;
  serverTimes$: Observable<TimeDesc[][]>;

  constructor(private store: Store<fromStatistics.State>) {
    this.collectorRefreshTimes$ = store.select(fromStatistics.collectorRefreshStats$);
    this.serverTimes$ = store.select(fromStatistics.serverControllerStats$);
  }

  ngOnInit(): void {}

  ngOnDestroy(): void {}
}
