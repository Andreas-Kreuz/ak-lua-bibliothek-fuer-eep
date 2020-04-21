import { Component, ComponentFactoryResolver, Input, OnDestroy, OnInit, Type, ViewChild } from '@angular/core';
import { MatSort } from '@angular/material/sort';
import { TableDataSource } from './table-datasource';
import { Observable, Subject } from 'rxjs';
import { animate, state, style, transition, trigger } from '@angular/animations';
import { DetailsComponent } from '../details/details.component';
import { DetailsDirective } from '../details/details.directive';
import { OldDetailsDirective } from '../details/old-details.directive';
import { DetailsItem } from '../details/details-item';

@Component({
  selector: 'app-filtered-table',
  templateUrl: './filtered-table.component.html',
  styleUrls: ['./filtered-table.component.css'],
  animations: [
    trigger('detailExpand', [
      state('collapsed, void', style({height: '0px', minHeight: '0', display: 'none'})),
      state('expanded', style({height: '*'})),
      transition('expanded <=> collapsed', animate('1ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
      transition('expanded <=> void', animate('1ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    ]),
  ],
})
export class FilteredTableComponent<T> implements OnInit, OnDestroy {
  @ViewChild(DetailsDirective) detailHost: DetailsDirective;
  @ViewChild(OldDetailsDirective) oldDetailHost: OldDetailsDirective;
  @ViewChild(MatSort, {static: true}) sort: MatSort;
  @Input() public columnsToDisplay: string[];
  @Input() public columnNames: string[];
  @Input() public columnAlignment?: string[];
  @Input() public columnTextFunctions?: (T) => string;

  @Input()
  set detailsComponent(detailsComponent: DetailsComponent<T>) {
    this.detailsItem = new DetailsItem<T>(<Type<any>><unknown>detailsComponent, null);
    this.oldDetailsItem = new DetailsItem<T>(<Type<any>><unknown>detailsComponent, null);
  }

  @Input() set tableData(data$: Observable<T[]>) {
    this.data$ = data$;
  }

  private detailsItem: DetailsItem<T>;
  private oldDetailsItem: DetailsItem<T>;
  private filter = new Subject<string>();
  dataSource: TableDataSource<T>;
  filteredRows$: Observable<T[]>;
  data$: Observable<T[]>;
  expandedElement: T | null;
  oldExpandedElement: T | null;

  constructor(private componentFactoryResolver: ComponentFactoryResolver) {
  }

  ngOnInit() {
    this.dataSource = new TableDataSource(this.data$,
      this.filter.asObservable(),
      this.sort,
      this.columnsToDisplay,
      this.columnTextFunctions);
    this.filteredRows$ = this.dataSource.connect();
  }

  ngOnDestroy(): void {
    this.dataSource.disconnect();
  }


  applyFilter(filterValue: string) {
    this.filter.next(filterValue.trim().toLowerCase());
  }

  textFor(element: T, column: string) {
    const value = this.columnTextFunctions && this.columnTextFunctions[column]
      ? this.columnTextFunctions[column](element)
      : element[column];

    return value;
  }

  getAlignment(column: string) {
    return column && this.columnAlignment && this.columnAlignment[column]
      ? this.columnAlignment[column]
      : 'left';
  }

  onExpandedElement(element) {
    this.oldExpandedElement = this.expandedElement;
    this.expandedElement = this.expandedElement === element ? null : element;
  }

  setExpandedElement() {
    if (this.expandedElement && this.detailsItem) {
      const componentFactory = this.componentFactoryResolver.resolveComponentFactory(this.detailsItem.component);
      const viewContainerRef = this.detailHost.viewContainerRef;
      viewContainerRef.clear();
      const componentRef = viewContainerRef.createComponent(componentFactory);
      (<DetailsItem<T>>componentRef.instance).data = this.expandedElement;
    }
    if (this.oldExpandedElement && this.oldDetailsItem) {
      const componentFactory = this.componentFactoryResolver.resolveComponentFactory(this.oldDetailsItem.component);
      const viewContainerRef = this.oldDetailHost.viewContainerRef;
      viewContainerRef.clear();
      const componentRef = viewContainerRef.createComponent(componentFactory);
      (<DetailsItem<T>>componentRef.instance).data = this.oldExpandedElement;
    }
  }

  myTrackById(index: number, element: any) {
    if (element) {
      if (element.id) {
        return element.id;
      }

      if (element.name) {
        return element.name;
      }

      throw new Error('No element data to identify element! ' + element);
    }
  }
}
