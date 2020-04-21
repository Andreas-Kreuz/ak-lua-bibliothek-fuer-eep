import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { SignalsComponent } from './signal-list/signals.component';
import { SignalDetailComponent } from './signal-detail/signal-detail.component';

const signalRoutes: Routes = [
  {path: '', component: SignalsComponent, pathMatch: 'full'},
  {path: ':id', component: SignalDetailComponent}
];

@NgModule({
  imports: [
    RouterModule.forChild(signalRoutes)
  ],
  exports: [
    RouterModule
  ]
})
export class SignalsRoutingModule {
}
