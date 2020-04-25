import { createFeatureSelector, createSelector, on, createReducer, Action } from '@ngrx/store';

import * as CoreAction from './core.actions';
import { Alert } from '../error/alert.model';
import { environment } from '../../../environments/environment';
import { EepWebUrl } from '../server-status/eep-web-url.model';
import { Status } from '../server-status/status.enum';
import { ModuleInfo } from '../model/module-info.model';


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
  modules: ModuleInfo[];
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
  modules: []
};

const coreReducer = createReducer(
  initialState,
  on(CoreAction.showError, (state: State, { alert: alert }) => ({
    ...state, alerts: [alert, ...state.alerts.slice(0, Math.min(state.alerts.length, 20))],
    lastAlert: alert,
  })),
  on(CoreAction.hideError, (state: State, { alert: alert }) => {
    const oldErrors = [...state.alerts];
    oldErrors.splice(state.alerts.indexOf(alert), 1);
    return {
      ...state,
      alerts: oldErrors
    }
  }),
  on(CoreAction.showUrlSuccess, (state: State, { url: url }) => {
    const newUrlStatus1: EepWebUrl[] = [];
    for (const oldUrl of state.urlStatus) {
      if (oldUrl.path !== url.path) {
        newUrlStatus1.push(oldUrl);
      }
    }
    newUrlStatus1.push(url);
    newUrlStatus1.sort((a: EepWebUrl, b: EepWebUrl) => {
      return a.path < b.path ? -1 : 1;
    }
    );

    return {
      ...state,
      urlStatus: newUrlStatus1,
    };
  }
  ),
  on(CoreAction.showUrlError, (state: State, { url: url }) => {
    const newUrlStatus1: EepWebUrl[] = [];
    for (const oldUrl of state.urlStatus) {
      if (oldUrl.path !== url.path) {
        newUrlStatus1.push(oldUrl);
      }
    }
    newUrlStatus1.push(url);
    newUrlStatus1.sort((a: EepWebUrl, b: EepWebUrl) => {
      return a.path < b.path ? -1 : 1;
    }
    );

    return {
      ...state,
      urlStatus: newUrlStatus1,
    };
  }
  ),
  on(CoreAction.setJsonServerUrl, (state: State, { url: url }) => ({ ...state, jsonServerUrl: url })),
  on(CoreAction.setConnectionStatusSuccess, state => ({ ...state, connectionStatus: Status.SUCCESS })),
  on(CoreAction.setConnectionStatusError, state => ({ ...state, connectionStatus: Status.ERROR })),
  on(CoreAction.setConnected, state => ({ ...state, connectionEstablished: true })),
  on(CoreAction.setEepVersion, (state: State, { version: version }) => ({ ...state, eepVersion: version })),
  on(CoreAction.setEepLuaVersion, (state: State, { version: version }) => ({ ...state, eepLuaVersion: version })),
  on(CoreAction.setEepWebVersion, (state: State, { version: version }) => ({ ...state, eepWebVersion: version })),
  on(CoreAction.setModules, (state: State, { modules: modules }) => ({ ...state, modules: modules }))
);

export function reducer(state: State | undefined, action: Action) {
  return coreReducer(state, action);
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

export const getModuleInfos$ = createSelector(
  appState,
  (state: State) => state.modules
);

export const isModuleLoaded$ = (moduleId: string) => createSelector(
  getModuleInfos$,
  moduleInfos => moduleInfos.some((i: ModuleInfo) => moduleId === i.id)
);
