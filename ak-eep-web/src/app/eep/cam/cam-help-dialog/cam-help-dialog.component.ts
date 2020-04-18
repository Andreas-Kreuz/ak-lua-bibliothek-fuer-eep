import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-cam-help-dialog',
  templateUrl: './cam-help-dialog.component.html',
  styleUrls: ['./cam-help-dialog.component.css']
})
export class CamHelpDialogComponent implements OnInit {

  constructor(
    public dialogRef: MatDialogRef<CamHelpDialogComponent>) {
  }

  onNoClick(): void {
    this.dialogRef.close();
  }

  ngOnInit() {
  }

}
