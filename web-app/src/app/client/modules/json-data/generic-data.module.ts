import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { GenericDataComponent } from './generic-data/generic-data.component';
import { SharedModule } from '../../../shared/shared.module';
import { GenericDataRoutingModule } from './generic-data-routing.module';
import { GenericDataOverviewComponent } from './generic-data-overview/generic-data-overview.component';
import { genericDataFeature } from './store/generic-data.reducers';
import { GenericDataEffects } from './store/generic-data.effects';
import { StoreModule } from '@ngrx/store';
import { EffectsModule } from '@ngrx/effects';

@NgModule({
  declarations: [GenericDataComponent, GenericDataOverviewComponent],
  imports: [
    CommonModule,
    SharedModule,
    StoreModule.forFeature(genericDataFeature),
    EffectsModule.forFeature([GenericDataEffects]),
    GenericDataRoutingModule,
  ],
})
export class GenericDataModule {}
