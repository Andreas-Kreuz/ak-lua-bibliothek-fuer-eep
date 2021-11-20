import { createAction, props } from '@ngrx/store';

// export const eepStalled = createAction('[Server] EEP Stalled');
// export const pauseEep = createAction('[Server] Pause EEP');
// export const eepPaused = createAction('[Server] EEP Paused');
// export const resumeEep = createAction('[Server] Resume EEP');
export const changeEepDirectoryRequest = createAction(
  '[Server] Change EepDirectory Request',
  props<{ eepDir: string }>()
);
export const changeEepDirectorySuccess = createAction(
  '[Server] Change EepDirectory Success',
  props<{ eepDir: string }>()
);
export const changeEepDirectoryFailure = createAction(
  '[Server] Change EepDirectory Failure',
  props<{ eepDir: string }>()
);
export const urlsChanged = createAction('[Server] Urls Changed', props<{ urls: string[] }>());
// export const statsReceived = createAction('[Server] Stats Received');

export const eventCounterChanged = createAction('[Server] Event Counter Updated', props<{ eventCounter: number }>());
