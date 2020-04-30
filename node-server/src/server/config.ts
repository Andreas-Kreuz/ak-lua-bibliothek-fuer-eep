import electron = require('electron');
import fs from 'fs';
import path from 'path';

export default class Config {
  private serverConfigPath = path.resolve(electron.app.getPath('appData'), 'eep-web-server');
  private serverConfigFile = path.resolve(this.serverConfigPath, 'settings.json');

  private loadConfig(): { eepDir: string } {
    try {
      if (fs.statSync(this.serverConfigFile).isFile()) {
        const data = fs.readFileSync(this.serverConfigFile, { encoding: 'utf8' });
        const config = JSON.parse(data);
        return config;
      }
    } catch (error) {
      console.log(error);
    }
    return {
      eepDir: 'C:\\Trend\\EEP16',
    };
  }

  private saveConfig(config: { eepDir: string }): void {
    try {
      fs.mkdirSync(this.serverConfigPath);
    } catch (error) {
      console.log(error);
    }
    try {
      fs.writeFileSync(this.serverConfigFile, JSON.stringify(config));
    } catch (error) {
      console.log(error);
    }
  }

  public getEepDirectory() {
    const config = this.loadConfig();
    if (config.eepDir) {
      return config.eepDir;
    } else {
      return 'C:\\Trend\\EEP16';
    }
  }

  public saveEepDirectory(directory: string) {
    const config = this.loadConfig();
    config.eepDir = directory;
    this.saveConfig(config);
  }
}
