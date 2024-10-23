import { CommonModule, isPlatformBrowser } from '@angular/common';
import { Component, Inject, PLATFORM_ID, SimpleChanges } from '@angular/core';
import {
  NavigationEnd,
  Router,
  RouterLink,
  RouterOutlet,
} from '@angular/router';
import { TablaComponent } from './tablaCliente/tablaCliente.component';
import { CreacionReciboComponent } from './creacionRecibo/creacionRecibo.component';
import { FormsModule } from '@angular/forms';
import { TablaDocsPendientesComponent } from './tablaDocsPendientesPago/tablaDocsPendientesPago.component';
import { TranslateModule } from '@ngx-translate/core';
import { LoadingScreenComponent } from "./loading-screen/loading-screen.component";
import { LoginComponent } from "./login/login.component";
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { RECAPTCHA_V3_SITE_KEY, RecaptchaModule } from 'ng-recaptcha';
import { RecaptchaService } from './services/recaptcha.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    RouterOutlet,
    RouterLink,
    CommonModule,
    TablaComponent,
    CreacionReciboComponent,
    TablaDocsPendientesComponent,
    FormsModule,
    TranslateModule,
    LoadingScreenComponent,
    LoginComponent,
    RecaptchaModule,
],

  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
})
export class AppComponent {
  title = 'test-cuenta-corriente';
  loading = true;
  
  constructor(private router: Router, @Inject(PLATFORM_ID) private platformId: Object) {
    
  }

  ngOnInit(): void {
    if (isPlatformBrowser(this.platformId)) {
      this.mostrarLoadingScreen();
    }
  }
  
  mostrarLoadingScreen() {
    setTimeout(() => {
      // Verifica si hay datos de sesión guardados
      const datosGuardados = localStorage.getItem('user')  && 
                            localStorage.getItem('pass') &&
                            localStorage.getItem('estacionTrabajo') &&
                            localStorage.getItem('empresa') &&
                            localStorage.getItem('aplicacion') &&
                            localStorage.getItem('display') &&
                            localStorage.getItem('jwtToken');

      if (datosGuardados) {
        // Redirige al componente de inicio si hay datos guardados
        this.router.navigate(['/inicio']).then(() => {
          this.esconderLoadingScreen();
        });
      } else {
        // Redirige al login si no hay datos guardados
        this.router.navigate(['/login']).then(() => {
          this.esconderLoadingScreen();
        });
      }
    }, 4000); //4000 milisegundos = 4 segundos
  }

  esconderLoadingScreen() {
    if (isPlatformBrowser(this.platformId)) {
      setTimeout(() => {
        const loadingScreen = document.querySelector('.loading-screen') as HTMLElement;
        if (loadingScreen) {
          loadingScreen.classList.add('hidden');
        }
        // Después de la transición, establece loading en false
        setTimeout(() => {
          this.loading = false;
        }, 300); // Tiempo debe coincidir con la duración de la transición
      }, 0);
    }
  }
}
