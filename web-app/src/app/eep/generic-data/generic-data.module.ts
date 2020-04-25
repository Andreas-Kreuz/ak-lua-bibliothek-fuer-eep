import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { GenericDataComponent } from './generic-data/generic-data.component';
import { SharedModule } from '../../shared/shared.module';
import { GenericDataRoutingModule } from './generic-data-routing.module';
import { GenericDataOverviewComponent } from './generic-data-overview/generic-data-overview.component';

@NgModule({
  declarations: [
    GenericDataComponent,
    GenericDataOverviewComponent,
  ],
  imports: [
    GenericDataRoutingModule,
    CommonModule,
    SharedModule,
  ]
})
export class GenericDataModule {
}
