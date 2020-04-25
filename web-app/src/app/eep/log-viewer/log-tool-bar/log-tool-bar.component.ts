import { Component, OnInit } from '@angular/core';
import * as logAction from '../store/log-file.actions';
import { Store } from '@ngrx/store';
import * as fromRoot from '../../../app.reducers';

@Component({
  selector: 'app-log-tool-bar',
  templateUrl: './log-tool-bar.component.html',
  styleUrls: ['./log-tool-bar.component.css']
})
export class LogToolBarComponent implements OnInit {

  constructor(private store: Store<fromRoot.State>) {
  }

  ngOnInit() {
  }

  clearLog() {
    this.store.dispatch(new logAction.SendCommand('clearlog'));
  }

  sendTestMessage() {
    this.store.dispatch(new logAction.SendCommand('print|Hallo von EEP-Web! Umlaute: äöüÄÖÜß'));
  }

}
