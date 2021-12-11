import { Component, OnInit } from '@angular/core';
import { Observable, of } from 'rxjs';

@Component({
  selector: 'app-line',
  templateUrl: './line.component.html',
  styleUrls: ['./line.component.css'],
})
export class LineComponent implements OnInit {
  nr: Observable<string>;
  type: Observable<string>;

  constructor() {
    this.nr = of('10');
    this.type = of('Straßenbahn');
  }

  ngOnInit(): void {}
}
