import { Store } from '@ngrx/store';
import { Component, Input, OnInit } from '@angular/core';
import * as fromTrain from '../store/train.reducer';
import { RollingStock, Train } from 'web-shared/build/model/trains';
import { EepCommandService } from '../../../../common/eep-communication/eep-command.service';

@Component({
  selector: 'app-train-details-card',
  templateUrl: './train-details-card.component.html',
  styleUrls: ['./train-details-card.component.css'],
})
export class TrainDetailsCardComponent implements OnInit {
  @Input() index = 0;
  train$ = this.store.select(fromTrain.trainFeature.selectSelectedTrain);
  currentCam = -1;

  constructor(private store: Store<fromTrain.State>, private eepCommands: EepCommandService) {}

  ngOnInit(): void {}

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
