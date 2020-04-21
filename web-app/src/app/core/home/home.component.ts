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
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  private hostName$: Observable<string>;
  connectionEstablished$: Observable<boolean>;
  eepLuaVersion$: Observable<string>;
  eepVersion$: Observable<string>;
  eepWebVersion$: Observable<string>;
  navigation;
  private mobileQuery: MediaQueryList;

  constructor(private store: Store<fromRoot.State>,
              private breakpointObserver: BreakpointObserver,
              private mainNavigation: MainNavigationService,
              media: MediaMatcher) {
    this.mobileQuery = media.matchMedia('(max-width: 600px)');
  }

  ngOnInit() {
    this.hostName$ = this.store.pipe(select(fromCore.getJsonServerUrl));
    this.eepLuaVersion$ = this.store.pipe(select(fromCore.selectEepLuaVersion));
    this.eepVersion$ = this.store.pipe(select(fromCore.selectEepVersion));
    this.eepWebVersion$ = this.store.pipe(select(fromCore.selectEepWebVersion));
    this.connectionEstablished$ = this.store.pipe(select(fromCore.getConnectionEstablished));
    this.navigation = this.mainNavigation.navigation;
  }
}
