import { StoreDevtoolsModule } from '@ngrx/store-devtools';
import { StoreRouterConnectingModule, DefaultRouterStateSerializer } from '@ngrx/router-store';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { StoreModule } from '@ngrx/store';
import { EffectsModule } from '@ngrx/effects';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HttpClientModule } from '@angular/common/http';
import { SharedModule } from './shared/shared.module';
import { FullPageLayoutComponent } from './layouts/full-page-layout.component';
import { ConnectingLayoutComponent } from './layouts/connecting-layout.component';
import { CoreModule } from './core/core.module';
import { reducers } from './app.reducers';
import { effects } from './app.effects';
import { environment } from '../environments/environment';
import { FormsModule } from '@angular/forms';
import { LayoutModule } from '@angular/cdk/layout';

@NgModule({
  declarations: [AppComponent, FullPageLayoutComponent, ConnectingLayoutComponent],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    HttpClientModule,
    FormsModule,
    SharedModule,
    CoreModule,
    LayoutModule,
    StoreModule.forRoot(reducers),
    EffectsModule.forRoot(effects),
    StoreRouterConnectingModule.forRoot({ serializer: DefaultRouterStateSerializer }),
    environment.production ? [] : StoreDevtoolsModule.instrument(),
    AppRoutingModule,
  ],
  exports: [],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
