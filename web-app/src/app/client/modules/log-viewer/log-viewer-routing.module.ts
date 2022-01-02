import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LogToolBarComponent } from './log-tool-bar/log-tool-bar.component';
import { LogViewerComponent } from './log-viewer/log-viewer.component';

const logViewerRoutes: Routes = [
  {
    path: '',
    component: LogViewerComponent,
    data: { title: 'Log-Datei' },
    pathMatch: 'full',
  },
  { path: '', outlet: 'main-toolbar-icons', component: LogToolBarComponent },
];

@NgModule({
  imports: [RouterModule.forChild(logViewerRoutes)],
  providers: [],
  exports: [RouterModule],
})
export class LogViewerRoutingModule {}
