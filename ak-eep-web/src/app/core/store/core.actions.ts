import { Action } from '@ngrx/store';

import { Alert } from '../error/alert.model';
import { EepWebUrl } from '../server-status/eep-web-url.model';

export const SHOW_ERROR = '[Core] SHOW_ERROR';
export const HIDE_ERROR = '[Core] HIDE_ERROR';
export const SET_JSON_SERVER_URL = '[Core] Set JSON Server URL';
export const SET_CONNECTED = '[Core] Connected';
export const SET_CONNECTION_STATUS_SUCCESS = '[Core] Connection Status Success';
export const SET_CONNECTION_STATUS_ERROR = '[Core] Connection Status Danger';
export const SET_EEP_VERSION = '[Core] Set EEP version';
export const SET_EEP_LUA_VERSION = '[Core] Set EEP Lua version';
export const SET_EEP_WEB_VERSION = '[Core] Set EEP Web version';
export const SHOW_URL_ERROR = '[Core] Show URL error';
export const SHOW_URL_SUCCESS = '[Core] Show URL success';

export class ShowError implements Action {
  readonly type = SHOW_ERROR;

  constructor(public payload: Alert) {
  }
}

export class HideError implements Action {
  readonly type = HIDE_ERROR;

  /**
   * @param payload Index of the error message
   */
  constructor(public payload: Alert) {
  }
}

export class ShowUrlError implements Action {
  readonly type = SHOW_URL_ERROR;

  /** @param payload URL   */
  constructor(public payload: EepWebUrl) {
  }
}

export class ShowUrlSuccess implements Action {
  readonly type = SHOW_URL_SUCCESS;

  /** @param payload URL   */
  constructor(public payload: EepWebUrl) {
  }
}

export class SetEepVersion implements Action {
  readonly type = SET_EEP_VERSION;

  /**
   * @param payload Version as String
   */
  constructor(public payload: string) {
  }
}

export class SetEepLuaVersion implements Action {
  readonly type = SET_EEP_LUA_VERSION;

  /**
   * @param payload Version as String
   */
  constructor(public payload: string) {
  }
}

export class SetEepWebVersion implements Action {
  readonly type = SET_EEP_WEB_VERSION;

  /**
   * @param payload Version as String
   */
  constructor(public payload: string) {
  }
}

export class SetJsonServerUrl implements Action {
  readonly type = SET_JSON_SERVER_URL;

  /**
   * @param payload Index of the error message
   */
  constructor(public payload: string) {
  }
}

export class SetConnected implements Action {
  readonly type = SET_CONNECTED;
}

export class SetConnectionStatusSuccess implements Action {
  readonly type = SET_CONNECTION_STATUS_SUCCESS;
}

export class SetConnectionStatusError implements Action {
  readonly type = SET_CONNECTION_STATUS_ERROR;
}

export type CoreActions =
  ShowError
  | HideError
  | ShowUrlError
  | ShowUrlSuccess
  | SetJsonServerUrl
  | SetConnected
  | SetConnectionStatusSuccess
  | SetConnectionStatusError
  | SetEepVersion
  | SetEepLuaVersion
  | SetEepWebVersion;
