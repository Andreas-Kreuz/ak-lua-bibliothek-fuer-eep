import { Component, OnInit, Inject } from '@angular/core';
import { select, Store } from '@ngrx/store';
import * as fromServer from '../store/server.reducer';
import { Observable } from 'rxjs';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { EepDirDialogComponent } from './eep-dir-dialog.component';
import { registerLocaleData } from '@angular/common';
import localeDe from '@angular/common/locales/de';

@Component({
  selector: 'app-server-status',
  templateUrl: './server-status.component.html',
  styleUrls: ['./server-status.component.css'],
})
export class ServerStatusComponent implements OnInit {
  public eepDir$: Observable<string>;
  public eepDirOk$: Observable<boolean>;
  public urls$: Observable<string[]>;
  public urlsAvailable$: Observable<boolean>;
  public eventCounter$: Observable<number>;
  error = true;
  dir = 'C:\\Trend\\EEP16';

  constructor(private store: Store<fromServer.State>, public dialog: MatDialog) {}

  ngOnInit() {
    registerLocaleData(localeDe);
    this.eepDir$ = this.store.select(fromServer.eepDir$);
    this.eepDirOk$ = this.store.select(fromServer.eepDirOk$);
    this.urls$ = this.store.select(fromServer.urls$);
    this.urlsAvailable$ = this.store.select(fromServer.urlsAvailable$);
    this.eventCounter$ = this.store.select(fromServer.selectEventCounter$);
    this.eepDirOk$.subscribe((ok) => {
      this.error = !ok;
    });
    this.eepDir$.subscribe((dir) => {
      this.dir = dir;
    });
  }

  openDialog(): void {
    this.dialog.open(EepDirDialogComponent, {
      width: '250px',
      data: { dir: this.dir },
    });
  }
}
