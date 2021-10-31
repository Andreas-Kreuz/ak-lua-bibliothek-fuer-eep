import { Component, OnInit } from '@angular/core';
import { Observable, of } from 'rxjs';

@Component({
  selector: 'app-road-line',
  templateUrl: './road-line.component.html',
  styleUrls: ['./road-line.component.css'],
})
export class RoadLineComponent implements OnInit {
  nr: Observable<string>;
  type: Observable<string>;

  constructor() {
    this.nr = of('10');
    this.type = of('Straßenbahn');
  }

  ngOnInit(): void {}
}
