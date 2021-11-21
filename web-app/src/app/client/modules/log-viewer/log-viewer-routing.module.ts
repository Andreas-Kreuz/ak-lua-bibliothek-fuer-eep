import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LogViewerComponent } from './log-viewer/log-viewer.component';

const logViewerRoutes: Routes = [
  {
    path: '',
    component: LogViewerComponent,
    data: { title: 'Log-Datei' },
    pathMatch: 'full',
  },
];

@NgModule({
  imports: [RouterModule.forChild(logViewerRoutes)],
  providers: [],
  exports: [RouterModule],
})
export class LogViewerRoutingModule {}
