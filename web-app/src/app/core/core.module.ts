import { NgModule } from '@angular/core';
import { MainComponent } from './main/main.component';
import { HomeComponent } from './home/home.component';
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
import { NavRailComponent } from './nav-rail/nav-rail.component';
import { MatRippleModule } from '@angular/material/core';
import { MatChipsModule } from '@angular/material/chips';
import { CardModule } from '../common/ui/card/card.module';

@NgModule({
  declarations: [MainComponent, HomeComponent, HeaderToolBarComponent, NavRailComponent],
  imports: [
    CommonModule,
    RouterModule,
    HttpClientModule,
    AppRoutingModule,
    CardModule,
    MatChipsModule,
    MatRippleModule,
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
  exports: [AppRoutingModule, HomeComponent, MainComponent],
})
export class CoreModule {}
