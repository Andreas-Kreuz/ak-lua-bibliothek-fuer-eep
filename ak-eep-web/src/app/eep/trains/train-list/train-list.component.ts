import { Component, OnDestroy, OnInit } from '@angular/core';
import { Observable, Subscription } from 'rxjs';
import { Train } from '../model/train.model';
import { select, Store } from '@ngrx/store';
import * as fromRoot from '../../../app.reducers';
import * as TrainAction from '../store/train.actions';
import * as fromTrain from '../store/train.reducer';
import { ActivatedRoute, Params } from '@angular/router';
import { textForTrainType, TrainType } from '../model/train-type.enum';
import { Coupling } from '../model/coupling.enum';
import { TrainDetailsComponent } from '../train-details/train-details.component';

@Component({
  selector: 'app-train-list',
  templateUrl: './train-list.component.html',
  styleUrls: ['./train-list.component.css']
})
export class TrainListComponent implements OnInit, OnDestroy {
  trainType$: Observable<TrainType>;
  columnsToDisplay: string[] = [
    'id',
    'route',
    'rollingStock',
    'coupling',
    'length',
  ];
  columnNames = {
    id: 'Name',
    route: 'Route',
    rollingStock: 'Wagen',
    coupling: 'Kupplung',
    length: 'Länge',
  };
  columnTextFunctions = {
    rollingStock: (train: Train) => train && train.rollingStock ? train.rollingStock.length : 0,
    coupling: this.getCouplingText,
    length: (train: Train) =>
      train && train.length
        ? train.length.toFixed(1)
        : 0,
  };
  columnAlignment = {
    length: 'right',
  };
  tableData$: Observable<Train[]>;
  private routeParams$: Subscription;
  trainDetailsComponent = TrainDetailsComponent;

  constructor(private store: Store<fromRoot.State>,
              private route: ActivatedRoute) {
  }

  ngOnInit() {
    this.routeParams$ = this.route.params
      .subscribe((params: Params) => {
        this.store.dispatch(new TrainAction.SelectType(this.route.snapshot.params['trainType']));
        this.tableData$ = this.store.pipe(select(fromTrain.selectTrains));
        this.trainType$ = this.store.pipe(select(fromTrain.selectTrainType));
      });
  }

  typeString(t: TrainType) {
    return textForTrainType(t);
  }

  ngOnDestroy(): void {
    this.routeParams$.unsubscribe();
  }

  private getCouplingText(train: Train): string {
    let value = '?';
    if (train && train.rollingStock) {
      const frontReady =
        train.rollingStock[0].couplingFront === Coupling.Ready
        || train.rollingStock[0].couplingRear === Coupling.Ready;

      const rearReady =
        train.rollingStock[train.rollingStock.length - 1].couplingFront === Coupling.Ready
        || train.rollingStock[train.rollingStock.length - 1].couplingRear === Coupling.Ready;

      if (frontReady) {
        return rearReady ? 'Bereit (v+h)' : 'Bereit (v)';
      } else if (rearReady) {
        return 'Bereit (h)';
      } else {
        return 'Abstoßen';
      }
    }
    return value;
  }
}
