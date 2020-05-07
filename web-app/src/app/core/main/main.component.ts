import { ChangeDetectorRef, Component, EventEmitter, OnDestroy, OnInit, Output } from '@angular/core';
import { AppComponent } from '../../app.component';
import { Store } from '@ngrx/store';
import * as fromRoot from '../../app.reducers';
import { MediaMatcher } from '@angular/cdk/layout';
import { MainNavigationService } from '../home/main-navigation.service';
import { ActivatedRoute, NavigationEnd, Router } from '@angular/router';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss'],
})
export class MainComponent implements OnInit, OnDestroy {
  @Output() featureSelected = new EventEmitter<string>();
  title: string;
  navigation;
  mobileQuery: MediaQueryList;
  atHome = true;
  private parentUrl: string;

  constructor(
    appComponent: AppComponent,
    private store: Store<fromRoot.State>,
    changeDetectorRef: ChangeDetectorRef,
    mainNavigation: MainNavigationService,
    media: MediaMatcher,
    private router: Router
  ) {
    this.mobileQuery = media.matchMedia('(max-width: 600px)');
    this.title = appComponent.title;
    this.navigation = mainNavigation.navigation;
    this.router.events.pipe(filter((event) => event instanceof NavigationEnd)).subscribe((event: NavigationEnd) => {
      this.updateUrlInfo();
    });
  }

  ngOnInit() {
    this.updateUrlInfo();
  }

  ngOnDestroy(): void {}

  private updateUrlInfo() {
    this.atHome = this.router.url === '/';
    this.parentUrl = '/' + this.router.url.substr(1, this.router.url.lastIndexOf('/') - 1);
  }

  navigateUp() {
    this.router.navigateByUrl(this.parentUrl);
  }
}
