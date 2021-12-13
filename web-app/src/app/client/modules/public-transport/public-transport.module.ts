import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatDividerModule } from '@angular/material/divider';
import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import { EffectsModule } from '@ngrx/effects';
import { StoreModule } from '@ngrx/store';
import { PublicTransportEffects } from './store/public-transport.effects';
import { publicTransportFeature } from './store/public-transport.reducer';
import { MatDialogModule } from '@angular/material/dialog';

import { SharedModule } from '../../../shared/shared.module';
import { LineComponent } from './line/line.component';
import { LinesComponent } from './lines/lines.component';
import { PublicTransportComponent } from './public-transport.component';
import { PublicTransportHomeComponent } from './public-transport-home/public-transport-home.component';
import { PublicTransportRoutingModule } from './public-transport-routing.module';
import { PublicTransportService } from './store/public-transport.service';
import { PublicTransportSettingsIconComponent } from './public-transport-settings-icon/public-transport-settings-icon.component';
import { StopComponent } from './stop/stop.component';
import { StopsComponent } from './stops/stops.component';
import { HttpClientModule } from '@angular/common/http';

@NgModule({
  providers: [PublicTransportService],
  declarations: [
    LineComponent,
    LinesComponent,
    PublicTransportComponent,
    PublicTransportHomeComponent,
    PublicTransportSettingsIconComponent,
    StopComponent,
    StopsComponent,
  ],
  imports: [
    CommonModule,
    SharedModule,
    MatButtonModule,
    MatCardModule,
    MatDialogModule,
    MatDividerModule,
    MatListModule,
    StoreModule.forFeature(publicTransportFeature),
    EffectsModule.forFeature([PublicTransportEffects]),
    PublicTransportRoutingModule,
  ],
})
export class PublicTransportModule {}
