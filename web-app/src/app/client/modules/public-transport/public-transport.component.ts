import { Component, OnDestroy, OnInit } from '@angular/core';
import { Store } from '@ngrx/store';

import * as PublicTransportAction from './store/public-transport.actions';
import * as fromPublicTransport from './store/public-transport.reducer';

@Component({
  selector: 'app-public-transport',
  template: '<router-outlet></router-outlet>',
})
export class PublicTransportComponent implements OnInit, OnDestroy {
  constructor(private store: Store<fromPublicTransport.State>) {}

  ngOnInit(): void {
    this.store.dispatch(PublicTransportAction.initModule());
  }

  ngOnDestroy(): void {
    this.store.dispatch(PublicTransportAction.destroyModule());
  }
}
