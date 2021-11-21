import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatBadgeModule } from '@angular/material/badge';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatOptionModule } from '@angular/material/core';
import { MatDialogModule } from '@angular/material/dialog';
import { MatDividerModule } from '@angular/material/divider';
import { MatExpansionModule } from '@angular/material/expansion';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatGridListModule } from '@angular/material/grid-list';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatListModule } from '@angular/material/list';
import { MatMenuModule } from '@angular/material/menu';
import { MatPaginatorModule } from '@angular/material/paginator';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatRadioModule } from '@angular/material/radio';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatSortModule } from '@angular/material/sort';
import { MatTableModule } from '@angular/material/table';
import { MatTabsModule } from '@angular/material/tabs';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatTooltipModule } from '@angular/material/tooltip';
import { FilteredTableComponent } from './filtered-table/filtered-table.component';
import { DetailsDirective } from './details/details.directive';
import { OldDetailsDirective } from './details/old-details.directive';
import { TitledCardComponent } from './ui/titled-card/titled-card.component';
import { CardSampleComponent } from './ui/card-sample/card-sample.component';
import { TextSampleComponent } from './ui/text-sample/text-sample.component';
import { SharedRoutingModule } from './shared-routing.module';
import { DashboardSampleComponent } from './ui/dashboard-sample/dashboard-sample.component';
import { DashboardCardComponent } from './ui/dashboard-card/dashboard-card.component';
import { LayoutModule } from '@angular/cdk/layout';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { ConfigCardComponent } from './ui/config-card/config-card.component';
import { RoadStopComponent } from './ui/road-stop/road-stop.component';
import { RoadLineComponent } from './ui/road-line/road-line.component';
import { TagEditorComponent } from './ui/tag-editor/tag-editor.component';

@NgModule({
  declarations: [
    FilteredTableComponent,
    DetailsDirective,
    OldDetailsDirective,
    CardSampleComponent,
    TextSampleComponent,
    TitledCardComponent,
    DashboardCardComponent,
    DashboardSampleComponent,
    ConfigCardComponent,
    RoadStopComponent,
    RoadLineComponent,
    TagEditorComponent,
  ],
  exports: [
    CommonModule,
    ConfigCardComponent,
    FilteredTableComponent,
    MatBadgeModule,
    MatButtonModule,
    MatCardModule,
    MatCheckboxModule,
    MatDialogModule,
    MatDividerModule,
    MatFormFieldModule,
    MatGridListModule,
    MatIconModule,
    MatInputModule,
    MatListModule,
    MatMenuModule,
    MatOptionModule,
    MatPaginatorModule,
    MatProgressSpinnerModule,
    MatRadioModule,
    MatSlideToggleModule,
    MatSidenavModule,
    MatSortModule,
    MatTableModule,
    MatTabsModule,
    MatToolbarModule,
    MatTooltipModule,
    MatExpansionModule,
  ],
  imports: [
    SharedRoutingModule,
    CommonModule,
    MatBadgeModule,
    MatButtonModule,
    MatCardModule,
    MatCheckboxModule,
    MatDividerModule,
    MatFormFieldModule,
    MatGridListModule,
    MatIconModule,
    MatInputModule,
    MatListModule,
    MatMenuModule,
    MatPaginatorModule,
    MatProgressSpinnerModule,
    MatSidenavModule,
    MatSlideToggleModule,
    MatSortModule,
    MatTableModule,
    MatTooltipModule,
    MatToolbarModule,
    LayoutModule,
    MatProgressBarModule,
    MatExpansionModule,
  ],
})
export class SharedModule {}
