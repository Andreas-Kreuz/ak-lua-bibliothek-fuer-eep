import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { Train } from '../model/train.model';
import { Coupling } from '../model/coupling.enum';
import { TrainType } from '../model/train-type.enum';
import * as unicode from '../../../shared/unicode-symbol.model';
import { iconForRollingStockType, textForRollingStockType } from '../model/rolling-stock-type.enum';
import { RollingStock } from '../model/rolling-stock.model';

@Component({
  selector: 'app-train-card',
  templateUrl: './train-card.component.html',
  styleUrls: ['./train-card.component.css'],
})
export class TrainCardComponent implements OnInit, OnChanges {
  @Input() train: Train;
  frontCouplingReady = false;
  rearCouplingReady = false;

  constructor() {}

  ngOnInit(): void {}
  ngOnChanges(): void {
    this.frontCouplingReady =
      (this.train && this.train.rollingStock[0].couplingFront === Coupling.ready) ||
      this.train.rollingStock[0].couplingRear === Coupling.ready;

    this.rearCouplingReady =
      (this.train && this.train.rollingStock[this.train.rollingStock.length - 1].couplingFront === Coupling.ready) ||
      this.train.rollingStock[this.train.rollingStock.length - 1].couplingRear === Coupling.ready;
  }

  iconFor(rollingStock: RollingStock) {
    if (rollingStock.modelType > 0) {
      return iconForRollingStockType(rollingStock.modelType);
    } else {
      return unicode.tenderLoco;
    }
  }

  getCouplingText(train: Train): string {
    if (train && train.rollingStock) {
      if (this.frontCouplingReady) {
        return this.rearCouplingReady ? 'Bereit (v+h)' : 'Bereit (v)';
      } else if (this.rearCouplingReady) {
        return 'Bereit (h)';
      } else {
        return 'Abstoßen';
      }
    } else {
      return '?';
    }
  }
}
