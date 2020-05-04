import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ServerStatusComponent } from './server-status/server-status.component';
import { ServerRoutingModule } from './server-routing.module';

@NgModule({
  declarations: [ServerStatusComponent],
  imports: [CommonModule, ServerRoutingModule],
})
export class ServerModule {}
