import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AsignadorComponent } from './asignador.component';

describe('AsignadorComponent', () => {
  let component: AsignadorComponent;
  let fixture: ComponentFixture<AsignadorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AsignadorComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AsignadorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
