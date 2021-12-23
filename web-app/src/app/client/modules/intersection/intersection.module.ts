import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { EffectsModule } from '@ngrx/effects';
import { StoreModule } from '@ngrx/store';
import { CardModule } from '../../../common/ui/card/card.module';
import { SharedModule } from '../../../shared/shared.module';
import { SignalEffects } from '../signals/store/signal.effects';
import { signalFeature } from '../signals/store/signal.reducers';
import { SignalsService } from '../signals/store/signals.service';
import { CamHelpDialogComponent } from './cam-help-dialog/cam-help-dialog.component';
import { IntersectionComponent } from './intersection-detail/intersection.component';
import { IntersectionDetailsCardComponent } from './intersection-details-card/intersection-details-card.component';
import { IntersectionLaneDisplayComponent } from './intersection-lane-display/intersection-lane-display.component';
import { IntersectionsComponent } from './intersection-list/intersections.component';
import { IntersectionRoutingModule } from './intersection-routing.module';
import { IntersectionSettingsIconComponent } from './intersection-settings-icon/intersection-settings-icon.component';
import { IntersectionSwitchingComponent } from './intersection-switching/intersection-switching.component';
import { LaneOverviewComponent } from './lane-overview/lane-overview.component';
import { LaneQueueComponent } from './lane-queue/lane-queue.component';
import { IntersectionEffects } from './store/intersection.effects';
import { intersectionFeature } from './store/intersection.reducers';

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
