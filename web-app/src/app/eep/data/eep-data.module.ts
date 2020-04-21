import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from '../../shared/shared.module';
import { EepDataListComponent } from './data-list/eep-data-list.component';
import { EepDataRoutingModule } from './data-routing.module';

@NgModule({
  declarations: [
    EepDataListComponent,
  ],
  imports: [
    CommonModule,
    EepDataRoutingModule,
    SharedModule,
  ],
})
export class EepDataModule {
}
