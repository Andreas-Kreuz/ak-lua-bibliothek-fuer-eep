import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-info-length',
  template: `<span *ngIf="length"><mat-icon>straighten</mat-icon>&nbsp;{{ length.toFixed(2) }} m</span>`,
  styles: [],
})
export class InfoLengthComponent implements OnInit {
  @Input() length: number;

  constructor() {}

  ngOnInit(): void {}
}
