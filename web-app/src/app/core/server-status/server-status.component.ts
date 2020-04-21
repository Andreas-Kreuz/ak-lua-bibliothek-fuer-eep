import { Component, OnInit } from '@angular/core';
import { select, Store } from '@ngrx/store';
import * as fromRoot from '../../app.reducers';
import * as fromCore from '../store/core.reducers';
import { Observable } from 'rxjs';
import { EepWebUrl } from './eep-web-url.model';

@Component({
  selector: 'app-server-status',
  templateUrl: './server-status.component.html',
  styleUrls: ['./server-status.component.css']
})
export class ServerStatusComponent implements OnInit {
  apiPaths$: Observable<EepWebUrl[]>;
  private jsonServerUrl$: Observable<string>;

  constructor(private store: Store<fromRoot.State>) {
  }

  ngOnInit() {
    this.apiPaths$ = this.store.pipe(select(fromCore.getApiPaths$));
    this.jsonServerUrl$ = this.store.pipe(select(fromCore.getJsonServerUrl));
  }
}
