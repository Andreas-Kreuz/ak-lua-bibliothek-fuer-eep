import { Injectable } from '@angular/core';
import { Actions, Effect, ofType, createEffect } from '@ngrx/effects';
import { of } from 'rxjs';
import { filter, map, switchMap, tap, exhaustMap, concatMap } from 'rxjs/operators';

import * as LogFileActions from './log-file.actions';
import { LogFileService } from './log-file.service';

@Injectable()
export class LogFileEffects {
  logLinesAdded$ = createEffect(() =>
    this.logFileService.logLinesAdded$.pipe(
      map((data) => {
        const lines: string = data;
        return LogFileActions.linesAdded({ lines: lines });
      })
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

  constructor(private actions$: Actions, private logFileService: LogFileService) {}
}
