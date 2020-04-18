import { Injectable } from '@angular/core';
import { Switch } from '../switch.model';

@Injectable({
  providedIn: 'root'
})
export class SwitchesService {
  switches: Switch[];

  constructor() {
    this.switches = [];
  }

  getSwitches() {
    return this.switches.slice();
  }

  setSwitches(signals: Switch[]) {
    this.switches = signals;
  }

  public getSwitch(id: number) {
    const signal = this.switches.find(
      (s) => {
        return s.id === id;
      }
    );
    return signal;
  }
}
