import JsonDataEffects from './json-data-effects';

export default class JsonDataStore {
  private currentJsonContent: { [key: string]: any[] } = {};
  private urls: string[] = [];
  private dataRooms: string[] = [];

  constructor(private effects: JsonDataEffects) {}

  calcChangedKeys(keysToCheck: string[], newJsonContent: { [key: string]: any[] }): string[] {
    const changedKeys: string[] = [];
    for (const key of keysToCheck) {
      const currentData = JSON.stringify(this.currentJsonContent[key]);
      const newData = JSON.stringify(newJsonContent[key]);
      if (currentData !== newData) {
        changedKeys.push(key);
      }
    }

    return changedKeys;
  }

  hasJsonKey(key: string): boolean {
    return this.currentJsonContent.hasOwnProperty(key);
  }

  getJsonData(): any {
    return this.currentJsonContent;
  }

  setJsonData(newJsonContent: any): void {
    this.currentJsonContent = newJsonContent;
  }

  addUrls(urls: string[]): void {
    this.urls = this.urls.concat(urls);
    this.urls.sort(this.alphabeticalSort);
  }

  removeUrls(urls: string[]): void {
    this.urls = this.urls.filter((key) => urls.indexOf(key) < 0);
  }

  getUrls(): string[] {
    return this.urls;
  }

  addDataRoom(dataType: string): void {
    this.dataRooms.push(dataType);
    this.dataRooms.sort(this.alphabeticalSort);
  }

  removeDataRoom(dataType: string): void {
    const index = this.dataRooms.indexOf(dataType);
    if (index >= 0) {
      this.dataRooms.splice(index, 1);
    }
  }

  getDataRooms(): string[] {
    return this.dataRooms;
  }

  private alphabeticalSort(a: any, b: any): number {
    if (a < b) {
      return -1;
    }
    if (a > b) {
      return 1;
    }
    return 0;
  }
}
