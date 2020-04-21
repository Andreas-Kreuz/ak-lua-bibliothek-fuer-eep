import { Type } from '@angular/core';

export class DetailsItem<T> {
  constructor(public component: Type<any>,
              public data: T) {
  }
}
