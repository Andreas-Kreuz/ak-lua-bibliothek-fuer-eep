import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import * as assert from 'assert';
import { Observable } from 'rxjs';
import { LuaSettingChangeEvent, LuaSettings } from 'web-shared/build/model/settings';
import { SettingsDialogComponent } from '../settings-dialog/settings-dialog.component';

@Component({
  selector: 'app-settings-icon',
  templateUrl: './settings-icon.component.html',
  styleUrls: ['./settings-icon.component.css'],
})
export class SettingsIconComponent implements OnInit {
  @Input() title = 'Einstellungen';
  @Input() subtitle = 'Lua-Modul steuern';
  @Input() luaSettings: Observable<LuaSettings>;
  @Output() settingChanged = new EventEmitter<LuaSettingChangeEvent>();

  constructor(public dialog: MatDialog) {}

  ngOnInit(): void {}

  openDialog(): void {
    this.dialog.open(SettingsDialogComponent, {
      data: {
        title: this.title,
        subtitle: this.subtitle,
        luaSettings: this.luaSettings,
        settingChanged: this.settingChanged,
      },
    });
  }
}
