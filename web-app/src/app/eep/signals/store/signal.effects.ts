import { Injectable } from '@angular/core';
import { Actions, Effect } from '@ngrx/effects';
import { switchMap } from 'rxjs/operators';

import * as fromSignal from './signal.actions';
import { Signal } from '../models/signal.model';
import { of } from 'rxjs';
import { SignalsService } from './signals.service';
import { WsEvent } from '../../../core/socket/ws-event';
import { SignalTypeDefinition } from '../models/signal-type-definition.model';

@Injectable()
export class SignalEffects {

  @Effect()
  fetchSignals$ = this.signalsService.getSignalActions()
    .pipe(
      switchMap(
        (wsEvent: WsEvent) => {
          const list: Signal[] = JSON.parse(wsEvent.payload);
          list.sort((a, b) => a.id - b.id);

          for (const signal of list) {
            if (!signal.model) {
              signal.model = null;
            }
          }
          return of(
            new fromSignal.SetSignals(list),
          );
        }
      )
    );

  @Effect()
  fetchSignalTypDefinitions$ = this.signalsService.getSignalTypeDefinitionActions()
    .pipe(
      switchMap(
        (wsEvent: WsEvent) => {
          const list: SignalTypeDefinition[] = JSON.parse(wsEvent.payload);
          return of(
            new fromSignal.SetSignalTypeDefinitions(list),
          );
        }
      )
    );

  constructor(private actions$: Actions,
              private signalsService: SignalsService) {
  }
}
