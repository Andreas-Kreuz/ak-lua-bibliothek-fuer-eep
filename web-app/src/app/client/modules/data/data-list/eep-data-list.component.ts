import { Component, OnDestroy, OnInit } from '@angular/core';
import * as fromRoot from '../../../../app.reducers';
import { select, Store } from '@ngrx/store';
import * as EepSlotAction from '../store/eep-data.actions';
import * as fromEepData from '../store/eep-data.reducers';
import { EepDataService } from '../store/eep-data.service';
import { EepData } from '../models/eep-data.model';
import { Observable } from 'rxjs';
import { EepFreeData } from '../models/eep-free-data.model';
import { disconnect } from 'process';

@Component({
  selector: 'app-eep-data-list',
  templateUrl: './eep-data-list.component.html',
  styleUrls: ['./eep-data-list.component.css'],
})
export class EepDataListComponent implements OnInit, OnDestroy {
  columnsToDisplay: string[] = ['id', 'name', 'data'];
  columnNames = new Map([
    ['id', '#'],
    ['name', 'Name'],
    ['data', 'Inhalt]'],
  ]);
  tableData$ = this.store.select(fromEepData.eepData$);
  firstFreeSlots$ = this.store.select(fromEepData.firstEepFreeData$);

  constructor(private eepDataService: EepDataService, private store: Store<fromRoot.State>) {}

  ngOnInit() {}

  ngOnDestroy() {
    this.store.dispatch(EepSlotAction.disconnect());
  }
}
