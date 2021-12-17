import { Component, OnInit, Renderer2 } from '@angular/core';

@Component({
  selector: 'app-svg-display',
  templateUrl: './svg-display.component.html',
  styleUrls: ['./svg-display.component.css'],
})
export class SvgDisplayComponent implements OnInit {
  constructor(private renderer: Renderer2) {}

  ngOnInit(): void {
    const l1 = [272, 283, 472, 156];
    const l2 = [270, 282, 248, 30];
    const l3 = [271, 280, 247, 265];
    const l4 = [569, 568, 567, 566, 565, 564, 563, 562, 561, 166, 257, 199];
    const l5 = [549, 548, 547, 546, 545, 544, 543, 542, 521, 541, 585, 584];
    const l5a = [520, 530, 529, 528, 527, 526, 525, 524, 523, 522, 216, 582, 210];
    const l6 = [211, 34, 76, 143, 140];
    const l7 = [208, 209];
    const l8 = [127, 141, 410];
    const l9 = [670, 363, 403];
    const l10 = [622, 110, 406];

    for (const id of [...l1, ...l3, ...l5, ...l5a, ...l6, ...l7, ...l9]) {
      const group = document.getElementById('G3-' + id);
      if (group) {
        const copy = group.firstChild.cloneNode();
        group.parentNode.appendChild(copy);

        this.renderer.addClass(copy, 'bold');
        this.renderer.addClass(copy, 'red');
      }
    }

    for (const id of [...l2, ...l4, ...l8, ...l10]) {
      const group = document.getElementById('G3-' + id);
      if (group) {
        const copy = group.firstChild.cloneNode();
        group.parentNode.appendChild(copy);

        this.renderer.addClass(copy, 'bold');
        this.renderer.addClass(copy, 'green');
      }
    }
  }
}
