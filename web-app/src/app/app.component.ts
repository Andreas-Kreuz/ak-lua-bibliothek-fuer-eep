import { Component, OnInit } from '@angular/core';
import { Store } from '@ngrx/store';
import * as fromCore from './core/store/core.reducers';
import * as CoreActions from './core/store/core.actions';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'EEP-Web';
  hostLocation = 'http://localhost:3000';

  constructor(private store: Store<fromCore.State>) {
  }

  ngOnInit() {
    this.hostLocation = location.protocol + '//' + location.hostname + ':3000';
    this.store.dispatch(CoreActions.setJsonServerUrl({ url: this.hostLocation }));
  }
}
