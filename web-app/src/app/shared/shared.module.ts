import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatBadgeModule } from '@angular/material/badge';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatDialogModule } from '@angular/material/dialog';
import { MatDividerModule } from '@angular/material/divider';
import { MatExpansionModule } from '@angular/material/expansion';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatGridListModule } from '@angular/material/grid-list';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatListModule } from '@angular/material/list';
import { MatMenuModule } from '@angular/material/menu';
import { MatOptionModule } from '@angular/material/core';
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
import { MatChipsModule } from '@angular/material/chips';
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
import { SettingsDialogComponent } from './ui/settings-dialog/settings-dialog.component';
import { SettingsIconComponent } from './ui/settings-icon/settings-icon.component';
import { SettingsPanelComponent } from './ui/settings-panel/settings-panel.component';
import { SvgDisplayComponent } from './ui/svg-display/svg-display.component';

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
    SettingsDialogComponent,
    SettingsIconComponent,
    SettingsPanelComponent,
    SvgDisplayComponent,
  ],
  exports: [
    CommonModule,
    ConfigCardComponent,
    FilteredTableComponent,
    MatBadgeModule,
    MatButtonModule,
    MatCardModule,
    MatCheckboxModule,
    MatChipsModule,
    MatDialogModule,
    MatDividerModule,
    MatExpansionModule,
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
    MatSidenavModule,
    MatSlideToggleModule,
    MatSortModule,
    MatTableModule,
    MatTabsModule,
    MatToolbarModule,
    MatTooltipModule,
    SettingsIconComponent,
  ],
  imports: [
    CommonModule,
    LayoutModule,
    MatBadgeModule,
    MatButtonModule,
    MatCardModule,
    MatCheckboxModule,
    MatChipsModule,
    MatDialogModule,
    MatDividerModule,
    MatExpansionModule,
    MatFormFieldModule,
    MatGridListModule,
    MatIconModule,
    MatInputModule,
    MatListModule,
    MatMenuModule,
    MatPaginatorModule,
    MatProgressBarModule,
    MatProgressSpinnerModule,
    MatSidenavModule,
    MatSlideToggleModule,
    MatSortModule,
    MatTableModule,
    MatToolbarModule,
    MatTooltipModule,
    SharedRoutingModule,
  ],
})
export class SharedModule {}
