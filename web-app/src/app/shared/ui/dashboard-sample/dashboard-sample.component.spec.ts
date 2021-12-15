import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { MockStore, provideMockStore } from '@ngrx/store/testing';

import { DashboardSampleComponent } from './dashboard-sample.component';

describe('DashboardSampleComponent', () => {
  let component: DashboardSampleComponent;
  let fixture: ComponentFixture<DashboardSampleComponent>;
  let store: MockStore;
  const initialState = { loggedIn: false };

  beforeEach(
    waitForAsync(() => {
      TestBed.configureTestingModule({
        declarations: [DashboardSampleComponent],
        providers: [provideMockStore({ initialState })],
      }).compileComponents();

      store = TestBed.inject(MockStore);
    })
  );

  beforeEach(() => {
    fixture = TestBed.createComponent(DashboardSampleComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
