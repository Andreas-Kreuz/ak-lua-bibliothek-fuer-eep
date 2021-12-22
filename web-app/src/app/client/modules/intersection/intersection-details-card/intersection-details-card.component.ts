import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { Component, Input, OnDestroy, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';
import { Intersection } from '../models/intersection.model';

@Component({
  selector: 'app-intersection-details-card',
  templateUrl: './intersection-details-card.component.html',
  styleUrls: ['./intersection-details-card.component.css'],
})
export class IntersectionDetailsCardComponent implements OnInit, OnDestroy {
  @Input() intersection: Intersection;
  smallSub: Subscription;
  smallPortrait = true;
  handsetSub: Subscription;
  handsetPortrait = true;

  constructor(private bo: BreakpointObserver) {}

  ngOnInit() {
    const portraitBreakpoints = [Breakpoints.HandsetPortrait, Breakpoints.TabletPortrait, Breakpoints.WebPortrait];
    this.smallPortrait = this.bo.isMatched(portraitBreakpoints);
    this.smallSub = this.bo.observe(portraitBreakpoints).subscribe((thingy) => {
      this.smallPortrait = thingy.matches;
    });

    const handsetBreakpoints = [Breakpoints.HandsetPortrait];
    this.handsetPortrait = this.bo.isMatched(handsetBreakpoints);
    this.handsetSub = this.bo.observe(handsetBreakpoints).subscribe((thingy) => {
      this.handsetPortrait = thingy.matches;
    });
  }

  ngOnDestroy() {
    this.smallSub.unsubscribe();
    this.handsetSub.unsubscribe();
  }
}
