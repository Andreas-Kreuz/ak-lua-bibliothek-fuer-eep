import { Component, Input, OnInit } from '@angular/core';
import { DomSanitizer } from '@angular/platform-browser';
import { mySvg } from './example.svg';

@Component({
  selector: 'app-intersection-lane-display',
  templateUrl: './intersection-lane-display.component.html',
  styleUrls: ['./intersection-lane-display.component.css'],
})
export class IntersectionLaneDisplayComponent implements OnInit {
  @Input() svg = this.sanitizer.bypassSecurityTrustHtml(mySvg);

  constructor(private sanitizer: DomSanitizer) {}

  ngOnInit(): void {}
}
