import { Component, OnInit } from '@angular/core';
import { of, Observable } from 'rxjs';

@Component({
  selector: 'app-road-stop',
  templateUrl: './road-stop.component.html',
  styleUrls: ['./road-stop.component.css'],
})
export class RoadStopComponent implements OnInit {
  name: Observable<string>;
  lines: Observable<string>;

  constructor() {
    this.name = of('Feuerwehrgasse');
    this.lines = of('10');
  }

  ngOnInit(): void {}
}
