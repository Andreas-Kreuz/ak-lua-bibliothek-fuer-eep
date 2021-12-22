import { createFeatureSelector, createSelector, on, createReducer, Action } from '@ngrx/store';

import * as CoreAction from './core.actions';
import { environment } from '../../../environments/environment';
import { ModuleInfo } from '../model/module-info.model';

export interface State {
  jsonServerUrl: string;
  connectionEstablished: boolean;
  eepVersion: string;
  eepLuaVersion: string;
  eepWebVersion: string;
  modules: ModuleInfo[];
  modulesAvailable: boolean;
}

const initialState: State = {
  jsonServerUrl: 'http://localhost:3000',
  connectionEstablished: true,
  eepVersion: '?',
  eepLuaVersion: '?',
  eepWebVersion: environment.version,
  modules: [],
  modulesAvailable: false,
};

const coreReducer = createReducer(
  initialState,
  on(CoreAction.setJsonServerUrl, (state: State, { url: url }) => ({ ...state, jsonServerUrl: url })),
  on(CoreAction.connectedToServer, (state) => ({ ...state, connectionEstablished: true })),
  on(CoreAction.disconnectedFromServer, (state) => ({ ...state, connectionEstablished: false })),
  on(CoreAction.setEepVersion, (state: State, { version: version }) => ({ ...state, eepVersion: version })),
  on(CoreAction.setEepLuaVersion, (state: State, { version: version }) => ({ ...state, eepLuaVersion: version })),
  on(CoreAction.setEepWebVersion, (state: State, { version: version }) => ({ ...state, eepWebVersion: version })),
  on(CoreAction.setModules, (state: State, { modules: modules }) => ({ ...state, modules })),
  on(CoreAction.setModulesAvailable, (state: State) => ({ ...state, modulesAvailable: true }))
);

export const reducer = (state: State | undefined, action: Action) => coreReducer(state, action);

export const appState = createFeatureSelector<State>('core');

export const getConnectionEstablished = createSelector(appState, (state: State) => state.connectionEstablished);

export const getJsonServerUrl = createSelector(appState, (state: State) => state.jsonServerUrl);

export const selectEepVersion = createSelector(appState, (state: State) => state.eepVersion);

export const selectEepWebVersion = createSelector(appState, (state: State) => state.eepWebVersion);

export const selectEepLuaVersion = createSelector(appState, (state: State) => state.eepLuaVersion);

export const getModuleInfos$ = createSelector(appState, (state: State) => state.modules);

export const isModuleLoaded$ = (moduleId: string) =>
  createSelector(getModuleInfos$, (moduleInfos) => moduleInfos.some((i: ModuleInfo) => moduleId === i.id));

export const isModulesAvailable = createSelector(appState, (state: State) => state.modulesAvailable);
