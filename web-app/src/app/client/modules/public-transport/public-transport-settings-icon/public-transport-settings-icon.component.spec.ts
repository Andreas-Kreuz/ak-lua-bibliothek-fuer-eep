import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PublicTransportSettingsIconComponent } from './public-transport-settings-icon.component';

describe('SettingsIconComponent', () => {
  let component: PublicTransportSettingsIconComponent;
  let fixture: ComponentFixture<PublicTransportSettingsIconComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [PublicTransportSettingsIconComponent],
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PublicTransportSettingsIconComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
