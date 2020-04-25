import { Component, OnDestroy, OnInit } from '@angular/core';
import { select, Store } from '@ngrx/store';
import * as fromGenericData from '../store/generic-data.reducers';
import * as fromCore from '../../../core/store/core.reducers';
import * as fromRoot from '../../../app.reducers';
import { Observable } from 'rxjs';
import { DataType } from '../model/data-type';
import { GenericDataService } from '../store/generic-data.service';

@Component({
  selector: 'app-generic-data-overview',
  templateUrl: './generic-data-overview.component.html',
  styleUrls: ['./generic-data-overview.component.css']
})
export class GenericDataOverviewComponent implements OnInit, OnDestroy {
  hostName$: Observable<string>;
  dataTypes$: Observable<DataType[]>;

  constructor(private genericDataService: GenericDataService,
              private store: Store<fromRoot.State>) {
  }

  ngOnInit() {
    this.genericDataService.connect();
    this.hostName$ = this.store.pipe(select(fromCore.getJsonServerUrl));
    this.dataTypes$ = this.store.pipe(select(fromGenericData.selectDataTypes$));
  }

  ngOnDestroy(): void {
    this.genericDataService.disconnect();
  }

  trackByDataName(index: number, dataType: DataType) {
    if (!dataType) {
      return null;
    }
    return dataType.name;
  }
}
