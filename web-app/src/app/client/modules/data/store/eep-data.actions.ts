import { EepData } from '../models/eep-data.model';
import { createAction, props } from '@ngrx/store';
import { EepFreeData } from '../models/eep-free-data.model';

export const disconnect = createAction('[EEP-Data] Disconnect');
export const setSlots = createAction('[EEP-Data] Set slots', props<{ slots: EepData[] }>());
export const setFreeSlots = createAction('[EEP-Data] Set free slots', props<{ freeSlots: EepFreeData[] }>());
