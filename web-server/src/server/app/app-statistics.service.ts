import { performance, PerformanceObserver } from 'perf_hooks';

const NR_OF_UPDATES = 10;
const INTERVALL_MS = 200;

export class ServerStatisticsService {
  static readonly TimeForJsonParsing = 'json-parsing:complete-time';
  static readonly TimeForEepJsonFile = 'eep:wait-for-json';

  private lastStatisticsUpdate: number;
  private lastTime: { [name: string]: { name: string; startTime: number; duration: number; diffToLast: number } } = {};
  private lastTimeOfStatistic = 0;
  private lastEepUpdate: number;

  constructor(private nrOfHistoryEntries = NR_OF_UPDATES) {
    const obs = new PerformanceObserver((items) => {
      items.getEntries().forEach((item) => {
        const lastEntry = this.lastTime[item.name];
        const diff = lastEntry === undefined ? 0 : item.startTime - lastEntry.startTime;
        this.lastTime[item.name] = {
          name: item.name,
          startTime: item.startTime,
          duration: item.duration,
          diffToLast: diff,
        };
      });
    });
    obs.observe({ entryTypes: ['measure'] });
  }

  start() {
    setInterval(this.updateStatistics, INTERVALL_MS);
    // this.updateStatistics();
  }

  setLastEepTime(lastEepUpdate: number) {
    this.lastEepUpdate = lastEepUpdate;
  }

  updateStatistics = () => {
    const timeOfStatistic = performance.now();

    let diff = -1;
    let eepTimeDiff = '---- ';
    if (this.lastEepUpdate) {
      diff = timeOfStatistic - this.lastEepUpdate;
      if (diff > 9999) {
        eepTimeDiff = '>999 ms';
      } else {
        eepTimeDiff = this.pad(diff.toFixed(), 4);
      }
    }

    if (
      diff > -1 &&
      (diff < 1000 ||
        this.lastTime[ServerStatisticsService.TimeForEepJsonFile].duration > diff ||
        this.lastTime[ServerStatisticsService.TimeForJsonParsing].duration > diff)
    ) {
      const file = this.format('eep-file', ServerStatisticsService.TimeForEepJsonFile);
      const json = this.format('json-parsing', ServerStatisticsService.TimeForJsonParsing);

      console.log('EepWait: ' + eepTimeDiff + file + json);
      this.lastTimeOfStatistic = timeOfStatistic;
      // tslint:disable-next-line: semicolon
    }
  };

  private format(description: string, statisticsKey: string): string {
    let text = ' - ' + description + ': ';
    const entry = this.lastTime[statisticsKey];
    if (entry && entry.startTime + entry.duration > this.lastTimeOfStatistic) {
      text = text + this.pad(entry.duration.toFixed(), 4) + ' ms (+' + this.pad(entry.diffToLast.toFixed(), 3) + ')';
    } else {
      text = text + '   .          ';
    }
    return text;
  }

  pad(num: string, size: number): string {
    let s = num + '';
    while (s.length < size) {
      s = ' ' + s;
    }
    return s;
  }

  // addEepTime(lastUpdates: PerformanceEntry[]): void {
  //   this.setTimes(this.eepTimeSlots, lastUpdates);
  // }

  // addJsonTime(lastUpdates: PerformanceEntry[]): void {
  //   this.setTimes(this.jsonTimeSlots, lastUpdates);
  // }

  // private setTimes(list: number[], lastUpdates: PerformanceEntry[]): void {
  //   const time = performance.now();
  // }

  // getJsonTimes(): number[] {
  //   return [...this.jsonTimeSlots];
  // }

  // getLastEepTime(): number {
  //   return this.lastEepTime;
  // }
}
