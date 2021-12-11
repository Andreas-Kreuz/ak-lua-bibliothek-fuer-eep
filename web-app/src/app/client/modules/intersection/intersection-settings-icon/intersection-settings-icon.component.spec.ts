import { ComponentFixture, TestBed } from '@angular/core/testing';

import { IntersectionSettingsIconComponent } from './intersection-settings-icon.component';

describe('IntersectionSettingsIconComponent', () => {
  let component: IntersectionSettingsIconComponent;
  let fixture: ComponentFixture<IntersectionSettingsIconComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ IntersectionSettingsIconComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(IntersectionSettingsIconComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
