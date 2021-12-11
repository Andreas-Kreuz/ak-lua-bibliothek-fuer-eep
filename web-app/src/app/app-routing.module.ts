import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomeComponent } from './core/home/home.component';
import { ConnectingLayoutComponent } from './layouts/connecting-layout.component';
import { MainComponent } from './core/main/main.component';

const routes: Routes = [
  {
    path: '',
    pathMatch: 'prefix',
    component: ConnectingLayoutComponent,
    children: [
      {
        path: '',
        pathMatch: 'prefix',
        component: MainComponent,
        // These Children do all have the main menu bar
        children: [
          { path: '', component: HomeComponent, pathMatch: 'full' },
          {
            path: 'signals',
            loadChildren: () => import('./client/modules/signals/signals.module').then((m) => m.SignalsModule),
          },
          {
            path: 'trains',
            loadChildren: () => import('./client/modules/train/trains.module').then((m) => m.TrainsModule),
          },
          {
            path: 'intersections',
            loadChildren: () =>
              import('./client/modules/intersection/intersection.module').then((m) => m.IntersectionModule),
          },
          {
            path: 'data',
            loadChildren: () => import('./client/modules/data/eep-data.module').then((m) => m.EepDataModule),
          },
          {
            path: 'generic-data',
            loadChildren: () =>
              import('./client/modules/json-data/generic-data.module').then((m) => m.GenericDataModule),
          },
          {
            path: 'log',
            loadChildren: () => import('./client/modules/log-viewer/log-viewer.module').then((m) => m.LogViewerModule),
            data: { title: 'Log-Datei' },
          },
          {
            path: 'ui',
            loadChildren: () => import('./shared/shared.module').then((m) => m.SharedModule),
          },
          {
            path: 'statistics',
            loadChildren: () => import('./client/modules/statistics/statistics.module').then((m) => m.StatisticsModule),
          },
          {
            path: 'public-transport',
            loadChildren: () =>
              import('./client/modules/public-transport/public-transport.module').then((m) => m.PublicTransportModule),
          },
        ],
      },
      {
        path: 'server',
        loadChildren: () => import('./server/server.module').then((m) => m.ServerModule),
      },
    ],
  },
  { path: '**', redirectTo: '' },
  // { path: '**', redirectTo: '/' }, // Must be the last route!
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes, {
      relativeLinkResolution: 'legacy',
    }),
  ],
  exports: [RouterModule],
})
export class AppRoutingModule {}
