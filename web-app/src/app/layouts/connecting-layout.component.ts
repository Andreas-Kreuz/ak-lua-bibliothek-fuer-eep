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
  connectionEstablished$ = this.store.select(fromCore.getConnectionEstablished);
  public hostname$ = this.store.select(fromCore.getJsonServerUrl);

  constructor(private store: Store<fromCore.State>) {}

  ngOnInit(): void {}
}
