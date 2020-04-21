import { Component, EventEmitter, OnDestroy, OnInit, Output } from '@angular/core';

@Component({
  selector: 'app-header-tool-bar',
  templateUrl: './header-tool-bar.component.html',
  styleUrls: ['./header-tool-bar.component.css']
})
export class HeaderToolBarComponent implements OnInit, OnDestroy {
  @Output() toggled = new EventEmitter<boolean>();
  title = 'EEP-Web';

  constructor() {
  }

  ngOnInit() {

  }

  ngOnDestroy() {
  }

  onToggle() {
    this.toggled.emit(true);
  }
}
