import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { StatisticsRoutingModule } from './statistics-routing.module';
import { StatisticsComponent } from './statistics.component';
import { MatCardModule } from '@angular/material/card';
import { MatDividerModule } from '@angular/material/divider';
import { StatisticsEffects } from './store/statistics.effects';
import { statisticsFeature } from './store/statistics.reducer';
import { EffectsModule } from '@ngrx/effects';
import { StatisticsCardComponent } from './statistics-card/statistics-card.component';
import { StoreModule } from '@ngrx/store';

@NgModule({
  declarations: [StatisticsComponent, StatisticsCardComponent],
  imports: [
    CommonModule,
    StatisticsRoutingModule,
    MatCardModule,
    MatDividerModule,
    StoreModule.forFeature(statisticsFeature),
    EffectsModule.forFeature([StatisticsEffects]),
  ],
})
export class StatisticsModule {}
