import { DataSource } from '@angular/cdk/collections';
import { MatSort } from '@angular/material/sort';
import { map } from 'rxjs/operators';
import { merge, Observable, Subscription } from 'rxjs';

/**
 * Data source for the Table view. This class should
 * encapsulate all logic for fetching and manipulating the displayed data
 * (including sorting, pagination, and filtering).
 */
export class TableDataSource<T> extends DataSource<T> {
  private data: T[];
  private dataSubscription: Subscription;
  private filterSubscription: Subscription;
  filterPredicate: (data, filterText) => boolean;
  private filterText: string;

  constructor(private data$: Observable<T[]>,
              private filter: Observable<string>,
              private sort: MatSort,
              private columnsToDisplay: string[],
              private columnTextFunctions?: (T) => string) {
    super();

    this.data = [];
    this.filterText = null;

    this.filterPredicate = function (data, filterText) {
      // Transform the data into a lowercase string of all property values.
      const dataStr = columnsToDisplay.reduce(function (currentTerm, key) {
        // Use an obscure Unicode character to delimit the words in the concatenated string.
        // This avoids matches where the values of two columns combined will match the user's query
        // (e.g. `Flute` and `Stop` will match `Test`). The character is intended to be something
        // that has a very low chance of being typed in by somebody in a text field. This one in
        // particular is "White up-pointing triangle with dot" from
        // https://en.wikipedia.org/wiki/List_of_Unicode_characters
        const val = textFor(columnTextFunctions, data, key);
        return currentTerm + val + '◬';
      }, '').toLowerCase();
      // Transform the filter by converting it to lowercase and removing whitespace.
      const transformedFilter = filterText.trim().toLowerCase();
      return dataStr.indexOf(transformedFilter) !== -1;
    };
  }

  /**
   * Connect this data source to the table. The table will only update when
   * the returned stream emits new items.
   * @returns A stream of the items to be rendered.
   */
  connect(): Observable<T[]> {
    // Combine everything that affects the rendered data into one update
    // stream for the data-filtered-table to consume.
    this.dataSubscription = this.data$.subscribe((changedData) => {
        this.data = changedData;
      }
    );
    this.filterSubscription = this.filter.subscribe((filterText) => {
        this.filterText = filterText && filterText.length > 0
          ? filterText
          : null;
      }
    );

    const dataMutations = [
      this.data$,
      this.filter,
      this.sort.sortChange
    ];

    return merge(...dataMutations).pipe(map(() => {
      // return this.getPagedData(this.getSortedData([...this.data]));
      return this.getSortedData(this.getFilteredData([...this.data]));
    }));
  }

  /**
   *  Called when the table is being destroyed. Use this function, to clean up
   * any open connections or free any held resources that were set up during connect.
   */
  disconnect() {
    this.dataSubscription.unsubscribe();
    this.filterSubscription.unsubscribe();
  }

  // /**
  //  * Paginate the data (client-side). If you're using server-side pagination,
  //  * this would be replaced by requesting the appropriate data from the server.
  //  */
  // private getPagedData(data: T[]) {
  //   const startIndex = this.paginator.pageIndex * this.paginator.pageSize;
  //   return data.splice(startIndex, this.paginator.pageSize);
  // }

  /**
   * Sort the data (client-side). If you're using server-side sorting,
   * this would be replaced by requesting the appropriate data from the server.
   */
  private getSortedData(data: T[]) {
    if (!this.sort.active || this.sort.direction === '') {
      return data;
    }

    return data.sort((a, b) => {
      const isAsc = this.sort.direction === 'asc';

      if (this.sort.active) {
        const valA = textFor(this.columnTextFunctions, a, this.sort.active);
        const valB = textFor(this.columnTextFunctions, b, this.sort.active);

        if (valA && valB) {
          return compare(valA, valB, isAsc);
        }
      }

      return 0;
    });
  }

  private getFilteredData(allData: T[]) {
    return this.filterText
      ? allData.filter((data) => this.filterPredicate(data, this.filterText))
      : allData;
  }

}

function textFor(columnTextFunctions: (T) => any, element: any, column: string) {
  const value = columnTextFunctions && columnTextFunctions[column]
    ? columnTextFunctions[column](element)
    : element[column];

  return value;
}

/** Simple sort comparator for example ID/Name columns (for client-side sorting). */
function compare(a, b, isAsc) {
  return (a < b ? -1 : 1) * (isAsc ? 1 : -1);
}
