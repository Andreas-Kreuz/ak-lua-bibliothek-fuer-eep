import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SignalsComponent } from './signal-list/signals.component';
import { SignalDetailComponent } from './signal-detail/signal-detail.component';
import { SignalsRoutingModule } from './signals-routing.module';
import { SharedModule } from '../../shared/shared.module';

@NgModule({
  declarations: [
    SignalsComponent,
    SignalDetailComponent,
  ],
  imports: [
    SignalsRoutingModule,
    CommonModule,
    SharedModule,
  ]
})
export class SignalsModule {
}
