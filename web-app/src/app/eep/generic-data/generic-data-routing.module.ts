import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { GenericDataComponent } from './generic-data/generic-data.component';
import { GenericDataOverviewComponent } from './generic-data-overview/generic-data-overview.component';

const genericDataRoutes: Routes = [
  {path: '', component: GenericDataOverviewComponent},
  {path: ':id', component: GenericDataComponent}
];

@NgModule({
  imports: [
    RouterModule.forChild(genericDataRoutes)
  ],
  exports: [
    RouterModule
  ]
})
export class GenericDataRoutingModule {
}
