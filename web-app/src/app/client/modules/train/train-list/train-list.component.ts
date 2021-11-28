import { Component, OnDestroy, OnInit } from '@angular/core';
import { Observable, Subscription } from 'rxjs';
import { OldTrain } from '../model/train.model';
import { select, Store } from '@ngrx/store';
import * as TrainAction from '../store/train.actions';
import * as fromTrain from '../store/train.reducer';
import { ActivatedRoute, Params } from '@angular/router';
import { textForTrainType, TrainType } from '../model/train-type.enum';
import { TrainService } from '../store/train.service';
import { Train, TrainListEntry } from 'web-shared/build/model/trains';

@Component({
  selector: 'app-train-list',
  templateUrl: './train-list.component.html',
  styleUrls: ['./train-list.component.css'],
})
export class TrainListComponent implements OnInit, OnDestroy {
  trainList = this.store.select(fromTrain.sortedTrainList);
  trainType$ = this.store.select(fromTrain.trainFeature.selectTrainType);
  private routeParams$: Subscription;

  constructor(private store: Store<fromTrain.State>, private route: ActivatedRoute) {}

  ngOnInit() {
    this.store.dispatch(TrainAction.initModule());
    this.routeParams$ = this.route.params.subscribe((params: Params) => {
      this.store.dispatch(TrainAction.selectType({ trainType: this.route.snapshot.params['trainType'] }));
    });
  }

  typeString(t: TrainType) {
    return textForTrainType(t);
  }

  ngOnDestroy(): void {
    this.store.dispatch(TrainAction.destroyModule());
    this.routeParams$.unsubscribe();
  }

  trackByTrainId(index: number, train: TrainListEntry) {
    return train.id;
  }
}
