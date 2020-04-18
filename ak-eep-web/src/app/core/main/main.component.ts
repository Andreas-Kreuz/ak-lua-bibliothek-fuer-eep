import { ChangeDetectorRef, Component, EventEmitter, OnDestroy, OnInit, Output } from '@angular/core';
import { AppComponent } from '../../app.component';
import { select, Store } from '@ngrx/store';
import * as fromErrors from '../store/core.reducers';
import * as fromRoot from '../../app.reducers';
import { Observable } from 'rxjs';
import { Status } from '../server-status/status.enum';
import * as fromDataTypes from '../datatypes/store/data-types.reducers';
import { MediaMatcher } from '@angular/cdk/layout';
import { MainNavigationService } from '../home/main-navigation.service';
import { ActivatedRoute, NavigationEnd, Router } from '@angular/router';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit, OnDestroy {
  // links = ['Autos', 'Züge', 'Trams', 'Sonstige', 'Steuerung'];
  // activeLink = this.links[0];

  @Output() featureSelected = new EventEmitter<string>();
  title: string;
  private intersectionsAvailable$: Observable<boolean>;
  private readonly _mobileQueryListener: () => void;
  private connectionStatus$: Observable<Status>;
  navigation;
  mobileQuery: MediaQueryList;
  atHome: boolean;
  private parentUrl: string;

  constructor(appComponent: AppComponent,
              private store: Store<fromRoot.State>,
              changeDetectorRef: ChangeDetectorRef,
              private mainNavigation: MainNavigationService,
              media: MediaMatcher,
              private router: Router,
              private route: ActivatedRoute) {
    this.mobileQuery = media.matchMedia('(max-width: 600px)');
    this._mobileQueryListener = () => changeDetectorRef.detectChanges();
    this.mobileQuery.addListener(this._mobileQueryListener);
    this.title = appComponent.title;
    this.intersectionsAvailable$ = this.store.pipe(select(fromDataTypes.selectIntersectionsAvailable));

    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe(
      (event: NavigationEnd) => {
        this.parentUrl = '/' + event.urlAfterRedirects.substr(1, event.urlAfterRedirects.lastIndexOf('/') - 1);
        this.atHome = event.urlAfterRedirects === '/';
        console.log(this.parentUrl);
      }
    );
  }

  ngOnInit() {
    this.navigation = this.mainNavigation.navigation;
    this.connectionStatus$ = this.store.pipe(select(fromErrors.selectConnectionStatus));
  }

  ngOnDestroy(): void {
    this.mobileQuery.removeListener(this._mobileQueryListener);
  }

  navigateUp() {
    console.log(this.parentUrl);
    this.router.navigateByUrl(this.parentUrl);
  }
}
