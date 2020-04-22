import { Action, createAction, props } from '@ngrx/store';

import { Alert } from '../error/alert.model';
import { EepWebUrl } from '../server-status/eep-web-url.model';

export const showError = createAction('[Core] SHOW_ERROR', props<{ alert: Alert }>());
export const hideError = createAction('[Core] HIDE_ERROR', props<{ alert: Alert }>());
export const showUrlError = createAction('[Core] Show URL error', props<{ url: EepWebUrl }>());
export const showUrlSuccess = createAction('[Core] Show URL success', props<{ url: EepWebUrl }>());
export const setEepVersion = createAction('[Core] Set EEP version', props<{ version: string }>());
export const setEepLuaVersion = createAction('[Core] Set EEP Lua version', props<{ version: string }>());
export const setEepWebVersion = createAction('[Core] Set EEP Web version', props<{ version: string }>());
export const setJsonServerUrl = createAction('[Core] Set JSON Server URL', props<{ url: string }>());
export const setConnected = createAction('[Core] Set EEP Web version');
export const setConnectionStatusSuccess = createAction('[Core] Connection Status Success');
export const setConnectionStatusError = createAction('[Core] Connection Status Error');
