import { Component, OnInit } from '@angular/core';
import { select, Store } from '@ngrx/store';
import * as fromRoot from '../../../app.reducers';
import * as fromGenericActions from '../store/generic-data.actions';
import * as fromGenericData from '../store/generic-data.reducers';
import { Observable, Subject } from 'rxjs';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { switchMap } from 'rxjs/operators';

@Component({
  selector: 'app-generic-data',
  templateUrl: './generic-data.component.html',
  styleUrls: ['./generic-data.component.css']
})
export class GenericDataComponent implements OnInit {
  data$: Observable<{ dataName: string, valueColumns: string[], values: any[] }>;
  tableData = new Subject<any[]>();
  tableData$ = this.tableData.asObservable();

  constructor(private store: Store<fromRoot.State>,
              private route: ActivatedRoute) {
  }

  ngOnInit() {
    this.data$ = this.route.paramMap.pipe(
      switchMap((params: ParamMap) => {
        const name = params.get('name');
        const hostName = params.get('hostName');
        const path = params.get('path');

        this.store.dispatch(
          new fromGenericActions.FetchData(
            {
              name: name,
              hostName: hostName,
              path: path,
            }));
        return this.store.pipe(select(fromGenericData.selectedDataStructure(name)));
      })
    );
    this.data$.subscribe(data => this.tableData.next(data.values));
  }
}
