import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PublicTransportRoutingModule } from './public-transport-routing.module';
import { PublicTransportComponent } from './public-transport.component';
import { MatCardModule } from '@angular/material/card';
import { MatDividerModule } from '@angular/material/divider';
import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import { StopsComponent } from './stops/stops.component';
import { LinesComponent } from './lines/lines.component';
import { PublicTransportHomeComponent } from './public-transport-home/public-transport-home.component';
import { PublicTransportService } from './store/public-transport.service';
import { EffectsModule } from '@ngrx/effects';
import { StoreModule } from '@ngrx/store';
import { PublicTransportEffects } from './store/public-transport.effects';
import { publicTransportFeature } from './store/public-transport.reducer';
import { SharedModule } from '../../../shared/shared.module';

@NgModule({
  providers: [PublicTransportService],
  declarations: [LinesComponent, PublicTransportComponent, PublicTransportHomeComponent, StopsComponent],
  imports: [
    CommonModule,
    SharedModule,
    MatButtonModule,
    MatCardModule,
    MatDividerModule,
    MatListModule,
    StoreModule.forFeature(publicTransportFeature),
    EffectsModule.forFeature([PublicTransportEffects]),
    PublicTransportRoutingModule,
  ],
})
export class PublicTransportModule {}
