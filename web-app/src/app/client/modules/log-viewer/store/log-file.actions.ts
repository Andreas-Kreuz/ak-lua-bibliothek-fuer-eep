import { Action, createAction, props } from '@ngrx/store';
import { SocketEvent } from '../../../../core/socket/socket-event';

export const linesAdded = createAction('[Log] Lines Added', props<{ lines: string }>());
export const linesCleared = createAction('[Log] Lines Cleared');
export const clearLog = createAction('[Log] Clear Log');
export const sendTestMessage = createAction('[Log] Send Test Message');
