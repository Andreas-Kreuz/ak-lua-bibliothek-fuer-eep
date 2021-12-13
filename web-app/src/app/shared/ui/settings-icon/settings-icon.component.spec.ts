import { ComponentFixture, TestBed } from '@angular/core/testing';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { MockStore, provideMockStore } from '@ngrx/store/testing';

import { SettingsIconComponent } from './settings-icon.component';

class MatDialogMock {
  close(value = '') {}
}

describe('SettingsIconComponent', () => {
  let component: SettingsIconComponent;
  let fixture: ComponentFixture<SettingsIconComponent>;
  let store: MockStore;
  const initialState = { loggedIn: false };

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [SettingsIconComponent],
      providers: [{ provide: MatDialog, useClass: MatDialogMock }, provideMockStore({ initialState })],
    }).compileComponents();

    store = TestBed.inject(MockStore);
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SettingsIconComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
