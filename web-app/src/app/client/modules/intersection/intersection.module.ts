import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EffectsModule } from '@ngrx/effects';

import { SharedModule } from '../../../shared/shared.module';
import { IntersectionComponent } from './intersection-detail/intersection.component';
import { IntersectionSwitchingComponent } from './intersection-switching/intersection-switching.component';
import { IntersectionsComponent } from './intersection-list/intersections.component';
import { IntersectionRoutingModule } from './intersection-routing.module';
import { intersectionFeature } from './store/intersection.reducers';
import { IntersectionEffects } from './store/intersection.effects';
import { CamHelpDialogComponent } from './cam-help-dialog/cam-help-dialog.component';
import { LaneOverviewComponent } from './lane-overview/lane-overview.component';
import { LaneQueueComponent } from './lane-queue/lane-queue.component';
import { StoreModule } from '@ngrx/store';
import { signalFeature } from '../signals/store/signal.reducers';
import { SignalEffects } from '../signals/store/signal.effects';
import { SignalsService } from '../signals/store/signals.service';
import { IntersectionSettingsIconComponent } from './intersection-settings-icon/intersection-settings-icon.component';
import { IntersectionDetailsCardComponent } from './intersection-details-card/intersection-details-card.component';
import { CardModule } from '../../../common/ui/card/card.module';
import { IntersectionLaneDisplayComponent } from './intersection-lane-display/intersection-lane-display.component';

@NgModule({
  providers: [SignalsService],
  declarations: [
    IntersectionComponent,
    IntersectionSwitchingComponent,
    IntersectionsComponent,
    CamHelpDialogComponent,
    LaneOverviewComponent,
    LaneQueueComponent,
    IntersectionSettingsIconComponent,
    IntersectionDetailsCardComponent,
    IntersectionLaneDisplayComponent,
  ],
  imports: [
    CardModule,
    CommonModule,
    IntersectionRoutingModule,
    SharedModule,
    StoreModule.forFeature(intersectionFeature),
    EffectsModule.forFeature([IntersectionEffects]),
    StoreModule.forFeature(signalFeature),
    EffectsModule.forFeature([SignalEffects]),
  ],
})
export class IntersectionModule {}
