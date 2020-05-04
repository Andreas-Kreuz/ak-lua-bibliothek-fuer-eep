import { Action, createReducer, on } from '@ngrx/store';
import { changeEepDirectoryFailure, changeEepDirectorySuccess } from './server.actions';

export const FeatureKey = '';

export interface State {
  eepDir: string;
  eepDirOk: boolean;
}

export const initialState: State = {
  eepDir: 'unknown',
  eepDirOk: false,
};

export const reducer = createReducer(
  initialState,
  on(changeEepDirectorySuccess, (state: State, { eepDir: eepDir }) => ({ ...state, eepDir: eepDir })),
  on(changeEepDirectoryFailure, (state: State, { eepDir: eepDir }) => ({ ...state, eepDir: eepDir }))
);
