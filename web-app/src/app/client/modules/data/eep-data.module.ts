import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from '../../../shared/shared.module';
import { EepDataListComponent } from './data-list/eep-data-list.component';
import { EepDataRoutingModule } from './data-routing.module';
import { EepDataService } from './store/eep-data.service';
import { StoreModule } from '@ngrx/store';
import { eepDataFeature } from './store/eep-data.reducers';
import { EepDataEffects } from './store/eep-data.effects';
import { EffectsModule } from '@ngrx/effects';

@NgModule({
  providers: [EepDataService],
  declarations: [EepDataListComponent],
  imports: [
    CommonModule,
    SharedModule,
    StoreModule.forFeature(eepDataFeature),
    EffectsModule.forFeature([EepDataEffects]),
    EepDataRoutingModule,
  ],
})
export class EepDataModule {}
