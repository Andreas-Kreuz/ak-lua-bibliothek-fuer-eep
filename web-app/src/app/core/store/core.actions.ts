import { createAction, props } from '@ngrx/store';

import { ModuleInfo } from '../model/module-info.model';

export const setModules = createAction('[Core] Set Modules', props<{ modules: ModuleInfo[] }>());
export const setModulesAvailable = createAction('[Core] Set Modules Available');
export const setEepVersion = createAction('[Core] Set EEP version', props<{ version: string }>());
export const setEepLuaVersion = createAction('[Core] Set EEP Lua version', props<{ version: string }>());
export const setEepWebVersion = createAction('[Core] Set EEP Web version', props<{ version: string }>());
export const setJsonServerUrl = createAction('[Core] Set JSON Server URL', props<{ url: string }>());
export const connectedToServer = createAction('[Core] Set Connected');
export const disconnectedFromServer = createAction('[Core] Set Disconnected');
