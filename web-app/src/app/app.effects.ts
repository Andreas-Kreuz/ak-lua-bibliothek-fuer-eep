import { CoreEffects } from './core/store/core.effects';
import { DataTypesEffects } from './core/datatypes/store/data-types.effects';
import { SignalEffects } from './eep/signals/store/signal.effects';
import { TrainEffects } from './eep/trains/store/train.effects';

export const effects = [CoreEffects, DataTypesEffects, SignalEffects, TrainEffects];
