import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { StoreModule } from '@ngrx/store';
import { EffectsModule } from '@ngrx/effects';

import { TrainListComponent } from './train-list/train-list.component';
import { TrainsRoutingModule } from './trains-routing.module';
import { RollingStockTooltipComponent } from './icon-and-tooltip/rolling-stock-tooltip.component';
import { TrainListCardComponent } from './train-list-card/train-list-card.component';
import { TrainDetailsCardComponent } from './train-details-card/train-details-card.component';
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
    TrainListCardComponent,
    TrainDetailsCardComponent,
    RollingStockTooltipComponent,
    InfoRouteComponent,
    InfoSpeedComponent,
    InfoLengthComponent,
    InfoLineComponent,
    InfoDirectionComponent,
    InfoDestinationComponent,
    InfoCouplingComponent,
  ],
  imports: [
    TrainsRoutingModule,
    SharedModule,
    CommonModule,
    StoreModule.forFeature(trainFeature),
    EffectsModule.forFeature([TrainEffects]),
  ],
})
export class TrainsModule {}
