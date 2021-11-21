import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SignalsComponent } from './signal-list/signals.component';
import { SignalDetailComponent } from './signal-detail/signal-detail.component';
import { SignalsRoutingModule } from './signals-routing.module';
import { SharedModule } from '../../../shared/shared.module';
import { SignalsService } from './store/signals.service';
import { signalFeature } from './store/signal.reducers';
import { SignalEffects } from './store/signal.effects';
import { StoreModule } from '@ngrx/store';
import { EffectsModule } from '@ngrx/effects';

@NgModule({
  providers: [SignalsService],
  declarations: [SignalsComponent, SignalDetailComponent],
  imports: [
    SignalsRoutingModule,
    CommonModule,
    SharedModule,
    StoreModule.forFeature(signalFeature),
    EffectsModule.forFeature([SignalEffects]),
  ],
})
export class SignalsModule {}
