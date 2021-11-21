import { Observable, of, combineLatest } from 'rxjs';
import { Action, select, Store } from '@ngrx/store';
import * as fromRoot from '../../app.reducers';
import { Injectable } from '@angular/core';
import * as fromCore from '../../core/store/core.reducers';
import { map } from 'rxjs/operators';

class AppAction {
  constructor(public iconName: string, public action: Action, public tooltip: string) {}
}

@Injectable({
  providedIn: 'root',
})
export class MainNavigationService {
  navAction$: Observable<AppAction>;
  actions$: Observable<AppAction[]>;

  intersectionsCount$: Observable<number>;
  signalCount$: Observable<number>;
  slotCount$: Observable<number>;
  railTrainCount$: Observable<number>;
  roadTrainCount$: Observable<number>;
  tramTrainCount$: Observable<number>;
  navigation: {
    name: string;
    available: Observable<boolean>;
    values: {
      available: Observable<boolean>;
      icon: string;
      image: string;
      title: string;
      subtitle: string | null;
      description: string | null;
      linkDescription: string | null;
      link: string;
      requiredModuleId: string;
    }[];
  }[];

  private readonly dataLuaModuleId = 'e538a124-3f0a-4848-98cf-02b08563bf32'; // "ak.data.DataLuaModule"
  private readonly kreuzungLuaModuleId = 'c5a3e6d3-0f9b-4c89-a908-ed8cf8809362'; // "ak.data.KreuzungLuaModul"

  constructor(private store: Store<fromRoot.State>) {
    this.navigation = [
      {
        name: 'Home',
        values: [
          {
            available: of(true),
            icon: 'home',
            title: 'Home',
            subtitle: null,
            link: '/',
            image: null,
            description: null,
            linkDescription: null,
            requiredModuleId: null,
          },
        ],
        available: of(true),
      },
      {
        name: 'Verkehr',
        available: combineLatest([
          this.store.pipe(select(fromCore.isModuleLoaded$(this.kreuzungLuaModuleId))),
          this.store.pipe(select(fromCore.isModuleLoaded$(this.dataLuaModuleId))),
        ]).pipe(map((b1) => b1[0] || b1[1])),
        values: [
          {
            available: this.store.pipe(select(fromCore.isModuleLoaded$(this.kreuzungLuaModuleId))),
            icon: 'gamepad',
            title: 'Kreuzungen',
            subtitle: 'Lua-Bibliothek',
            link: '/intersections',
            image: 'card-img-intersection.jpg',
            description: 'Schalte Deine Kreuzungen oder setze die passende Kamera.',
            linkDescription: 'Kreuzungen zeigen',
            requiredModuleId: this.kreuzungLuaModuleId,
          },
          //   ]
          // },
          // {
          //   name: 'Fahrzeuge', values: [
          {
            available: this.store.pipe(select(fromCore.isModuleLoaded$(this.dataLuaModuleId))),
            icon: 'directions_car',
            title: 'Autos',
            subtitle: 'Straßen',
            link: '/trains/road',
            image: 'card-img-trains-road.jpg',
            description: 'Hier findest Du auch Trams, die auf der Straße fahren.',
            linkDescription: 'Autos zeigen',
            requiredModuleId: this.dataLuaModuleId,
          },
          {
            available: this.store.pipe(select(fromCore.isModuleLoaded$(this.dataLuaModuleId))),
            icon: 'tram',
            title: 'Trams',
            subtitle: 'Straßenbahngleise',
            link: '/trains/tram',
            image: 'card-img-trains-tram.jpg',
            description: 'Trams, die auf der Straße fahren, findest Du unter Autos.',
            linkDescription: 'Trams zeigen',
            requiredModuleId: this.dataLuaModuleId,
          },
          {
            available: this.store.pipe(select(fromCore.isModuleLoaded$(this.dataLuaModuleId))),
            icon: 'train',
            title: 'Züge',
            subtitle: 'Bahngleise',
            link: '/trains/rail',
            image: 'card-img-trains-rail.jpg',
            description: 'Fahrzeuge, die auf Bahngleisen unterwegs sind.',
            linkDescription: 'Züge zeigen',
            requiredModuleId: this.dataLuaModuleId,
          },
        ],
      },
      {
        name: 'Daten',
        available: of(true),
        values: [
          {
            available: of(true),
            icon: 'message',
            title: 'Log',
            subtitle: null, // 'EEP-Log-Datei',
            link: '/log',
            image: null,
            description: 'Zeige die Log-Datei von EEP an',
            linkDescription: 'Log-Datei ansehen',
            requiredModuleId: null,
          },
          // {icon: 'directions', name: 'Weichen', link: '/switches'},
          {
            available: this.store.pipe(select(fromCore.isModuleLoaded$(this.dataLuaModuleId))),
            icon: 'memory',
            title: 'Speicher',
            subtitle: null, // 'EEPDataSlot',
            link: '/data',
            image: null,
            description: 'Daten die mit EEPSaveData gespeichert wurden',
            linkDescription: 'Zu den Daten',
            requiredModuleId: this.dataLuaModuleId,
          },
          {
            available: this.store.pipe(select(fromCore.isModuleLoaded$(this.dataLuaModuleId))),
            icon: 'traffic',
            title: 'Signale',
            subtitle: null, // 'Ampeln, Signale, Schranken',
            link: '/signals',
            image: null,
            description: 'Enthält Signale, Ampeln und Schranken',
            linkDescription: 'Zu den Signalen',
            requiredModuleId: this.dataLuaModuleId,
          },
          //   ]
          // },
          // {
          //   name: 'Roh-Daten', values: [
          {
            available: this.store.pipe(select(fromCore.isModulesAvailable)),
            icon: 'list_alt',
            title: 'Roh-Daten',
            subtitle: null, // 'JSON-Daten vom Server',
            link: '/generic-data',
            image: null,
            description: 'Übersicht der Rohdaten von EEP-Web',
            linkDescription: 'Zu den Daten',
            requiredModuleId: null,
          },
        ],
      },
    ];
  }
}
