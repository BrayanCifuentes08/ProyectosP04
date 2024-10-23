import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DesasignadorComponent } from './desasignador.component';

describe('DesasignadorComponent', () => {
  let component: DesasignadorComponent;
  let fixture: ComponentFixture<DesasignadorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DesasignadorComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(DesasignadorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
