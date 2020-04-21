import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { EepDataListComponent } from './data-list/eep-data-list.component';

const eepDataRoutes: Routes = [
  {path: '', component: EepDataListComponent},
];

@NgModule({
  imports: [
    RouterModule.forChild(eepDataRoutes)
  ],
  exports: [
    RouterModule
  ]
})
export class EepDataRoutingModule {
}
