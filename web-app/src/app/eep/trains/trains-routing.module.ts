import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { TrainListComponent } from './train-list/train-list.component';

const trainRoutes: Routes = [
  {path: '', redirectTo: '/', pathMatch: 'full'},
  {path: ':trainType', component: TrainListComponent}
];

@NgModule({
  imports: [
    RouterModule.forChild(trainRoutes)
  ],
  exports: [
    RouterModule
  ]
})
export class TrainsRoutingModule {
}
