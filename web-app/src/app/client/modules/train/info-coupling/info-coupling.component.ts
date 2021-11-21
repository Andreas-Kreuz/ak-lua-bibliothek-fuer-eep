import { Component, Input, OnChanges, OnInit } from '@angular/core';

@Component({
  selector: 'app-info-coupling',
  template: `<span
    ><mat-icon>{{ couplingReady ? 'add_link' : 'link_off' }}</mat-icon
    >&nbsp;{{ couplingReady ? 'Bereit' : 'Abstoßen' }} ({{ name }})
  </span>`,
  styles: [],
})
export class InfoCouplingComponent implements OnInit {
  @Input() couplingReady: boolean;
  @Input() name: string;

  constructor() {}

  ngOnInit(): void {}
}
