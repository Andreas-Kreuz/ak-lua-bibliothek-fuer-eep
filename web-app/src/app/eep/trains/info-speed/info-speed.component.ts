import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-info-speed',
  template: `<span *ngIf="speed"><mat-icon>speed</mat-icon>&nbsp;{{ speed }} km/h</span>`,
  styles: [],
})
export class InfoSpeedComponent implements OnInit {
  @Input() speed: number;

  constructor() {}

  ngOnInit(): void {}
}
