import { Component, Input, OnInit } from '@angular/core';
import { RollingStock } from '../model/rolling-stock.model';
import { iconForRollingStockType, textForRollingStockType } from '../model/rolling-stock-type.enum';
import { textForCoupling } from '../model/coupling.enum';
import { TrainType } from '../model/train-type.enum';
import * as unicode from '../../../../shared/unicode-symbol.model';

@Component({
  selector: 'app-rolling-stock-tooltip',
  templateUrl: './rolling-stock-tooltip.component.html',
  styleUrls: ['./rolling-stock-tooltip.component.css'],
})
export class RollingStockTooltipComponent implements OnInit {
  @Input() rollingStock: RollingStock;
  @Input() trainType: TrainType;

  constructor() {}

  ngOnInit() {}

  iconFor() {
    if (this.rollingStock.modelType > 0) {
      return iconForRollingStockType(this.rollingStock.modelType);
    } else {
      switch (this.trainType) {
        default:
        case TrainType.rail:
          return unicode.tenderLoco;
        case TrainType.road:
          return unicode.car;
        case TrainType.tram:
          return unicode.tram;
      }
    }
  }

  typeOf() {
    return textForRollingStockType(this.rollingStock.modelType);
  }

  textForCoupling(coupling) {
    return textForCoupling(coupling);
  }

  getTooltip() {
    return (
      this.rollingStock.name +
      (this.typeOf() === 'UNBEKANNT'
        ? ''
        : ' (' + this.typeOf() + ', ' + this.rollingStock.length.toFixed(1) + 'm' + ')')
    );
  }
}
