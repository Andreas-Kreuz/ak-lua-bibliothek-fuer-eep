import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Observable, Subscription } from 'rxjs';

import { Signal } from '../models/signal.model';
import { select, Store } from '@ngrx/store';
import * as fromEep from '../store/signal.reducers';
import { trafficLight, unknown } from '../../../shared/unicode-symbol.model';
import { State } from '../../../app.reducers';

@Component({
  selector: 'app-signal-detail-component',
  templateUrl: './signal-detail.component.html',
  styleUrls: ['./signal-detail.component.css']
})
export class SignalDetailComponent implements OnInit, OnDestroy {
  private signalId: number;
  signal$: Observable<Signal>;
  private routeParams$: Subscription;

  constructor(private store: Store<State>,
              private route: ActivatedRoute) {
  }

  ngOnInit() {
    this.routeParams$ = this.route.params
      .subscribe((params: Params) => {
        this.signalId = +this.route.snapshot.params['id'];
        this.signal$ = this.store.pipe(
          select(fromEep.selectSignalById$(this.signalId)));
      });
  }

  ngOnDestroy() {
    this.routeParams$.unsubscribe();
  }

  unicodeFor(signal: Signal) {
    if (signal.model && signal.model.type === 'road') {
      return trafficLight + ' ';
    }

    return unknown + ' ';
  }

  modelTypeOf(signal: Signal) {
    if (signal.model && signal.model.type === 'road') {
      return 'Ampel';
    }

    return 'Unbekanntes Modell';
  }

  positionOf(signal: Signal) {
    return signal.position ? signal.position : '-';
  }

  waitingVehiclesCountOf(signal: Signal) {
    return signal.waitingVehiclesCount ? signal.waitingVehiclesCount : '-';
  }
}
