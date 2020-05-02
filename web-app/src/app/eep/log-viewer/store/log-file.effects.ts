import { Injectable } from '@angular/core';
import { Actions, Effect, ofType, createEffect } from '@ngrx/effects';
import { of } from 'rxjs';
import { filter, map, switchMap, tap, exhaustMap, concatMap } from 'rxjs/operators';

import * as LogFileActions from './log-file.actions';
import { WsEvent } from '../../../core/socket/ws-event';
import { WsEventUtil } from '../../../core/socket/ws-event-util';
import { LogFileService } from './log-file.service';

@Injectable()
export class LogFileEffects {
  logLinesAdded$ = createEffect(() =>
    this.logFileService.logLinesAdded$.pipe(
      map((data) => {
        const lines: string = data;
        return LogFileActions.linesAdded({ lines: lines });
      })
      // mergeMap(() => this.logFileService.logLinesAdded$.pipe(
      //   map(wsEvent => {
      //   const lines: string = JSON.parse(wsEvent.payload);
      //   return of(() => new LogFileActions.linesAdded({ lines: lines }));
      // }
    )
  );

  clearLogLines$ = createEffect(
    () =>
      this.actions$.pipe(
        ofType(LogFileActions.clearLog),
        tap(() => this.logFileService.clearLog())
      ),
    { dispatch: false }
  );

  sendTestMessage$ = createEffect(
    () =>
      this.actions$.pipe(
        ofType(LogFileActions.sendTestMessage),
        tap(() => this.logFileService.sendTestMessage())
      ),
    { dispatch: false }
  );

  logLinesCleared$ = createEffect(() =>
    this.actions$.pipe(
      ofType(LogFileActions.linesCleared),
      tap(() => LogFileActions.linesCleared)
    )
  );

  // @Effect()
  // cleared$ = this.logFileService.getActions()
  //   .pipe(
  //     filter(wsEvent => WsEventUtil.storeAction(wsEvent) === LogEvent.LinesCleared),
  //     switchMap(wsEvent => of(LogFileActions.cleared)
  //   );

  // @Effect()
  // linesAdded$ = this.logFileService.getActions()
  //   .pipe(
  //     filter(wsEvent => WsEventUtil.storeAction(wsEvent) === LogEvent.LinesAdded),
  //     switchMap(wsEvent => of(LogFileActions.linesAdded(wsEvent.payload)))
  //   );

  // @Effect({dispatch: false}) // effect will not dispatch any actions
  // clearLogCommand$ = this.actions$.pipe(
  //   ofType(LogFileActions.CLEAR),
  //   map((action: LogFileActions.SendCommand) =>
  //     this.logFileService.emit(
  //       new WsEvent('[Command Event]', action.payload))
  //   )
  // );

  // @Effect({dispatch: false}) // effect will not dispatch any actions
  // testMessage$ = this.actions$.pipe(
  //   ofType(LogFileActions.SEND_MESSAGE),
  //   map((action: LogFileActions.SendCommand) =>
  //     this.logFileService.emit(
  //       new WsEvent('[Command Event]', action.payload))
  //   )
  // );

  constructor(private actions$: Actions, private logFileService: LogFileService) {}
}
