import { Component, Input, OnInit } from '@angular/core';
import { DetailsComponent } from '../../../shared/details/details.component';
import { Train } from '../model/train.model';
import { RollingStock } from '../model/rolling-stock.model';
import { Coupling } from '../model/coupling.enum';

@Component({
  selector: 'app-train-details',
  templateUrl: './train-details.component.html',
  styleUrls: ['./train-details.component.css']
})
export class TrainDetailsComponent implements DetailsComponent<Train>, OnInit {
  @Input() data: Train;

  constructor() {
  }

  ngOnInit() {
  }

  couplingFront() {
    const train = this.data;
    if (!train || !train.rollingStock) {
      return '?';
    }

    return this.couplingOf(train.rollingStock[0]);
  }

  couplingRear() {
    const train = this.data;
    if (!train || !train.rollingStock) {
      return '?';
    }

    return this.couplingOf(train.rollingStock[train.rollingStock.length - 1]);
  }

  private couplingOf(rollingStock: RollingStock) {
    return rollingStock.couplingFront === Coupling.Ready
    || rollingStock.couplingRear === Coupling.Ready
      ? 'Bereit'
      : 'Abstoßen';
  }
}
