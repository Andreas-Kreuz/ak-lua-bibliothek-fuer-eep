import { createFeatureSelector, createReducer, createSelector, on } from '@ngrx/store';
import { changeEepDirectoryFailure, changeEepDirectorySuccess, urlsChanged } from './server.actions';

export const FEATURE_KEY = 'server';

export interface State {
  eepDir: string;
  eepDirOk: boolean;
  urls: string[];
}

export const initialState: State = {
  eepDir: '-',
  eepDirOk: false,
  urls: [],
};

export const reducer = createReducer(
  initialState,
  on(changeEepDirectorySuccess, (state: State, { eepDir: eepDir }) => {
    console.log('DIR OK ' + eepDir);
    return { ...state, eepDirOk: true, eepDir };
  }),
  on(changeEepDirectoryFailure, (state: State, { eepDir: eepDir }) => {
    console.log('DIR ERROR ' + eepDir);
    return { ...state, eepDirOk: false, eepDir };
  }),
  on(urlsChanged, (state: State, { urls: urls }) => {
    console.log('URLs changed ' + urls);
    return { ...state, urls };
  })
);

export const appState = createFeatureSelector('server');
export const eepDir$ = createSelector(appState, (state: State) => state.eepDir);
export const eepDirOk$ = createSelector(appState, (state: State) => state.eepDirOk);
export const urls$ = createSelector(appState, (state: State) => state.urls);
export const urlsAvailable$ = createSelector(appState, (state: State) => state.urls.length > 0);
