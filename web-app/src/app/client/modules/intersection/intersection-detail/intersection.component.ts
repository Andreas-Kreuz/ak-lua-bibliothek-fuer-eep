import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { select, Store } from '@ngrx/store';
import { Observable, Subscription } from 'rxjs';

import * as fromIntersection from '../store/intersection.reducers';
import * as IntersectionAction from '../store/intersection.actions';
import { Intersection } from '../models/intersection.model';
import { IntersectionLane } from '../models/intersection-lane.model';
import * as icons from '../../../../shared/unicode-symbol.model';
import { Phase } from '../models/phase.enum';
import { Direction } from '../models/direction.model';
import { TrafficType } from '../models/traffic-type.enum';
import { IntersectionSwitching } from '../models/intersection-switching.model';
import { IntersectionHelper } from '../intersection-helper';
import { MatDialog } from '@angular/material/dialog';

@Component({
  selector: 'app-crossing',
  templateUrl: './intersection.component.html',
  styleUrls: ['./intersection.component.css'],
})
export class IntersectionComponent implements OnInit, OnDestroy {
  intersection$: Observable<Intersection>;
  routeParams$: Subscription;
  switching$: Observable<IntersectionSwitching[]>;
  switchingSub: Subscription;
  lanes$: Observable<IntersectionLane[]>;
  intersectionId: number;

  constructor(
    private store: Store<fromIntersection.State>,
    private route: ActivatedRoute,
    public intersectionHelper: IntersectionHelper,
    public dialog: MatDialog
  ) {}

  ngOnInit() {
    this.routeParams$ = this.route.params.subscribe((params: Params) => {
      this.intersectionId = +this.route.snapshot.params['id'];
      this.intersection$ = this.store.select(fromIntersection.intersectionById$(this.intersectionId));
      this.lanes$ = this.store.select(fromIntersection.laneByIntersectionId$(this.intersectionId));
      this.switchingSub = this.intersection$.subscribe(
        (intersection) =>
          (this.switching$ = this.store.select(fromIntersection.switchingNamesByIntersection$(intersection)))
      );
    });
  }

  ngOnDestroy() {
    this.routeParams$.unsubscribe();
    this.switchingSub.unsubscribe();
  }

  typeIcon(type: string) {
    switch (type) {
      case 'PEDESTRIAN':
        return '../../../../assets/sign-pedestrian.svg';
      case 'TRAM':
        return '../../../../assets/sign-tram.svg';
      default:
        return '../../../../assets/sign-cars.svg';
    }
  }

  trackLane(index, lane: IntersectionLane) {
    if (!lane) {
      return null;
    }
    return lane.id;
  }

  trackSwitching(index, intersectionSwitching: IntersectionSwitching) {
    if (!intersectionSwitching) {
      return null;
    }
    return intersectionSwitching.id;
  }

  directionIcons(lane: IntersectionLane) {
    const images = [];
    switch (lane.type) {
      case TrafficType.pedestrian:
      case 'PEDESTRIAN':
        images.push('../../../../assets/lane-pedestrian.svg');
        break;
      case TrafficType.tram:
      case 'TRAM':
        for (const d of lane.directions) {
          switch (d) {
            case Direction.left:
              images.push('../../../../assets/strab-f3.svg');
              break;
            case Direction.straight:
              images.push('../../../../assets/strab-f1.svg');
              break;
            case Direction.right:
              images.push('../../../../assets/strab-f2.svg');
              break;
          }
        }
        break;
      default:
        for (const d of lane.directions) {
          switch (d) {
            case Direction.left:
              images.push('../../../../assets/sign-left.svg');
              break;
            case Direction.straight:
              images.push('../../../../assets/sign-straight.svg');
              break;
            case Direction.right:
              images.push('../../../../assets/sign-right.svg');
              break;
          }
        }
        break;
    }
    return images;
  }

  carsWaiting(lane: IntersectionLane) {
    if (lane.waitingTrains.length === 0) {
      return '-';
    }
    let cars = '';

    const icon = this.iconFor(lane);
    for (const train of lane.waitingTrains) {
      cars = cars + '<span placement="top" ngbTooltip="train">' + icons.car + '</span>';
    }
    return cars;
  }

  phaseColor = (lane: IntersectionLane, switching?: IntersectionSwitching, intersection?: Intersection) => {
    if (switching && switching.name !== intersection.currentSwitching) {
      return '';
    }

    switch (lane.phase) {
      case 'PEDESTRIAN':
      case Phase.pedestrian:
      case Phase.green:
        return 'table-success';
      case Phase.red:
        return 'table-danger';
      case Phase.redYellow:
      case Phase.yellow:
        return 'table-warning';
      default:
        return '';
    }
  };

  laneContained(lane: IntersectionLane, switching: IntersectionSwitching) {
    return lane.switchings.indexOf(switching.name) >= 0;
  }

  switchTo(intersection: Intersection, switching: IntersectionSwitching) {
    this.store.dispatch(
      IntersectionAction.switchManually({
        intersection,
        switching,
      })
    );
  }

  enableAutomaticMode(intersection: Intersection) {
    this.store.dispatch(
      IntersectionAction.switchAutomatically({
        intersection,
      })
    );
  }

  btnColorForAutomatic(intersection: Intersection) {
    if (intersection.manualSwitching) {
      return 'btn-danger';
    }
    return 'btn-success';
  }

  btnColorForSwitching(intersection: Intersection, switching: IntersectionSwitching) {
    if (intersection.manualSwitching === switching.name) {
      return 'btn-success';
    }
    // if (intersection.currentSwitching === switching.name) {
    //   return 'btn-primary';
    // }
    if (intersection.nextSwitching === switching.name) {
      return 'btn-primary';
    }
    return 'btn-secondary';
  }

  private iconFor(lane: IntersectionLane) {
    switch (lane.type) {
      case TrafficType.pedestrian:
        return icons.trainPassenger;
      case TrafficType.normal:
        return icons.car;
      case TrafficType.tram:
        return icons.tram;
    }
  }
}
