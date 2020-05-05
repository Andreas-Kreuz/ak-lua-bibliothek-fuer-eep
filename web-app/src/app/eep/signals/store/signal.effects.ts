import { Injectable } from '@angular/core';
import { Actions, createEffect } from '@ngrx/effects';
import { switchMap } from 'rxjs/operators';

import * as fromSignal from './signal.actions';
import { Signal } from '../models/signal.model';
import { of } from 'rxjs';
import { SignalsService } from './signals.service';
import { SocketEvent } from '../../../core/socket/socket-event';
import { SignalTypeDefinition } from '../models/signal-type-definition.model';

@Injectable()
export class SignalEffects {
  fetchSignals$ = createEffect(() =>
    this.signalsService.getSignalActions().pipe(
      switchMap((data) => {
        const list: Signal[] = JSON.parse(data);
        list.sort((a, b) => a.id - b.id);

        for (const signal of list) {
          if (!signal.model) {
            signal.model = null;
          }
        }
        return of(new fromSignal.SetSignals(list));
      })
    )
  );

  fetchSignalTypDefinitions$ = createEffect(() =>
    this.signalsService.getSignalTypeDefinitionActions().pipe(
      switchMap((data) => {
        const list: SignalTypeDefinition[] = JSON.parse(data);
        return of(new fromSignal.SetSignalTypeDefinitions(list));
      })
    )
  );

  constructor(private actions$: Actions, private signalsService: SignalsService) {}
}
