import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EffectsModule } from '@ngrx/effects';

import { SharedModule } from '../../shared/shared.module';
import { IntersectionComponent } from './intersection-detail/intersection.component';
import { IntersectionSwitchingComponent } from './intersection-switching/intersection-switching.component';
import { IntersectionsComponent } from './intersection-list/intersections.component';
import { IntersectionRoutingModule } from './intersection-routing.module';
import { IntersectionEffects } from './store/intersection.effects';
import { CamHelpDialogComponent } from '../cam/cam-help-dialog/cam-help-dialog.component';
import { LaneOverviewComponent } from './lane-overview/lane-overview.component';
import { LaneQueueComponent } from './lane-queue/lane-queue.component';

@NgModule({
  declarations: [
    IntersectionComponent,
    IntersectionSwitchingComponent,
    IntersectionsComponent,
    CamHelpDialogComponent,
    LaneOverviewComponent,
    LaneQueueComponent,
  ],
  entryComponents: [
    CamHelpDialogComponent,
  ],
  imports: [
    CommonModule,
    IntersectionRoutingModule,
    SharedModule,
    // StoreModule.forFeature('intersection', fromIntersection.reducer),
    EffectsModule.forFeature([IntersectionEffects]),
  ],
})
export class IntersectionModule {
}
