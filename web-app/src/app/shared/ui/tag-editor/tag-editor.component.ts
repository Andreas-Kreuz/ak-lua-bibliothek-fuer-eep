import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-tag-editor',
  templateUrl: './tag-editor.component.html',
  styleUrls: ['./tag-editor.component.css'],
})
export class TagEditorComponent implements OnInit {
  model = {
    l: '10',
    d: 'Betriebshof',
    a: 'RIGHT',
    i: '10002001',
    n: 'RE 132',
    key: 'Value',
  };
  encodedLength = 440;

  constructor() {}

  ngOnInit(): void {}
}
