import { Component, OnInit, Inject } from '@angular/core';
import { select, Store } from '@ngrx/store';
import * as fromServer from '../store/server.reducer';
import * as ServerAction from '../store/server.actions';
import { Observable } from 'rxjs';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { EepDirDialogComponent } from './eep-dir-dialog.component';

@Component({
  selector: 'app-server-status',
  templateUrl: './server-status.component.html',
  styleUrls: ['./server-status.component.css'],
})
export class ServerStatusComponent implements OnInit {
  public eepDir$: Observable<string>;
  public eepDirOk$: Observable<boolean>;
  public urls$: Observable<string[]>;
  error = true;
  dir = 'C:\\Trend\\EEP16';

  constructor(private store: Store<fromServer.State>, public dialog: MatDialog) {}

  ngOnInit() {
    this.eepDir$ = this.store.pipe(select(fromServer.eepDir$));
    this.eepDirOk$ = this.store.pipe(select(fromServer.eepDirOk$));
    this.urls$ = this.store.pipe(select(fromServer.urls$));
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
