import AppConfig from './app-config';

export default class AppData {
  private appConfig = new AppConfig();
  private eepDirOk = false;

  public setAppConfig(appConfig: AppConfig): void {
    this.appConfig = appConfig;
  }

  public getAppConfig(): AppConfig {
    return this.appConfig;
  }
  public setEepDir(dir: string): void {
    this.appConfig.eepDir = dir;
  }

  public getEepDir(): string {
    return this.appConfig.eepDir;
  }

  public setEepDirOk(ok: boolean): void {
    this.eepDirOk = ok;
  }

  public getEepDirOk(): boolean {
    return this.eepDirOk;
  }
}
