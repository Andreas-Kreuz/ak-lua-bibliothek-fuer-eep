import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-info-route',
  template: `<span *ngIf="route"><mat-icon>directions</mat-icon>&nbsp;{{ route }}</span>`,
  styles: [],
})
export class InfoRouteComponent implements OnInit {
  @Input() route: string;

  constructor() {}

  ngOnInit(): void {}
}
