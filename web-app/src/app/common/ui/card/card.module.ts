import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CardComponent } from './card/card.component';
import { MatCardModule } from '@angular/material/card';
import { RouterModule } from '@angular/router';

@NgModule({
  declarations: [CardComponent],
  imports: [CommonModule, RouterModule, MatCardModule],
  exports: [CardComponent],
})
export class CardModule {}
