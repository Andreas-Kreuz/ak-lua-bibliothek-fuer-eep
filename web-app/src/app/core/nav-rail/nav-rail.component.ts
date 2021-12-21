import { Component, OnInit } from '@angular/core';
import { MainNavigationService } from '../home/main-navigation.service';
import NavigationInfo from '../store/navigation.model';

@Component({
  selector: 'app-nav-rail',
  templateUrl: './nav-rail.component.html',
  styleUrls: ['./nav-rail.component.scss'],
})
export class NavRailComponent implements OnInit {
  navigation: NavigationInfo[];
  constructor(mainNavigation: MainNavigationService) {
    this.navigation = mainNavigation.navigation;
  }

  ngOnInit(): void {}
}
