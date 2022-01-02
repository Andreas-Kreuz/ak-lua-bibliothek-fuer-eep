import { ChangeDetectorRef, Component, EventEmitter, OnDestroy, OnInit, Output } from '@angular/core';
import { AppComponent } from '../../app.component';
import { Store } from '@ngrx/store';
import * as fromRoot from '../../app.reducers';
import { MediaMatcher } from '@angular/cdk/layout';
import { MainNavigationService } from '../home/main-navigation.service';
import { ActivatedRoute, NavigationEnd, Router } from '@angular/router';
import { filter, map } from 'rxjs/operators';
import { Title } from '@angular/platform-browser';

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
    private activatedRoute: ActivatedRoute,
    private titleService: Title,
    media: MediaMatcher,
    private router: Router
  ) {
    this.mobileQuery = media.matchMedia('(max-width: 600px)');
    this.title = appComponent.title;
    this.navigation = mainNavigation.navigation;
    this.router.events.pipe(filter((event) => event instanceof NavigationEnd)).subscribe((event: NavigationEnd) => {
      this.updateUrlInfo();
    });
    this.router.events
      .pipe(
        filter((event) => event instanceof NavigationEnd),
        map(() => this.getTitleFromRouter())
      )
      .subscribe((data: any) => {
        if (data) {
          this.title = data || 'EEP-Web';
          this.titleService.setTitle(data ? data + ' - EEP-Web' : 'EEP-Web');
        }
      });
  }

  ngOnInit() {
    this.updateUrlInfo();
    const data = this.getTitleFromRouter();
    this.title = data || 'EEP-Web';
    this.titleService.setTitle(!data || data === 'EEP-Web' ? 'EEP-Web' : data + ' - EEP-Web');
  }

  ngOnDestroy(): void {}

  navigateUp() {
    this.router.navigateByUrl(this.parentUrl);
  }

  private updateUrlInfo() {
    this.atHome = this.router.url === '/';
    this.parentUrl = '/' + this.router.url.substr(1, this.router.url.lastIndexOf('/') - 1);
  }

  private getTitleFromRouter() {
    let child = this.activatedRoute.firstChild;
    while (child) {
      if (child.firstChild) {
        child = child.firstChild;
      } else if (child.snapshot.data && child.snapshot.data['title']) {
        return child.snapshot.data['title'];
      } else {
        return null;
      }
    }
    return null;
  }
}
