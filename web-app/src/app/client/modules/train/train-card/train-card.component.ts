import { Component, Input, OnChanges, OnDestroy, OnInit } from '@angular/core';
import { Train } from '../model/train.model';
import { Coupling } from '../model/coupling.enum';
import * as unicode from '../../../../shared/unicode-symbol.model';
import { iconForRollingStockType, textForRollingStockType } from '../model/rolling-stock-type.enum';
import { RollingStock } from '../model/rolling-stock.model';
import { select, Store } from '@ngrx/store';
import * as TrainAction from '../store/train.actions';
import * as fromTrain from '../store/train.reducer';
import { Observable, Subscription } from 'rxjs';
import { EepCommandService } from '../../../../common/eep-communication/eep-command.service';

@Component({
  selector: 'app-train-card',
  templateUrl: './train-card.component.html',
  styleUrls: ['./train-card.component.css'],
})
export class TrainCardComponent implements OnInit, OnDestroy, OnChanges {
  @Input() train: Train;
  expanded = false;
  expandedSub: Subscription;
  frontCouplingReady = false;
  rearCouplingReady = false;
  selectedTrainName$ = this.store.select(fromTrain.selectedTrainName);
  private currentCam = 9;

  constructor(private store: Store<fromTrain.State>, private eepCommands: EepCommandService) {}

  ngOnInit(): void {
    this.expandedSub = this.selectedTrainName$.subscribe((trainName) => (this.expanded = this.train.id === trainName));
  }

  ngOnDestroy(): void {
    this.expandedSub.unsubscribe();
  }

  ngOnChanges(): void {
    const frontRs = this.train && this.train.rollingStock && this.train.rollingStock[0];
    this.frontCouplingReady =
      frontRs && (frontRs.couplingFront === Coupling.ready || frontRs.couplingRear === Coupling.ready);

    const rearRs = this.train && this.train.rollingStock && this.train.rollingStock[this.train.rollingStock.length - 1];
    this.rearCouplingReady =
      rearRs && (rearRs.couplingFront === Coupling.ready || rearRs.couplingRear === Coupling.ready);
  }

  public favoriteTrain(): void {
    this.store.next(TrainAction.selectTrain({ trainName: this.expanded ? null : this.train.id }));
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

  changeCamRollingStock(rollingStock: RollingStock) {
    const posX = rollingStock.length / 2 + 12;
    this.eepCommands.setCamToRollingStock(rollingStock.id, posX, -3, 5, 15, 80);
  }

  changeCamTrain(train: Train) {
    if (this.currentCam === -1) {
      this.changeCamRollingStock(train.rollingStock[0]);
    } else {
      this.eepCommands.setCamToTrain(train.id, this.currentCam);
    }
    this.currentCam = this.nextCam(this.currentCam);
  }

  private nextCam(currentCam: number): number {
    const nextCams = {
      [9]: -1,
      [-1]: 3,
      [3]: 4,
      [4]: 10,
      [10]: 9,
    };
    return nextCams[currentCam] ? nextCams[currentCam] : 9;
  }
}
