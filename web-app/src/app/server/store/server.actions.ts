import { createAction, props } from '@ngrx/store';

// export const eepStalled = createAction('[Server] EEP Stalled');
// export const pauseEep = createAction('[Server] Pause EEP');
// export const eepPaused = createAction('[Server] EEP Paused');
// export const resumeEep = createAction('[Server] Resume EEP');
export const changeEepDirectory = createAction('[Server] Change EepDirectory', props<{ eepDir: string }>());
export const changeEepDirectorySuccess = createAction(
  '[Server] Change EepDirectory Success',
  props<{ eepDir: string }>()
);
export const changeEepDirectoryFailure = createAction(
  '[Server] Change EepDirectory Failure',
  props<{ eepDir: string }>()
);
// export const statsReceived = createAction('[Server] Stats Received');
