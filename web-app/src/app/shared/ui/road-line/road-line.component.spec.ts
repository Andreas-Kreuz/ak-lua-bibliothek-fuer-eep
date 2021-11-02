import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { RoadLineComponent } from './road-line.component';

describe('RoadLineComponent', () => {
  let component: RoadLineComponent;
  let fixture: ComponentFixture<RoadLineComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ RoadLineComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RoadLineComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
