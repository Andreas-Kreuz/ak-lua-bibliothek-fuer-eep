import { CoreEffects } from './core/store/core.effects';
import { DataTypesEffects } from './core/datatypes/store/data-types.effects';
import { GenericDataEffects } from './eep/generic-data/store/generic-data.effects';
import { SignalEffects } from './eep/signals/store/signal.effects';
import { TrainEffects } from './eep/trains/store/train.effects';

export const effects = [CoreEffects, DataTypesEffects, GenericDataEffects, SignalEffects, TrainEffects];
