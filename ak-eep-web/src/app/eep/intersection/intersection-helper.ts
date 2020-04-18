import { IntersectionLane } from './models/intersection-lane.model';
import { IntersectionSwitching } from './models/intersection-switching.model';
import { TrafficType } from './models/traffic-type.enum';
import { Direction } from './models/direction.model';
import * as icons from '../../shared/unicode-symbol.model';
import { Intersection } from './models/intersection.model';
import { Phase } from './models/phase.enum';
import * as IntersectionAction from './store/intersection.actions';
import { Store } from '@ngrx/store';
import * as fromRoot from '../../app.reducers';
import { CamHelpDialogComponent } from '../cam/cam-help-dialog/cam-help-dialog.component';
import { MatDialog } from '@angular/material/dialog';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class IntersectionHelper {

  constructor(private store: Store<fromRoot.State>) {
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
      case TrafficType.PEDESTRIAN:
      case 'PEDESTRIAN':
        images.push('../../../../assets/lane-pedestrian.svg');
        break;
      case TrafficType.TRAM:
      case 'TRAM':
        for (const d of lane.directions) {
          switch (d) {
            case Direction.LEFT:
              images.push('../../../../assets/strab-f3.svg');
              break;
            case Direction.STRAIGHT:
              images.push('../../../../assets/strab-f1.svg');
              break;
            case Direction.RIGHT:
              images.push('../../../../assets/strab-f2.svg');
              break;
          }
        }
        break;
      default:
        for (const d of lane.directions) {
          switch (d) {
            case Direction.LEFT:
              images.push('../../../../assets/sign-left.svg');
              break;
            case Direction.STRAIGHT:
              images.push('../../../../assets/sign-straight.svg');
              break;
            case Direction.RIGHT:
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
    for (let i = 0; i < lane.waitingTrains.length; i++) {
      cars = cars +
        '<span placement="top" ngbTooltip="lane.waitingTrains[i]">' + icons.car + '</span>';
    }
    return cars;
  }

  private iconFor(lane: IntersectionLane) {
    switch (lane.type) {
      case TrafficType.PEDESTRIAN:
        return icons.trainPassenger;
      case TrafficType.NORMAL:
        return icons.car;
      case TrafficType.TRAM:
        return icons.tram;
    }
  }

  phaseColor(lane: IntersectionLane, switching?: IntersectionSwitching, intersection?: Intersection) {
    if (switching && switching.name !== intersection.currentSwitching) {
      return '';
    }

    switch (lane.phase) {
      case 'PEDESTRIAN':
      case Phase.PEDESTRIAN:
      case Phase.GREEN:
        return 'table-success';
      case Phase.RED:
        return 'table-danger';
      case Phase.RED_YELLOW:
      case Phase.YELLOW:
        return 'table-warning';
      default:
        return '';
    }
  }

  laneContained(lane: IntersectionLane, switching: IntersectionSwitching) {
    return lane.switchings.indexOf(switching.name) >= 0;
  }

  activateCam(staticCam: string, dialog: MatDialog) {
    if (staticCam) {
      this.store.dispatch(new IntersectionAction.SwitchToCam({
        staticCam: staticCam
      }));
    } else {
      this.openDialog(dialog);
    }
  }

  openDialog(dialog: MatDialog): void {
    const dialogRef = dialog.open(CamHelpDialogComponent, {
      width: '90%'
    });

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
    });
  }
}
