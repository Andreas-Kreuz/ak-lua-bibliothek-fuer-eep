import { Component, EventEmitter, Input, OnInit, OnChanges, Output, SimpleChanges, OnDestroy } from '@angular/core';
import { Observable, of, Subscription } from 'rxjs';
import { LuaSetting, LuaSettingChangeEvent, LuaSettings } from 'web-shared/build/model/settings';

@Component({
  selector: 'app-settings-panel',
  templateUrl: './settings-panel.component.html',
  styleUrls: ['./settings-panel.component.css'],
})
export class SettingsPanelComponent implements OnInit, OnDestroy, OnChanges {
  @Input() luaSettings: Observable<LuaSettings>;
  @Output() settingChanged = new EventEmitter<LuaSettingChangeEvent>();
  categories: Observable<Record<string, LuaSetting<boolean>[]>>;
  private settingSub: Subscription;

  constructor() {}

  ngOnInit(): void {
    if (!this.luaSettings) {
      this.luaSettings = this.sampleSettings();
    }
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes.luaSettings) {
      if (this.settingSub) {
        this.settingSub.unsubscribe();
      }
      this.settingSub = this.luaSettings.subscribe((s) => {
        const categories: Record<string, LuaSetting<boolean>[]> = {};
        for (const setting of s.settings) {
          const cat = categories[setting.category] || [];
          cat.push(setting);
          categories[setting.category] = cat;
        }

        this.categories = of(categories);
      });
    }
  }

  ngOnDestroy(): void {
    if (this.settingSub) {
      this.settingSub.unsubscribe();
    }
  }

  onToggle(setting: LuaSetting<any>): void {
    this.settingChanged.emit(new LuaSettingChangeEvent(setting, !setting.value));
  }

  private sampleSettings(): Observable<LuaSettings> {
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
    return of(moduleSettings);
  }
}
