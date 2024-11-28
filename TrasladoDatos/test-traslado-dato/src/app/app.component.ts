import { Component, Inject, PLATFORM_ID } from '@angular/core';
import { Router, RouterOutlet } from '@angular/router';

import { MenuComponent } from "./components/menu/menu.component";
import LayoutComponent from './components/layout/layout.component';
import { SharedService } from './services/shared.service';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import LoadingScreenComponent from "./components/loading-screen/loading-screen.component";


@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, LoadingScreenComponent, CommonModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'test-traslado-dato';
  loading: boolean = true;
  constructor(public sharedService: SharedService, private router: Router,     @Inject(PLATFORM_ID) private platformId: Object){}

  ngOnInit(): void {
    this.mostrarLoadingScreen();
  }

  mostrarLoadingScreen() {
    if (isPlatformBrowser(this.platformId)) {
      setTimeout(() => {
        const datosGuardados = localStorage.getItem('user') &&
                              localStorage.getItem('pass') &&
                              localStorage.getItem('estacionTrabajo') &&
                              localStorage.getItem('empresa') &&
                              localStorage.getItem('aplicacion') &&
                              localStorage.getItem('display') &&
                              localStorage.getItem('jwtToken');

        if (datosGuardados) {
          this.router.navigate(['/trasladoDatos']).then(() => {
            this.esconderLoadingScreen();
          });
        } else {
          this.router.navigate(['/login']).then(() => {
            this.esconderLoadingScreen();
          });
        }
      }, 4000); // 4 segundos
    }
  }
  
  esconderLoadingScreen() {
    const loadingScreen = document.querySelector('.loading-screen') as HTMLElement;
    if (loadingScreen) {
      loadingScreen.classList.add('hidden');
    }

    setTimeout(() => {
      this.loading = false; // Oculta la pantalla de carga
    }, 500); // Coincide con la duración de la transición
  }
}
