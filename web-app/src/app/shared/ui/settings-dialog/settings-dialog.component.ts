import { Component, EventEmitter, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Observable } from 'rxjs';
import { LuaSettingChangeEvent, LuaSettings } from 'web-shared/build/model/settings';

@Component({
  selector: 'app-settings-dialog',
  templateUrl: './settings-dialog.component.html',
  styleUrls: ['./settings-dialog.component.css'],
})
export class SettingsDialogComponent implements OnInit {
  title = 'Einstellungen';
  subtitle = 'Lua-Modul steuern';
  luaSettings: Observable<LuaSettings>;
  settingChanged: EventEmitter<LuaSettingChangeEvent>;

  constructor(
    private dialogRef: MatDialogRef<SettingsDialogComponent>,
    @Inject(MAT_DIALOG_DATA)
    data: {
      title: string;
      subtitle: string;
      luaSettings: Observable<LuaSettings>;
      settingChanged: EventEmitter<LuaSettingChangeEvent>;
    }
  ) {
    this.title = data.title;
    this.subtitle = data.subtitle;
    this.luaSettings = data.luaSettings;
    this.settingChanged = data.settingChanged;
  }

  ngOnInit(): void {}

  settingChangedEvent(event: LuaSettingChangeEvent) {
    this.settingChanged.emit(event);
  }

  closeDialog() {
    this.dialogRef.close();
  }
}
