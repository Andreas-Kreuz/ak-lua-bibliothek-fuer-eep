import { NgModule } from '@angular/core';
import { MainComponent } from './main/main.component';
import { HomeComponent } from './home/home.component';
import { SharedModule } from '../shared/shared.module';
import { AppRoutingModule } from '../app-routing.module';
import { ErrorComponent } from './error/error.component';
import { ServerStatusComponent } from './server-status/server-status.component';
import { HttpClientModule } from '@angular/common/http';
import { HeaderToolBarComponent } from './header-tool-bar/header-tool-bar.component';
import { LayoutModule } from '@angular/cdk/layout';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatGridListModule } from '@angular/material/grid-list';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';

@NgModule({
  declarations: [
    ErrorComponent,
    MainComponent,
    HomeComponent,
    ServerStatusComponent,
    HeaderToolBarComponent,
  ],
  imports: [
    SharedModule,
    HttpClientModule,
    AppRoutingModule,
    LayoutModule,
    MatGridListModule,
    MatCardModule,
    MatMenuModule,
    MatIconModule,
    MatButtonModule,
  ],
  exports: [
    AppRoutingModule,
    ErrorComponent,
    HomeComponent,
    MainComponent,
  ]
})
export class CoreModule {
}
