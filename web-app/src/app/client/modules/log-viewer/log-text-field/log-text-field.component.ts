import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { debounceTime } from 'rxjs/operators';
import { fromEvent, Observable } from 'rxjs';
import { select, Store } from '@ngrx/store';

import * as fromRoot from '../../../../app.reducers';
import * as fromLogFile from '../store/log-file.reducers';

@Component({
  selector: 'app-log-text-field',
  templateUrl: './log-text-field.component.html',
  styleUrls: ['./log-text-field.component.css'],
})
export class LogTextFieldComponent implements OnInit, AfterViewInit {
  lines$ = this.store.select(fromLogFile.lines$);
  linesAsString$ = this.store.select(fromLogFile.linesAsString$);
  loading$ = this.store.select(fromLogFile.loading$);
  maxHeight: string;
  autoscroll: boolean;
  private container: HTMLElement;
  private isNearBottom = true;

  constructor(private store: Store<fromRoot.State>) {
    this.autoscroll = true;
  }

  ngOnInit() {
    this.resetMaxHeight();
    fromEvent(window, 'resize')
      .pipe(debounceTime(500))
      .subscribe((event) => {
        this.resetMaxHeight();
      });
  }

  resetMaxHeight = () => {
    const small = window.innerWidth < 576;
    this.maxHeight = 'calc(' + window.innerHeight + 'px - ' + (small ? '56px' : '64px') + ')';
  };

  logEntries(index, item) {
    return index;
  }

  ngAfterViewInit() {
    this.container = document.getElementById('container');
    this.linesAsString$.subscribe((_) => this.onItemElementsChanged());
  }

  scrolled(event: any): void {
    this.isNearBottom = this.isUserNearBottom();
  }

  private scrollToBottom() {
    this.container.scroll({
      top: this.container.scrollHeight,
      left: 0,
      behavior: 'smooth',
    });
  }

  private onItemElementsChanged(): void {
    if (this.isNearBottom && this.autoscroll) {
      this.scrollToBottom();
    }
  }

  private isUserNearBottom(): boolean {
    const threshold = 150;
    const position = this.container.scrollTop + this.container.offsetHeight;
    const height = this.container.scrollHeight;
    return position > height - threshold;
  }
}
