import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PublicTransportRoutingModule } from './public-transport-routing.module';
import { PublicTransportComponent } from './public-transport.component';


@NgModule({
  declarations: [
    PublicTransportComponent
  ],
  imports: [
    CommonModule,
    PublicTransportRoutingModule
  ]
})
export class PublicTransportModule { }
