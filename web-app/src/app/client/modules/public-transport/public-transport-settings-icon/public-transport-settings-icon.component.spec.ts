import { ComponentFixture, TestBed } from '@angular/core/testing';
import { MockStore, provideMockStore } from '@ngrx/store/testing';

import { PublicTransportSettingsIconComponent } from './public-transport-settings-icon.component';

describe('SettingsIconComponent', () => {
  let component: PublicTransportSettingsIconComponent;
  let fixture: ComponentFixture<PublicTransportSettingsIconComponent>;
  let store: MockStore;
  const initialState = { loggedIn: false };

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [PublicTransportSettingsIconComponent],
      providers: [provideMockStore({ initialState })],
    }).compileComponents();

    store = TestBed.inject(MockStore);
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
