import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { MatButtonModule } from '@angular/material/button';
import { MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule, MatLabel } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatToolbarModule } from '@angular/material/toolbar';
import { ServerRoutingModule } from './server-routing.module';
import { ServerStatusComponent } from './server-status/server-status.component';
import { EepDirDialogComponent } from './server-status/eep-dir-dialog.component';
import { FormsModule } from '@angular/forms';
import { MatCardModule } from '@angular/material/card';
import { EffectsModule } from '@ngrx/effects';
import { ServerEffects } from './store/server.effects';
import * as fromServer from './store/server.reducer';
import { StoreModule } from '@ngrx/store';

@NgModule({
  declarations: [ServerStatusComponent, EepDirDialogComponent],
  imports: [
    FormsModule,
    CommonModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatCardModule,
    MatDialogModule,
    MatToolbarModule,
    ServerRoutingModule,
    EffectsModule.forFeature([ServerEffects]),
    StoreModule.forFeature(fromServer.FEATURE_KEY, fromServer.reducer),
  ],
})
export class ServerModule {}
