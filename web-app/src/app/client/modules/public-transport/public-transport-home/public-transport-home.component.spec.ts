import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PublicTransportHomeComponent } from './public-transport-home.component';

describe('PublicTransportHomeComponent', () => {
  let component: PublicTransportHomeComponent;
  let fixture: ComponentFixture<PublicTransportHomeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PublicTransportHomeComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PublicTransportHomeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
