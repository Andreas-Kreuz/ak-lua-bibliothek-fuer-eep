import { Observable, of } from 'rxjs';
import { Action, select, Store } from '@ngrx/store';
import * as fromRoot from '../../app.reducers';
import { Injectable } from '@angular/core';
import * as fromDataTypes from '../datatypes/store/data-types.reducers';
import * as fromEepData from '../../eep/data/store/eep-data.reducers';
import * as fromIntersection from '../../eep/intersection/store/intersection.reducers';
import * as fromSignal from '../../eep/signals/store/signal.reducers';
import * as fromTrain from '../../eep/trains/store/train.reducer';

class AppAction {
  constructor(public iconName: string,
              public action: Action,
              public tooltip: string) {
  }
}

@Injectable({
  providedIn: 'root'
})
export class MainNavigationService {
  navAction$: Observable<AppAction>;
  actions$: Observable<AppAction[]>;

  intersectionsCount$: Observable<number>;
  signalCount$: Observable<number>;
  slotCount$: Observable<number>;
  intersectionsAvailable$: Observable<boolean>;
  railTrainCount$: Observable<number>;
  roadTrainCount$: Observable<number>;
  tramTrainCount$: Observable<number>;
  navigation: ({
    name: string, values: {
      badge: null | Observable<number>;
      available: Observable<boolean>;
      icon: string;
      image: string;
      title: string;
      subtitle: string | null;
      description: string | null;
      linkDescription: string | null;
      link: string
    }[];
  })[];

  constructor(private store: Store<fromRoot.State>) {
    this.intersectionsAvailable$ = this.store.pipe(select(fromDataTypes.selectIntersectionsAvailable));
    this.intersectionsCount$ = this.store.pipe(select(fromIntersection.intersectionsCount$));
    this.slotCount$ = this.store.pipe(select(fromEepData.eepDataCount$));
    this.signalCount$ = this.store.pipe(select(fromSignal.signalCount$));
    this.railTrainCount$ = this.store.pipe(select(fromTrain.selectRailTrainCount));
    this.roadTrainCount$ = this.store.pipe(select(fromTrain.selectRoadTrainCount));
    this.tramTrainCount$ = this.store.pipe(select(fromTrain.selectTramTrainCount));
    this.navigation = [
      {
        name: 'Home', values: [
          {
            available: of(true),
            icon: 'home',
            title: 'Home',
            subtitle: null,
            link: '/',
            image: null,
            badge: null,
            description: null,
            linkDescription: null,
          },
        ]
      },
      {
        name: 'Verkehr', values: [
          {
            available: this.intersectionsAvailable$,
            icon: 'gamepad',
            title: 'Kreuzungen',
            subtitle: 'Lua-Bibliothek',
            link: '/intersections',
            image: 'card-img-intersection.jpg',
            badge: this.intersectionsCount$,
            description: 'Schalte Deine Kreuzungen oder setze die passende Kamera.',
            linkDescription: 'Kreuzungen zeigen',
          },
          //   ]
          // },
          // {
          //   name: 'Fahrzeuge', values: [
          {
            available: of(true),
            icon: 'directions_car',
            title: 'Autos',
            subtitle: 'Straßen',
            link: '/trains/road',
            image: 'card-img-trains-road.jpg',
            badge: this.roadTrainCount$,
            description: 'Hier findest Du auch Trams, die auf der Straße fahren.',
            linkDescription: 'Autos zeigen',
          },
          {
            available: of(true),
            icon: 'tram',
            title: 'Trams',
            subtitle: 'Straßenbahngleise',
            link: '/trains/tram',
            image: 'card-img-trains-tram.jpg',
            badge: this.tramTrainCount$,
            description: 'Trams, die auf der Straße fahren, findest Du unter Autos.',
            linkDescription: 'Trams zeigen',
          },
          {
            available: of(true),
            icon: 'train',
            title: 'Züge',
            subtitle: 'Bahngleise',
            link: '/trains/rail',
            image: 'card-img-trains-rail.jpg',
            badge: this.railTrainCount$,
            description: 'Fahrzeuge, die auf Bahngleisen unterwegs sind.',
            linkDescription: 'Züge zeigen',
          },
        ]
      },
      {
        name: 'Daten', values: [
          {
            available: of(true),
            icon: 'message',
            title: 'Log',
            subtitle: null, // 'EEP-Log-Datei',
            link: '/log',
            image: null,
            badge: null,
            description: 'Zeige die Log-Datei von EEP an',
            linkDescription: 'Log-Datei ansehen',
          },
          // {icon: 'directions', name: 'Weichen', link: '/switches'},
          {
            available: of(true),
            icon: 'memory',
            title: 'Speicher',
            subtitle: null, // 'EEPDataSlot',
            link: '/data',
            image: null,
            badge: this.slotCount$,
            description: 'Daten die mit EEPSaveData gespeichert wurden',
            linkDescription: 'Zu den Daten',
          },
          {
            available: of(true),
            icon: 'traffic',
            title: 'Signale',
            subtitle: null, // 'Ampeln, Signale, Schranken',
            link: '/signals',
            image: null,
            badge: this.signalCount$,
            description: 'Enthält Signale, Ampeln und Schranken',
            linkDescription: 'Zu den Signalen',
          },
          //   ]
          // },
          // {
          //   name: 'Roh-Daten', values: [
          {
            available: of(true),
            icon: 'list_alt',
            title: 'Roh-Daten',
            subtitle: null, // 'JSON-Daten vom Server',
            link: '/generic-data',
            image: null,
            badge: null,
            description: 'Übersicht der Rohdaten von EEP-Web',
            linkDescription: 'Zu den Daten',
          },
        ]
      },
    ];
  }
}
