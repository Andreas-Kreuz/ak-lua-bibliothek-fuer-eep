import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { DialogData } from './dialog-data';
import { Store, select } from '@ngrx/store';
import { Observable } from 'rxjs';

import * as ServerAction from '../store/server.actions';
import * as fromServer from '../store/server.reducer';

@Component({
  selector: 'app-eep-dir-dialog',
  templateUrl: './eep-dir-dialog.component.html',
})
export class EepDirDialogComponent {
  public eepDir$ = this.store.select(fromServer.eepDir$);

  constructor(
    private store: Store<fromServer.State>,
    public dialogRef: MatDialogRef<EepDirDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: DialogData
  ) {}

  onNoClick(): void {
    this.dialogRef.close();
  }

  onYesClick(): void {
    this.store.dispatch(ServerAction.changeEepDirectoryRequest({ eepDir: this.data.dir }));
    this.dialogRef.close();
  }
}
