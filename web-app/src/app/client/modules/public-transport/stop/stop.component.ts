import { Component, OnInit } from '@angular/core';
import { of, Observable } from 'rxjs';

@Component({
  selector: 'app-stop',
  templateUrl: './stop.component.html',
  styleUrls: ['./stop.component.css'],
})
export class StopComponent implements OnInit {
  name: Observable<string>;
  lines: Observable<string>;

  constructor() {
    this.name = of('Feuerwehrgasse');
    this.lines = of('10');
  }

  ngOnInit(): void {}
}
