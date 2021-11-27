import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { select, Store } from '@ngrx/store';
import * as fromCore from '../store/core.reducers';
import * as fromRoot from '../../app.reducers';
import { BreakpointObserver, MediaMatcher } from '@angular/cdk/layout';
import { MainNavigationService } from './main-navigation.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
})
export class HomeComponent implements OnInit {
  hostName$ = this.store.select(fromCore.getJsonServerUrl);
  eepLuaVersion$ = this.store.select(fromCore.selectEepLuaVersion);
  eepVersion$ = this.store.select(fromCore.selectEepVersion);
  eepWebVersion$ = this.store.select(fromCore.selectEepWebVersion);
  navigation = this.mainNavigation.navigation;
  private mobileQuery: MediaQueryList;

  constructor(
    private store: Store<fromRoot.State>,
    private mainNavigation: MainNavigationService,
    media: MediaMatcher
  ) {
    this.mobileQuery = media.matchMedia('(max-width: 600px)');
  }

  ngOnInit() {}
}
