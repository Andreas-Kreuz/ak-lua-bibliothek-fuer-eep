import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PublicTransportRoutingModule } from './public-transport-routing.module';
import { PublicTransportComponent } from './public-transport.component';
import { MatCardModule } from '@angular/material/card';
import { MatDividerModule } from '@angular/material/divider';
import { MatListModule } from '@angular/material/list';

@NgModule({
  declarations: [PublicTransportComponent],
  imports: [CommonModule, MatCardModule, MatDividerModule, MatListModule, PublicTransportRoutingModule],
})
export class PublicTransportModule {}
