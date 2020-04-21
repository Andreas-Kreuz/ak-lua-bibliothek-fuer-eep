import { createFeatureSelector, createSelector } from '@ngrx/store';

import * as CoreAction from './core.actions';
import { Alert } from '../error/alert.model';
import { environment } from '../../../environments/environment';
import { EepWebUrl } from '../server-status/eep-web-url.model';
import { Status } from '../server-status/status.enum';


export interface State {
  lastAlert: Alert;
  alerts: Alert[];
  jsonServerUrl: string;
  connectionEstablished: boolean;
  connectionStatus: Status;
  eepVersion: string;
  eepLuaVersion: string;
  eepWebVersion: string;
  urlStatus: EepWebUrl[];
}

const initialState: State = {
  lastAlert: new Alert('info', 'Die Anwendung wurde gestartet'),
  alerts: [
    new Alert('info', 'Die Anwendung wurde gestartet')
  ],
  jsonServerUrl: 'http://localhost:3000',
  connectionEstablished: false,
  connectionStatus: Status.INFO,
  eepVersion: '?',
  eepLuaVersion: '?',
  eepWebVersion: environment.VERSION,
  urlStatus: [],
};

export function reducer(state: State = initialState, action: CoreAction.CoreActions) {
  switch (action.type) {
    case CoreAction.SHOW_ERROR:
      const newState: State = {
        ...state,
        alerts: [action.payload, ...state.alerts.slice(0, Math.min(state.alerts.length, 20))],
        lastAlert: action.payload,
      };
      return newState;
    case CoreAction.HIDE_ERROR:
      const oldErrors = [...state.alerts];
      oldErrors.splice(state.alerts.indexOf(action.payload), 1);
      return {
        ...state,
        alerts: oldErrors
      };
    case CoreAction.SHOW_URL_ERROR:
    case CoreAction.SHOW_URL_SUCCESS:
      const newUrlStatus1: EepWebUrl[] = [];
      for (const oldUrl of state.urlStatus) {
        if (oldUrl.path !== action.payload.path) {
          newUrlStatus1.push(oldUrl);
        }
      }
      newUrlStatus1.push(action.payload);
      newUrlStatus1.sort((a: EepWebUrl, b: EepWebUrl) => {
          return a.path < b.path ? -1 : 1;
        }
      );

      return {
        ...state,
        urlStatus: newUrlStatus1,
      };
    case CoreAction.SET_JSON_SERVER_URL:
      return {
        ...state,
        jsonServerUrl: action.payload
      };
    case CoreAction.SET_CONNECTION_STATUS_SUCCESS:
      return {
        ...state,
        connectionStatus: Status.SUCCESS,
      };
    case CoreAction.SET_CONNECTION_STATUS_ERROR:
      return {
        ...state,
        connectionStatus: Status.ERROR,
      };
    case CoreAction.SET_CONNECTED:
      return {
        ...state,
        connectionEstablished: true
      };
    case CoreAction.SET_EEP_VERSION:
      return {
        ...state,
        eepVersion: action.payload
      };
    case CoreAction.SET_EEP_LUA_VERSION:
      return {
        ...state,
        eepLuaVersion: action.payload
      };
    case CoreAction.SET_EEP_WEB_VERSION:
      return {
        ...state,
        eepWebVersion: action.payload
      };
    default:
      return state;
  }
}

export const appState = createFeatureSelector('core');

export const getAlerts = createSelector(
  appState,
  (state: State) => state.alerts
);

export const getConnectionEstablished = createSelector(
  appState,
  (state: State) => state.connectionEstablished
);

export const selectConnectionStatus = createSelector(
  appState,
  (state: State) => state.connectionStatus
);

export const getJsonServerUrl = createSelector(
  appState,
  (state: State) => state.jsonServerUrl
);

export const getLastAlert = createSelector(
  appState,
  (state: State) => state.lastAlert
);

export const selectEepVersion = createSelector(
  appState,
  (state: State) => state.eepVersion
);

export const selectEepWebVersion = createSelector(
  appState,
  (state: State) => state.eepWebVersion
);

export const selectEepLuaVersion = createSelector(
  appState,
  (state: State) => state.eepLuaVersion
);

export const getApiPaths$ = createSelector(
  appState,
  (state: State) => state.urlStatus
);
