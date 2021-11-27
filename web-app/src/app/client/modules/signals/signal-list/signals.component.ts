import { Component, OnDestroy, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { select, Store } from '@ngrx/store';

import { Signal } from '../models/signal.model';
import * as fromRoot from '../../../../app.reducers';
import * as fromEep from '../store/signal.reducers';
import { car, trafficLight } from '../../../../shared/unicode-symbol.model';
import { SignalTypeDefinition } from '../models/signal-type-definition.model';

@Component({
  selector: 'app-signals',
  templateUrl: './signals.component.html',
  styleUrls: ['./signals.component.css'],
})
export class SignalsComponent implements OnInit, OnDestroy {
  columnsToDisplay: string[] = ['id', 'position', 'model', 'waitingVehiclesCount'];
  columnNames = new Map([
    ['id', '#'],
    ['position', 'Position'],
    ['model', 'EEP-Modell'],
    ['waitingVehiclesCount', '# Wartende Fahrzeuge'],
  ]);
  columnTextFunctions: Map<string, (arg0: any) => string> = new Map([
    ['position', this.positionTextOf],
    ['model', this.modelTextOf],
    ['waitingVehiclesCount', this.waitingCarsOf],
  ]);
  tableData$ = this.store.select(fromEep.signalsWithModel$);

  constructor(private store: Store<fromRoot.State>) {}

  ngOnInit() {}

  ngOnDestroy() {}

  trackSignalBy(index: number, signal: Signal) {
    if (!signal) {
      return null;
    }
    return signal.id;
  }

  positionTextOf(signal: Signal): string {
    let text: string = '' + signal.position;
    if (signal.model) {
      if (signal.model.type === 'road') {
        text = trafficLight + ' ' + SignalTypeDefinition.signalPositionName(signal.model, signal.position);
      }
    }
    return text;
  }

  // TODO: Seems to be shown as "object"
  modelTextOf(signal: Signal) {
    if (signal.model) {
      let text = '';
      if (signal.model.type === 'road') {
        text = text + trafficLight + ' ';
      }
      text = text + signal.model.name;
      return text;
    } else {
      return '-';
    }
  }

  waitingCarsOf(signal: Signal) {
    return new Array(signal.waitingVehiclesCount + 1).join(car);
  }
}
