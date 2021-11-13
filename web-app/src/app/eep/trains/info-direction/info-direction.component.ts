import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-info-direction',
  template: `<span *ngIf="direction"><mat-icon>explore</mat-icon>&nbsp;{{ direction }}</span>`,
  styles: [],
})
export class InfoDirectionComponent implements OnInit {
  @Input() direction: string;

  constructor() {}

  ngOnInit(): void {}
}
