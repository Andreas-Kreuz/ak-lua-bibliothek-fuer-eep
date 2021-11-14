import { Component, OnInit } from '@angular/core';
import { select, Store } from '@ngrx/store';
import * as fromRoot from '../../app.reducers';
import * as fromStatistics from './store/statistics.reducer';
import { max } from 'rxjs/operators';
import TimeDesc from './store/time-desc';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-statistics',
  templateUrl: './statistics.component.html',
  styleUrls: ['./statistics.component.css'],
})
export class StatisticsComponent implements OnInit {
  max = 100;
  ids = [];
  count = Array(10)
    .fill(0)
    .map((x, i) => i);
  list$: Observable<TimeDesc[][]>;

  constructor(private store: Store<fromRoot.State>) {
    this.list$ = store.pipe(select(fromStatistics.serverControllerStats$));
    this.list$.subscribe((list) => this.onUpdate(list));
  }

  ngOnInit(): void {}

  colorOf(index: number) {
    switch (index) {
      case 0:
        return '#db2b1d';
      case 1:
        return '#dbdc1d';
      case 2:
        return '#17ac21';
      case 3:
        return '#412396';
      default:
        return 'red';
    }
  }

  onUpdate(list: TimeDesc[][]) {
    if (list && list[0]) {
      console.log(list);
      this.max = this.scale(list);
      this.ids = list[0].map((a) => a.id);
    }
  }

  scale(list: TimeDesc[][]) {
    const max1 = this.getMax(list);
    return Math.round(max1);
  }

  getMax(list: TimeDesc[][]) {
    let max1 = 0;
    for (const entries of list) {
      max1 = Math.max(max1, this.maxOfSingleList(entries));
    }
    return max1;
  }

  maxOfSingleList(entries: TimeDesc[]) {
    return entries.map((a) => a.ms).reduce((a, b) => a + b);
  }

  scaledValueOf(i: number) {
    // maximum shall be 80 % of the scale
    return (i / this.max) * 80;

    //return (this.max * i) / 100;
  }

  startXOf(index: number, list: TimeDesc[]) {
    return index === 0 || !list
      ? 0
      : list
          .slice(0, index)
          .map((a) => a.ms)
          .reduce((a, b) => a + b);
  }
}
