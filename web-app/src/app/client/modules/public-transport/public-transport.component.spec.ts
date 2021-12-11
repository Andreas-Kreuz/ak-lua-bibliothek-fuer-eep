import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PublicTransportComponent } from './public-transport.component';

describe('PublicTransportComponent', () => {
  let component: PublicTransportComponent;
  let fixture: ComponentFixture<PublicTransportComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PublicTransportComponent ]
    })
    .compileComponents();
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
