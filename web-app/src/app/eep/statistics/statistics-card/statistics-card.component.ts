import { Component, Input, OnDestroy, OnInit } from '@angular/core';
import { Observable, Subscription } from 'rxjs';
import TimeDesc from '../store/time-desc';

@Component({
  selector: 'app-statistics-card',
  templateUrl: './statistics-card.component.html',
  styleUrls: ['./statistics-card.component.css'],
})
export class StatisticsCardComponent implements OnDestroy, OnInit {
  max = 100;
  ids = [];
  count = Array(10)
    .fill(0)
    .map((x, i) => i);
  @Input() title = 'Bitte warten ...';
  @Input() list$: Observable<TimeDesc[][]>;
  listSub: Subscription;

  constructor() {}

  ngOnInit(): void {
    this.listSub = this.list$.subscribe((list) => this.onUpdate(list));
  }

  ngOnDestroy(): void {
    this.listSub.unsubscribe();
  }

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
      case 4:
        return '#a9b3ce';
      case 5:
        return '#cf4d6f';
      case 6:
        return '#7cdedc';
      case 7:
        return '#7284a8';
      case 8:
        return '#7284a8';
      case 9:
        return '#474954';
      case 10:
        return '#eb9486';
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
    if (i === 0 || this.max === 0) return 0;
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
