import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { IntersectionsComponent } from './intersection-list/intersections.component';
import { IntersectionComponent } from './intersection-detail/intersection.component';
import { IntersectionSettingsIconComponent } from './intersection-settings-icon/intersection-settings-icon.component';

const intersectionRoutes: Routes = [
  { path: '', component: IntersectionsComponent, pathMatch: 'full' },
  { path: ':id', component: IntersectionComponent, pathMatch: 'full' },
  { path: '', outlet: 'main-toolbar-icons', component: IntersectionSettingsIconComponent },
];

@NgModule({
  imports: [RouterModule.forChild(intersectionRoutes)],
  exports: [RouterModule],
})
export class IntersectionRoutingModule {}
