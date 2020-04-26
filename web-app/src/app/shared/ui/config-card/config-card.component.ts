import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Observable, of } from 'rxjs';
import { LuaSetting } from '../../model/lua-setting';
import { LuaSettings } from '../../model/lua-settings';
import { LuaSettingChangeEvent } from '../../model/lua-setting-change-event';

@Component({
  selector: 'app-config-card',
  templateUrl: './config-card.component.html',
  styleUrls: ['./config-card.component.css'],
})
export class ConfigCardComponent implements OnInit {
  @Input() title = 'Einstellungen';
  @Input() subtitle = 'Lua-Modul steuern';
  @Input() luaSettings: Observable<LuaSettings>;
  @Output() settingChanged = new EventEmitter<LuaSettingChangeEvent>();

  constructor() {
    const settingsList: LuaSetting<any>[] = [
      {
        category: 'Ampel',
        name: 'BEISPIEL: Alle Ampeln rot schalten',
        description: 'Desc 1',
        type: 'boolean',
        value: true,
        eepFunction: 'test',
      },
      {
        category: 'Ampel',
        name: 'BEISPIEL: Alle Ampeln ausblenden',
        description: 'Desc 2',
        type: 'boolean',
        value: false,
        eepFunction: 'test',
      },
      {
        category: 'Ampel',
        name: 'BEISPIEL: Ein Textbeispiel',
        description: 'Dieser Typ wird noch nicht von EEP-Lua unterstützt',
        type: 'string',
        value: false,
        eepFunction: 'test',
      },
      {
        category: 'Cat 2',
        name: 'BEISPIEL: Debug-Ausgabe',
        description: 'Schaltet die Debug-Ausgabe in der Log-Datei an',
        type: 'boolean',
        value: true,
        eepFunction: 'test',
      },
    ];

    const moduleSettings = new LuaSettings('Kreuzungen', settingsList);

    this.luaSettings = of(moduleSettings);
  }

  ngOnInit(): void {}

  onToggle(setting: LuaSetting<any>): void {
    this.settingChanged.emit(new LuaSettingChangeEvent(setting, !setting.value));
  }
}
