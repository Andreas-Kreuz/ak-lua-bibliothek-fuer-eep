import { Component, OnInit, AfterViewChecked } from '@angular/core';
import { debounceTime } from 'rxjs/operators';
import { fromEvent, Observable } from 'rxjs';
import { select, Store } from '@ngrx/store';

import * as fromRoot from '../../../app.reducers';
import * as fromLogFile from '../store/log-file.reducers';

@Component({
  selector: 'app-log-text-field',
  templateUrl: './log-text-field.component.html',
  styleUrls: ['./log-text-field.component.css']
})
export class LogTextFieldComponent implements OnInit, AfterViewChecked {
  lines$: Observable<string[]>;
  linesAsString$: Observable<string>;
  loading$: Observable<boolean>;
  maxHeight: string;
  container: HTMLElement;
  autoscroll: boolean;

  constructor(private store: Store<fromRoot.State>) {
    this.autoscroll = true;
  }

  ngOnInit() {
    const offset = 165;
    this.lines$ = this.store.pipe(select(fromLogFile.lines$));
    this.linesAsString$ = this.store.pipe(select(fromLogFile.linesAsString$));
    this.loading$ = this.store.pipe(select(fromLogFile.loading$));
    this.maxHeight = (window.innerHeight - offset) + 'px';
    fromEvent(window, 'resize').pipe(
      debounceTime(500)
    ).subscribe((event) => {
      this.maxHeight = (window.innerHeight - offset) + 'px';
    });
  }

  logEntries(index, item) {
    return index;
  }

  ngAfterViewChecked() {
    if (this.autoscroll) {
      this.container = document.getElementById('container');
      this.container.scrollTop = this.container.scrollHeight;
    }
  }
}
