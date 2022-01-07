import {
  AfterViewInit,
  Component,
  ElementRef,
  Input,
  OnChanges,
  OnInit,
  Renderer2,
  SimpleChanges,
  ViewChild,
  ViewEncapsulation,
} from '@angular/core';
import { DomSanitizer } from '@angular/platform-browser';
import { IntersectionLane } from '../models/intersection-lane.model';
import { Intersection } from '../models/intersection.model';

@Component({
  selector: 'app-intersection-lane-display',
  templateUrl: './intersection-lane-display.component.html',
  styleUrls: ['./intersection-lane-display.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class IntersectionLaneDisplayComponent implements OnInit, OnChanges, AfterViewInit {
  @Input() innerSvg = ''; //this.sanitizer.bypassSecurityTrustHtml(mySvg);
  @ViewChild('myRoot') divRef: ElementRef;

  @Input() intersection: Intersection;
  @Input() lanes: IntersectionLane[];
  private lanesInitialized = false;

  constructor(private sanitizer: DomSanitizer, private renderer: Renderer2) {}

  ngOnInit(): void {}

  ngOnChanges(changes: SimpleChanges): void {
    for (const propName in changes) {
      if (propName === 'lanes') {
        const chng = changes[propName];
        if (this.renderer && chng.currentValue && chng.currentValue.length > 0) {
          if (!this.lanesInitialized) {
            this.initLanes(chng.currentValue);
          }
          this.updateLanes(chng.currentValue, chng.previousValue);
        }
      }
    }
  }

  ngAfterViewInit() {
    this.initSvgRoot();
  }

  initSvgRoot(): void {
    const svgRoot = this.divRef.nativeElement.children[0];
    if (svgRoot) {
      this.renderer.setAttribute(svgRoot, 'width', '100%');
      this.renderer.removeAttribute(svgRoot, 'height');
    }
  }

  initLanes(currentLanes: IntersectionLane[]): void {
    currentLanes.forEach((lane) => {
      if (lane) {
        if (lane.tracks) {
          lane.tracks.forEach((trackId) => {
            const group = document.getElementById('G3-' + trackId);
            if (group) {
              const copy = group.children[0].cloneNode();
              if (copy) {
                this.renderer.addClass(copy, 'bold');
                this.renderer.setProperty(copy, 'id', 'G3-' + trackId + '-lane');
                this.renderer.appendChild(group, copy);
                this.lanesInitialized = true;
              }
            } else {
              // console.warn('Did not find: ', 'G3-' + trackId);
            }
          });
        }
      }
    });
  }

  cssClassForPhase(lane: IntersectionLane) {
    if (lane && lane.phase) {
      switch (lane.phase) {
        case 'YELLOW':
        case 'RED_YELLOW':
          return 'yellow';
        case 'GREEN':
          return 'green';
      }
      return 'red';
    }
  }

  updateLanes(currentLanes: IntersectionLane[], oldLanes: IntersectionLane[]): void {
    currentLanes.forEach((lane) => {
      if (lane.tracks) {
        const oldLane = oldLanes && oldLanes.find((el) => el.id === lane.id);
        const oldColor = this.cssClassForPhase(oldLane);
        const newColor = this.cssClassForPhase(lane);

        if (oldColor !== newColor) {
          lane.tracks.forEach((trackId) => {
            const laneEl = document.getElementById('G3-' + trackId + '-lane');
            if (laneEl) {
              if (oldColor) {
                this.renderer.removeClass(laneEl, oldColor);
              }
              this.renderer.addClass(laneEl, newColor);
            } else {
              // console.warn('Did not find: ', 'G3-' + trackId + '-lane');
            }
          });
        }
      }
    });
  }
}
