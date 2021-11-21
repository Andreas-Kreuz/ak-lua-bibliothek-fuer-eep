import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-info-destination',
  template: `<span *ngIf="destination"><mat-icon>place</mat-icon>&nbsp;{{ destination }}</span>`,
  styles: [],
})
export class InfoDestinationComponent implements OnInit {
  @Input() destination: string;

  constructor() {}

  ngOnInit(): void {}
}
