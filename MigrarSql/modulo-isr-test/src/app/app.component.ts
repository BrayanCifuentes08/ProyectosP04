import { Component, Inject, PLATFORM_ID } from '@angular/core';
import { SharedService } from './services/shared.service';
import { Router } from '@angular/router';
import { SessionService } from './services/session.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'migrar-sql';
  loading: boolean = false;
  constructor(
    public sharedService: SharedService,
    private router: Router,
    @Inject(PLATFORM_ID) private platformId: Object,
    private sessionService: SessionService,
  ) {}

   ngOnInit(): void {
    // Verificar la sesión al cargar la aplicación
    this.sessionService.verificarSesion();
  }
}
