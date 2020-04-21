import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-tooltip',
  template: '<ng-template #htmlContent>{{ tooltip }}</ng-template>' +
    '<span [ngbTooltip]="htmlContent">{{ text }}</span>',
  styleUrls: ['./tooltip.component.css']
})
export class TooltipComponent implements OnInit {
  @Input() text;
  @Input() tooltip: string;

  constructor() {
  }

  ngOnInit() {
  }
}
