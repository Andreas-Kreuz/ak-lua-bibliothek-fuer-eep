import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TextSampleComponent } from './ui/text-sample/text-sample.component';
import { CardSampleComponent } from './ui/card-sample/card-sample.component';
import { TitledCardComponent } from './ui/titled-card/titled-card.component';
import { DashboardSampleComponent } from './ui/dashboard-sample/dashboard-sample.component';
import { ConfigCardComponent } from './ui/config-card/config-card.component';
import { RoadLineComponent } from './ui/road-line/road-line.component';
import { RoadStopComponent } from './ui/road-stop/road-stop.component';
import { TagEditorComponent } from './ui/tag-editor/tag-editor.component';
import { SvgDisplayComponent } from './ui/svg-display/svg-display.component';
import { DashboardCardComponent } from './ui/dashboard-card/dashboard-card.component';

const sharedRoutes: Routes = [
  { path: 'text', component: TextSampleComponent },
  { path: 'cards', component: CardSampleComponent },
  { path: 'card-titled', component: TitledCardComponent },
  { path: 'card-dashboard', component: TitledCardComponent },
  { path: 'dashboard-card', component: DashboardCardComponent },
  { path: 'dashboard', component: DashboardSampleComponent },
  { path: 'settings', component: ConfigCardComponent },
  { path: 'tag', component: TagEditorComponent },
  { path: 'line', component: RoadLineComponent },
  { path: 'stop', component: RoadStopComponent },
  { path: 'svg', component: SvgDisplayComponent },
];

@NgModule({
  imports: [RouterModule.forChild(sharedRoutes)],
  exports: [RouterModule],
})
export class SharedRoutingModule {}
