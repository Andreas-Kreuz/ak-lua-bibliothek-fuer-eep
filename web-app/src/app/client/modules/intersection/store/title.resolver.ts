import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Resolve, RouterStateSnapshot } from '@angular/router';
import { Store } from '@ngrx/store';
import { EMPTY, Observable, of } from 'rxjs';
import { map, take, takeUntil } from 'rxjs/operators';
import * as fromIntersection from '../store/intersection.reducers';

@Injectable({ providedIn: 'root' })
export class TitleResolver implements Resolve<string> {
  constructor(private store: Store<fromIntersection.State>) {}

  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<string> {
    const intersectionId = route.params['id'];
    return of('Kreuzung #' + intersectionId);
  }
}
