import { Component, OnDestroy, OnInit } from '@angular/core';
import { Observable, Subscription } from 'rxjs';
import { select, Store } from '@ngrx/store';
import * as fromCore from '../store/core.reducers';
import * as fromRoot from '../../app.reducers';
import { BreakpointObserver, Breakpoints, MediaMatcher } from '@angular/cdk/layout';
import { MainNavigationService } from './main-navigation.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
})
export class HomeComponent implements OnInit, OnDestroy {
  hostName$ = this.store.select(fromCore.getJsonServerUrl);
  eepLuaVersion$ = this.store.select(fromCore.selectEepLuaVersion);
  eepVersion$ = this.store.select(fromCore.selectEepVersion);
  eepWebVersion$ = this.store.select(fromCore.selectEepWebVersion);
  navigation = this.mainNavigation.navigation;
  mobileQuery: MediaQueryList;
  smallSub: Subscription;
  smallPortrait = true;
  handsetSub: Subscription;
  handsetPortrait = true;

  constructor(
    private store: Store<fromRoot.State>,
    private mainNavigation: MainNavigationService,
    media: MediaMatcher,
    bo: BreakpointObserver
  ) {
    this.mobileQuery = media.matchMedia('(max-width: 600px)');
    const portraitBreakpoints = [Breakpoints.HandsetPortrait, Breakpoints.TabletPortrait, Breakpoints.WebPortrait];
    this.smallPortrait = bo.isMatched(portraitBreakpoints);
    this.smallSub = bo.observe(portraitBreakpoints).subscribe((thingy) => {
      this.smallPortrait = thingy.matches;
    });

    const handsetBreakpoints = [Breakpoints.HandsetPortrait];
    this.handsetPortrait = bo.isMatched(handsetBreakpoints);
    this.handsetSub = bo.observe(handsetBreakpoints).subscribe((thingy) => {
      this.handsetPortrait = thingy.matches;
    });
  }

  ngOnInit() {}

  ngOnDestroy() {
    this.smallSub.unsubscribe();
    this.handsetSub.unsubscribe();
  }
}
