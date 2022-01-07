import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { Component, Input, OnDestroy, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-card2',
  templateUrl: './card.component.html',
  styleUrls: ['./card.component.css'],
})
export class CardComponent implements OnInit, OnDestroy {
  @Input() routerUrl: string;
  @Input() imageUrl: string;
  @Input() title: string;
  @Input() subtitle: string;
  @Input() description: string;
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
