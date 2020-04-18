import { Injectable } from '@angular/core';
import { Actions, Effect, ofType } from '@ngrx/effects';
import { of } from 'rxjs';
import { filter, map, switchMap } from 'rxjs/operators';

import * as fromLogFile from './log-file.actions';
import { WsEvent } from '../../../core/socket/ws-event';
import { WsEventUtil } from '../../../core/socket/ws-event-util';
import { LogFileService } from './log-file.service';

@Injectable()
export class LogFileEffects {

  @Effect()
  cleared$ = this.logFileService.getActions()
    .pipe(
      filter(wsEvent => WsEventUtil.storeAction(wsEvent) === fromLogFile.CLEARED),
      switchMap(wsEvent => of(new fromLogFile.Cleared()))
    );

  @Effect()
  linesAdded$ = this.logFileService.getActions()
    .pipe(
      filter(wsEvent => WsEventUtil.storeAction(wsEvent) === fromLogFile.LINES_ADDED),
      switchMap(wsEvent => of(new fromLogFile.LinesAdded(wsEvent.payload)))
    );

  @Effect({dispatch: false}) // effect will not dispatch any actions
  clearLogCommand$ = this.actions$.pipe(
    ofType(fromLogFile.CLEAR),
    map((action: fromLogFile.SendCommand) =>
      this.logFileService.emit(
        new WsEvent('[EEPCommand]', 'Send', action.payload))
    )
  );

  @Effect({dispatch: false}) // effect will not dispatch any actions
  testMessage$ = this.actions$.pipe(
    ofType(fromLogFile.SEND_MESSAGE),
    map((action: fromLogFile.SendCommand) =>
      this.logFileService.emit(
        new WsEvent('[EEPCommand]', 'Send', action.payload))
    )
  );

  constructor(private actions$: Actions,
              private logFileService: LogFileService) {
  }
}

