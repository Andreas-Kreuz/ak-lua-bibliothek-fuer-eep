import { Directive, ViewContainerRef } from '@angular/core';

@Directive({
  selector: '[appDetails]'
})
export class DetailsDirective {
  constructor(public viewContainerRef: ViewContainerRef) {
  }
}
