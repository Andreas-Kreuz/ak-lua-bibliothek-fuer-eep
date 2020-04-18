import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DashboardSampleComponent } from './dashboard-sample.component';

describe('DashboardSampleComponent', () => {
  let component: DashboardSampleComponent;
  let fixture: ComponentFixture<DashboardSampleComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [DashboardSampleComponent]
    })
      .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DashboardSampleComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
