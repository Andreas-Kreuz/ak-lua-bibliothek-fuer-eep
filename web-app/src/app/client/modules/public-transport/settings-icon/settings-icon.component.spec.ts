import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SettingsIconComponent } from './settings-icon.component';

describe('SettingsIconComponent', () => {
  let component: SettingsIconComponent;
  let fixture: ComponentFixture<SettingsIconComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SettingsIconComponent ]
    })
    .compileComponents();
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
