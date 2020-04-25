import { Directive, ViewContainerRef } from '@angular/core';

@Directive({
  selector: '[appOldDetails]'
})
export class OldDetailsDirective {
  constructor(public viewContainerRef: ViewContainerRef) {
  }
}
