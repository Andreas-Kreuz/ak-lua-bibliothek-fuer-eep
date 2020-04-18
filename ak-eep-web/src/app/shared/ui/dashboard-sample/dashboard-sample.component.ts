import { Component, OnInit } from '@angular/core';
import { MainNavigationService } from '../../../core/home/main-navigation.service';
import { of } from 'rxjs';

@Component({
  selector: 'app-dashboard-sample',
  templateUrl: './dashboard-sample.component.html',
  styleUrls: ['./dashboard-sample.component.css']
})
export class DashboardSampleComponent implements OnInit {
  connectionEstablished$ = of(true);
  navigation = this.mainNavigation.navigation;

  constructor(
    private mainNavigation: MainNavigationService) {
  }

  ngOnInit() {
  }

}
