import { AfterViewInit, Component, OnInit } from '@angular/core';
import { Store } from '@ngrx/store';
import { fromEvent } from 'rxjs';
import { auditTime, debounceTime } from 'rxjs/operators';
import * as fromRoot from '../../../../app.reducers';
import * as fromLogFile from '../store/log-file.reducers';

@Component({
  selector: 'app-log-text-field',
  templateUrl: './log-text-field.component.html',
  styleUrls: ['./log-text-field.component.css'],
})
export class LogTextFieldComponent implements OnInit, AfterViewInit {
  lines$ = this.store.select(fromLogFile.lines$);
  loading$ = this.store.select(fromLogFile.loading$);
  maxHeight: string;
  private autoscroll = true;
  private firstScroll = true;
  private container: HTMLElement;
  private isNearBottom = true;

  constructor(private store: Store<fromRoot.State>) {}

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

  logEntries = (index, item) => item;

  ngAfterViewInit() {
    this.container = document.getElementById('app-log-container');
    this.lines$.pipe(auditTime(50)).subscribe((_) => this.onItemElementsChanged());
    this.scrollToBottom();
  }

  scrolled(event: any): void {
    this.isNearBottom = this.isUserNearBottom();
  }

  private scrollToBottom() {
    if (this.container) {
      this.container.scroll(0, this.container.scrollHeight);
      this.firstScroll = false;
    }
  }

  private onItemElementsChanged(): void {
    if (this.firstScroll || (this.isNearBottom && this.autoscroll)) {
      this.scrollToBottom();
    }
  }

  private isUserNearBottom(): boolean {
    const threshold = window.innerHeight / 2;
    const position = this.container.scrollTop + this.container.offsetHeight;
    const height = this.container.scrollHeight;
    return position > height - threshold;
  }
}
