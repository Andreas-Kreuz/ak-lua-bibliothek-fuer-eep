import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LinesComponent } from './lines/lines.component';
import { PublicTransportHomeComponent } from './public-transport-home/public-transport-home.component';
import { PublicTransportComponent } from './public-transport.component';
import { StopsComponent } from './stops/stops.component';

const routes: Routes = [
  {
    path: '',
    component: PublicTransportComponent,
    children: [
      { path: '', component: PublicTransportHomeComponent },
      { path: 'lines', component: LinesComponent },
      { path: 'stops', component: StopsComponent },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class PublicTransportRoutingModule {}
