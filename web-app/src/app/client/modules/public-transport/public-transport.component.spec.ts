import { ComponentFixture, TestBed } from '@angular/core/testing';
import { MockStore, provideMockStore } from '@ngrx/store/testing';

import { PublicTransportComponent } from './public-transport.component';

describe('PublicTransportComponent', () => {
  let component: PublicTransportComponent;
  let fixture: ComponentFixture<PublicTransportComponent>;
  let store: MockStore;
  const initialState = { loggedIn: false };

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [PublicTransportComponent],
      providers: [provideMockStore({ initialState })],
    }).compileComponents();

    store = TestBed.inject(MockStore);
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PublicTransportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
