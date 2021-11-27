import { Component, OnDestroy, OnInit } from '@angular/core';
import { Observable, Subscription } from 'rxjs';
import { Train } from '../model/train.model';
import { select, Store } from '@ngrx/store';
import * as TrainAction from '../store/train.actions';
import * as fromTrain from '../store/train.reducer';
import { ActivatedRoute, Params } from '@angular/router';
import { textForTrainType, TrainType } from '../model/train-type.enum';

@Component({
  selector: 'app-train-list',
  templateUrl: './train-list.component.html',
  styleUrls: ['./train-list.component.css'],
})
export class TrainListComponent implements OnInit, OnDestroy {
  trainType$ = this.store.select(fromTrain.selectTrainType);
  tableData$ = this.store.select(fromTrain.selectTrains);
  private routeParams$: Subscription;

  constructor(private store: Store<fromTrain.State>, private route: ActivatedRoute) {}

  ngOnInit() {
    this.routeParams$ = this.route.params.subscribe((params: Params) => {
      this.store.dispatch(TrainAction.selectType({ trainType: this.route.snapshot.params['trainType'] }));
    });
  }

  typeString(t: TrainType) {
    return textForTrainType(t);
  }

  ngOnDestroy(): void {
    this.routeParams$.unsubscribe();
  }

  trackByTrainId(index: number, train: Train) {
    return train.id;
  }
}
