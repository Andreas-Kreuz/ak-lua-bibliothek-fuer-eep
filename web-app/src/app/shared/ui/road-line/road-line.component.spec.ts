import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RoadLineComponent } from './road-line.component';

describe('RoadLineComponent', () => {
  let component: RoadLineComponent;
  let fixture: ComponentFixture<RoadLineComponent>;

  beforeEach(async(() => {
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
