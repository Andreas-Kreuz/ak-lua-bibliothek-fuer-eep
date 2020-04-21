import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
//import { NgxAutoScrollModule } from 'ngx-auto-scroll';
import { LogTextFieldComponent } from './log-text-field/log-text-field.component';
import { LogViewerRoutingModule } from './log-viewer-routing.module';
import { EffectsModule } from '@ngrx/effects';
import { StoreModule } from '@ngrx/store';
import { LogFileEffects } from './store/log-file.effects';
import * as fromLogViewer from './store/log-file.reducers';
import { SharedModule } from '../../shared/shared.module';
import { LogToolBarComponent } from './log-tool-bar/log-tool-bar.component';
import { LogViewerComponent } from './log-viewer/log-viewer.component';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatGridListModule } from '@angular/material/grid-list';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { LayoutModule } from '@angular/cdk/layout';

@NgModule({
  declarations: [
    LogTextFieldComponent,
    LogToolBarComponent,
    LogViewerComponent,
  ],
  imports: [
    SharedModule,
    LogViewerRoutingModule,
    CommonModule,
    // NgxAutoScrollModule,
    StoreModule.forFeature('logViewer', fromLogViewer.reducer),
    EffectsModule.forFeature([LogFileEffects]),
    MatGridListModule,
    MatCardModule,
    MatMenuModule,
    MatIconModule,
    MatButtonModule,
    LayoutModule,
  ]
})

export class LogViewerModule {
}
