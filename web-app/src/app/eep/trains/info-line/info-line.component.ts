import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-info-line',
  template: `<span *ngIf="line"><mat-icon>route</mat-icon>&nbsp;{{ line }}</span>`,
  styles: [],
})
export class InfoLineComponent implements OnInit {
  @Input() line: string;

  constructor() {}

  ngOnInit(): void {}
}
