import { Action } from '@ngrx/store';
import { Signal } from '../models/signal.model';
import { HttpErrorResponse } from '@angular/common/http';
import { SignalTypeDefinition } from '../models/signal-type-definition.model';

export const FETCH_SIGNALS = '[Signals] FETCH_SIGNALS';
export const FETCH_SIGNAL_TYPE_DEFINITIONS = '[Signals] FETCH_SIGNAL_TYPE_DEFINITIONS';
export const FETCH_SIGNAL_TYPES = '[Signals] FETCH_SIGNAL_TYPES';
export const SET_SIGNALS = '[Signals] SET_SIGNALS';
export const SET_SIGNAL_TYPES = '[Signals] SET_SIGNAL_TYPES';
export const SET_SIGNAL_TYPE_DEFINITIONS = '[Signals] SET_SIGNAL_TYPE_DEFINITIONS';
export const SELECT_SIGNAL = '[Signals] Select';
export const DESELECT_SIGNAL = '[Signals] Deselect';
export const ERROR = '[Signals] ERROR';

export interface FetchAction extends Action {
  payload: string;
}

export class FetchSignals implements Action, FetchAction {
  readonly type = FETCH_SIGNALS;

  constructor(public payload: string) {
  }
}

export class FetchSignalTypes implements Action, FetchAction {
  readonly type = FETCH_SIGNAL_TYPES;

  constructor(public payload: string) {
  }
}

export class FetchSignalTypeDefinitions implements Action, FetchAction {
  readonly type = FETCH_SIGNAL_TYPE_DEFINITIONS;

  constructor(public payload: string) {
  }
}

export class SetSignals implements Action {
  readonly type = SET_SIGNALS;

  constructor(public payload: Signal[]) {
  }
}

export class SetSignalTypes implements Action {
  readonly type = SET_SIGNAL_TYPES;

  constructor(public payload: Map<number, string>) {
  }
}

export class SetSignalTypeDefinitions implements Action {
  readonly type = SET_SIGNAL_TYPE_DEFINITIONS;

  constructor(public payload: SignalTypeDefinition[]) {
  }
}

export class SelectSignal implements Action {
  readonly type = SELECT_SIGNAL;

  constructor(public payload: number) {
  }
}

export class LogError implements Action {
  readonly type = ERROR;

  constructor(public payload: HttpErrorResponse) {
  }
}

export class DeselectSignal implements Action {
  readonly type = DESELECT_SIGNAL;
}


export type SignalActions =
  FetchSignals
  | FetchSignalTypeDefinitions
  | FetchSignalTypes
  | SetSignals
  | SetSignalTypes
  | SetSignalTypeDefinitions
  | SelectSignal
  | DeselectSignal
  | LogError;
