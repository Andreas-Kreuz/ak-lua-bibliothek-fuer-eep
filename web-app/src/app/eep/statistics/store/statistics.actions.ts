import { createAction, props } from '@ngrx/store';
import TimeDesc from './time-desc';

export const serverControllerUpdate = createAction(
  '[Statistics] LUA Server Controller Update',
  props<{ times: TimeDesc[] }>()
);
