import { Component, Input, OnChanges, OnDestroy, OnInit } from '@angular/core';
import { iconForRollingStockType, textForRollingStockType } from '../model/rolling-stock-type.enum';
import { Store } from '@ngrx/store';
import * as TrainAction from '../store/train.actions';
import * as fromTrain from '../store/train.reducer';
import { Subscription } from 'rxjs';
import { EepCommandService } from '../../../../common/eep-communication/eep-command.service';
import { Train, TrainListEntry } from 'web-shared/build/model/trains';
import { trainIconFor } from '../model/train-image-helper';

@Component({
  selector: 'app-train-list-card',
  templateUrl: './train-list-card.component.html',
  styleUrls: ['./train-list-card.component.css'],
})
export class TrainListCardComponent implements OnInit, OnDestroy, OnChanges {
  @Input() train: TrainListEntry;
  @Input() index: number;
  selectedTrainName = this.store.select(fromTrain.trainFeature.selectSelectedTrainName);
  expanded = false;
  expandedSub: Subscription;
  private currentCam = 9;

  constructor(private store: Store<fromTrain.State>, private eepCommands: EepCommandService) {}

  ngOnInit(): void {
    this.expandedSub = this.selectedTrainName.subscribe((trainName) => (this.expanded = this.train.id === trainName));
  }

  ngOnDestroy(): void {
    this.expandedSub.unsubscribe();
  }

  ngOnChanges(): void {}

  public favoriteTrain(): void {
    this.store.next(TrainAction.selectTrain({ trainName: this.expanded ? null : this.train.id }));
  }

  iconFor(train: TrainListEntry) {
    return trainIconFor(train);
  }
}
