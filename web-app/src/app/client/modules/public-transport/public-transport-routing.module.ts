import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LineComponent } from './line/line.component';
import { LinesComponent } from './lines/lines.component';
import { PublicTransportComponent } from './public-transport.component';
import { PublicTransportHomeComponent } from './public-transport-home/public-transport-home.component';
import { PublicTransportSettingsIconComponent } from './public-transport-settings-icon/public-transport-settings-icon.component';
import { StopComponent } from './stop/stop.component';
import { StopsComponent } from './stops/stops.component';

const routes: Routes = [
  {
    path: '',
    component: PublicTransportComponent,
    children: [
      { path: '', component: PublicTransportHomeComponent },
      { path: 'line', component: LineComponent },
      { path: 'lines', component: LinesComponent },
      { path: 'stop', component: StopComponent },
      { path: 'stops', component: StopsComponent },
    ],
  },
  { path: '', outlet: 'main-toolbar-icons', component: PublicTransportSettingsIconComponent },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class PublicTransportRoutingModule {}
