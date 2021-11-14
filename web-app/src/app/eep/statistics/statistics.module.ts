import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { StatisticsRoutingModule } from './statistics-routing.module';
import { StatisticsComponent } from './statistics.component';
import { MatCardModule } from '@angular/material/card';
import { MatDividerModule } from '@angular/material/divider';
import { StatisticsEffects } from './store/statistics.effects';
import { EffectsModule } from '@ngrx/effects';
import { StatisticsCardComponent } from './statistics-card/statistics-card.component';

@NgModule({
  declarations: [StatisticsComponent, StatisticsCardComponent],
  imports: [
    CommonModule,
    StatisticsRoutingModule,
    MatCardModule,
    MatDividerModule,
    EffectsModule.forFeature([StatisticsEffects]),
  ],
})
export class StatisticsModule {}
