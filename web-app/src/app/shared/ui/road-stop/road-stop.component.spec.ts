import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { RoadStopComponent } from './road-stop.component';

describe('RoadStopComponent', () => {
  let component: RoadStopComponent;
  let fixture: ComponentFixture<RoadStopComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ RoadStopComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RoadStopComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
