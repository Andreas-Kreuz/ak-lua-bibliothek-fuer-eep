import { Component, OnDestroy, OnInit } from '@angular/core';
import { select, Store } from '@ngrx/store';
import { Observable } from 'rxjs';

import { Alert } from './alert.model';
import * as fromErrors from '../store/core.reducers';
import * as ErrorActions from '../store/core.actions';
import * as fromRoot from '../../app.reducers';

@Component({
  selector: 'app-error',
  templateUrl: './error.component.html',
  styleUrls: ['./error.component.css']
})
export class ErrorComponent implements OnInit, OnDestroy {
  alerts$: Observable<Alert[]>;

  constructor(private store: Store<fromRoot.State>) {
  }

  ngOnInit() {
    this.alerts$ = this.store.pipe(select(fromErrors.getAlerts));
  }

  ngOnDestroy() {
  }

  close(alert: Alert) {
    this.store.dispatch(new ErrorActions.HideError((alert)));
  }
}
