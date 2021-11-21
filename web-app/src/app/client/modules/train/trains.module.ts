import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { StoreModule } from '@ngrx/store';
import { EffectsModule } from '@ngrx/effects';

import { TrainListComponent } from './train-list/train-list.component';
import { TrainsRoutingModule } from './trains-routing.module';
import { RollingStockTooltipComponent } from './icon-and-tooltip/rolling-stock-tooltip.component';
import { TrainCardComponent } from './train-card/train-card.component';
import { InfoRouteComponent } from './info-route/info-route.component';
import { InfoSpeedComponent } from './info-speed/info-speed.component';
import { InfoLengthComponent } from './info-length/info-length.component';
import { InfoLineComponent } from './info-line/info-line.component';
import { InfoDirectionComponent } from './info-direction/info-direction.component';
import { InfoDestinationComponent } from './info-destination/info-destination.component';
import { InfoCouplingComponent } from './info-coupling/info-coupling.component';
import { SharedModule } from '../../../shared/shared.module';
import { trainFeature } from './store/train.reducer';
import { TrainEffects } from './store/train.effects';
import { TrainService } from './store/train.service';

@NgModule({
  providers: [TrainService],
  declarations: [
    TrainListComponent,
    RollingStockTooltipComponent,
    TrainCardComponent,
    InfoRouteComponent,
    InfoSpeedComponent,
    InfoLengthComponent,
    InfoLineComponent,
    InfoDirectionComponent,
    InfoDestinationComponent,
    InfoCouplingComponent,
  ],
  entryComponents: [],
  imports: [
    SharedModule,
    TrainsRoutingModule,
    CommonModule,
    StoreModule.forFeature(trainFeature),
    EffectsModule.forFeature([TrainEffects]),
  ],
})
export class TrainsModule {}