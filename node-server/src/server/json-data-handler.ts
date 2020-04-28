import { Server } from './server';

export default class JsonDataHandler {
  private currentJsonContent: { [key: string]: any[] } = {};

  constructor(
    private onDataAdded: (key: string) => void,
    private onDataChanged: (key: string) => void,
    private onDataRemoved: (key: string) => void
  ) {}

  /**
   * This will fill the API and send Socket Events to all listeners
   * @param jsonString JsonString from EEP
   */
  public jsonDataUpdated(jsonString: string): void {
    // Parse the data
    const newJsonContent: { [key: string]: any[] } = JSON.parse(jsonString);

    // Get those new keys from the Json Content
    const currentKeys = Object.keys(this.currentJsonContent);
    const newJsonKeys = Object.keys(newJsonContent);
    const keysToAdd = newJsonKeys.filter((el) => !currentKeys.includes(el));
    const keysToCheck = newJsonKeys.filter((el) => currentKeys.includes(el));
    const keysToRemove = currentKeys.filter((el) => !newJsonKeys.includes(el));

    this.removeDataForKeys(keysToRemove);
    this.checkDataForKeys(keysToCheck, newJsonContent);
    this.addDataForKeys(keysToAdd, newJsonContent);

    // Store data
    this.currentJsonContent = newJsonContent;
  }

  private removeDataForKeys(keysToRemove: string[]) {
    for (const key of keysToRemove) {
      delete this.currentJsonContent[key];
      this.onDataRemoved(key);
    }
  }

  private checkDataForKeys(keysToCheck: string[], newJsonContent: { [key: string]: any[] }) {
    for (const key of keysToCheck) {
      const currentData = JSON.stringify(this.currentJsonContent[key]);
      const newData = JSON.stringify(this.currentJsonContent[key]);
      if (currentData !== newData) {
        this.currentJsonContent[key] = newJsonContent[key];
        this.onDataChanged(key);
      }
    }
  }

  private addDataForKeys(keysToAdd: string[], newJsonContent: { [key: string]: any[] }) {
    for (const key of keysToAdd) {
      this.currentJsonContent[key] = newJsonContent[key];
      this.onDataAdded(key);
    }
  }

  public getCurrentApiEntry(key: string) {
    if (this.currentJsonContent.hasOwnProperty(key)) {
      return this.currentJsonContent[key];
    } else {
      return null;
    }
  }
}
