import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { Store, select } from '@ngrx/store';
import * as fromCore from '../core/store/core.reducers';

@Component({
  selector: 'app-connecting-layout',
  templateUrl: './connecting-layout.component.html',
  styleUrls: ['./connecting-layout.component.scss'],
})
export class ConnectingLayoutComponent implements OnInit {
  connectionEstablished$: Observable<boolean>;
  public hostname$: Observable<string>;

  constructor(private store: Store<fromCore.State>) {}

  ngOnInit(): void {
    this.connectionEstablished$ = this.store.pipe(select(fromCore.getConnectionEstablished));
    this.hostname$ = this.store.pipe(select(fromCore.getJsonServerUrl));
  }
}
