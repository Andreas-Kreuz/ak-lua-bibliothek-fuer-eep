import { NgModule } from '@angular/core';
import { MainComponent } from './main/main.component';
import { HomeComponent } from './home/home.component';
import { SharedModule } from '../shared/shared.module';
import { AppRoutingModule } from '../app-routing.module';
import { HttpClientModule } from '@angular/common/http';
import { HeaderToolBarComponent } from './header-tool-bar/header-tool-bar.component';
import { LayoutModule } from '@angular/cdk/layout';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatGridListModule } from '@angular/material/grid-list';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { RouterModule } from '@angular/router';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { CommonModule } from '@angular/common';
import { CardComponent } from './card/card.component';

@NgModule({
  declarations: [CardComponent, MainComponent, HomeComponent, HeaderToolBarComponent, CardComponent],
  imports: [
    RouterModule,
    HttpClientModule,
    AppRoutingModule,
    CommonModule,
    LayoutModule,
    MatGridListModule,
    MatCardModule,
    MatToolbarModule,
    MatMenuModule,
    MatIconModule,
    MatButtonModule,
    MatListModule,
    MatSidenavModule,
  ],
  exports: [CardComponent, AppRoutingModule, HomeComponent, MainComponent],
})
export class CoreModule {}
