import { Component, OnInit } from '@angular/core';
import { MainNavigationService } from '../../../core/home/main-navigation.service';
import { of } from 'rxjs';

@Component({
  selector: 'app-dashboard-sample',
  templateUrl: './dashboard-sample.component.html',
  styleUrls: ['./dashboard-sample.component.css'],
})
export class DashboardSampleComponent implements OnInit {
  eepVersion$ = of('17.0.1');
  eepLuaVersion$ = of('3.4');
  eepWebVersion$ = of('0.9');
  hostName$ = of('somehost');
  connectionEstablished$ = of(true);
  navigation = this.mainNavigation.navigation;

  constructor(private mainNavigation: MainNavigationService) {}

  ngOnInit() {}
}
