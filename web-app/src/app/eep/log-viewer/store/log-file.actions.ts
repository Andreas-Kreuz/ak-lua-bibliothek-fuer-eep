import { Action } from '@ngrx/store';

export const LINES_ADDED = '[Log] Lines Added';
export const CLEARED = '[Log] Lines Cleared';
export const CLEAR = '[Log] Clear Log';
export const SEND_MESSAGE = '[Log] Send Test Message';

export class LinesAdded implements Action {
  readonly type = LINES_ADDED;

  /**
   * @param payload One or multiple log lines.
   */
  constructor(public payload: string) {
  }
}

export class Clear implements Action {
  readonly type = CLEAR;

  constructor() {
  }
}

export class Cleared implements Action {
  readonly type = CLEARED;

  constructor() {
  }
}

export class SendCommand implements Action {
  readonly type = SEND_MESSAGE;

  /**
   * @param command
   */
  constructor(public payload: string) {
  }
}

export type LogFileActions =
  LinesAdded
  | Cleared
  | Clear
  | SendCommand;
