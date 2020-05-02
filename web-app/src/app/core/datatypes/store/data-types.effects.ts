import { Injectable } from '@angular/core';
import { Effect } from '@ngrx/effects';
import { map } from 'rxjs/operators';

import { SocketService } from '../../socket/socket-service';
import * as fromDataTypes from './data-types.actions';
import { DataTypesService } from './data-types.service';

@Injectable()
export class DataTypesEffects {
  @Effect()
  dataTypes = this.dataTypesService.logLinesCleared$.pipe(
    map((data) => fromDataTypes.setDataTypes({ types: JSON.parse(data) }))
  );

  constructor(private wsService: SocketService, private dataTypesService: DataTypesService) {}
}
