import { isPlatformBrowser } from '@angular/common';
import { Component, Inject, PLATFORM_ID } from '@angular/core';
import { Router } from '@angular/router';
import { SharedService } from '../../services/shared.service';

@Component({
  selector: 'app-layout',
  template: `
  <div class="min-h-screen bg-gray-50/50 dark:bg-gray-800">
    <app-sidebar></app-sidebar>
    <div class="p-4 xl:ml-80">
      <nav class="w-full">
        <app-header></app-header>
      </nav>
      <div class="mt-12">
        <router-outlet></router-outlet>
      </div>
      <div class="text-blue-gray-600">
        <app-footer></app-footer>
      </div>
    </div>
  </div>
`,
styleUrls: ['./layout.component.css'],
})
export class LayoutComponent {
  headerText: string = ''; 
  isLoading: boolean = true;
  opcionSeleccionadaSidebarEstado = false;
  opcionSeleccionadaSidebar: string | null = null; 
  private intervalId: any;
  fechaVencimientoToken:       string | null = null;
  horaInicioSesionFormatted:   string | null = null;
  horaInicioSesion:            number | null = null;
    
  constructor(
    private router: Router,
    private sharedService: SharedService,
    @Inject(PLATFORM_ID) private platformId: Object
  ) {
    if (isPlatformBrowser(this.platformId)) {
      // Obtener la hora de inicio de sesión
      let horaInicioSesionLocal = localStorage.getItem('horaInicioSesion');
      
      // Si es null o no válida, establecer la hora actual como hora temporal
      if (!horaInicioSesionLocal || horaInicioSesionLocal === '0') {
        const currentTime = new Date().getTime();
        sessionStorage.setItem('horaInicioSesionTemp', currentTime.toString());
        this.horaInicioSesion = currentTime; // Esta es la hora temporal
      } else {
        this.horaInicioSesion = Number(horaInicioSesionLocal); // Esta es la hora real de sesión
      }
  
      this.horaInicioSesionFormatted = this.formatDate(this.horaInicioSesion);
      localStorage.setItem('horaInicioSesionFormatted', this.horaInicioSesionFormatted);
    }
  }

  ngOnInit() {
  }


  limpiarSessionStorage(): void {
      sessionStorage.clear();
  }
  
  formatDate(timestamp: number): string {
    const date = new Date(timestamp);
    return date.toLocaleString();
  }

  calcularFechaVencimientoToken() {
    if (this.horaInicioSesion !== null) {
      const horaInicioSesionDate = new Date(this.horaInicioSesion);
      const vencimiento = new Date(horaInicioSesionDate.getTime() + 24 * 60 * 60 * 1000); // Suma 24 horas
      this.fechaVencimientoToken = vencimiento.toLocaleString();
      console.log("Hora cierre sesion", this.fechaVencimientoToken)
       localStorage.setItem('fechaVencimientoToken', this.fechaVencimientoToken);
    }
  }

  verificarExpiracionToken() {
    this.intervalId = setInterval(() => {
      if (this.horaInicioSesion !== null) { // Verificar que no sea null
        const currentTime = new Date().getTime();
        const tokenExpiryTime = new Date(this.horaInicioSesion).getTime() + 24 * 60 * 60 * 1000; // Tiempo de expiración del token en 1 día (24 horas)

        if (currentTime >= tokenExpiryTime) {
          console.log('Token expirado. Cerrar sesión.');
          this.logOut();
          clearInterval(this.intervalId); 
        }
      } else {
        console.warn('No hay una hora de inicio de sesión registrada.');
        clearInterval(this.intervalId); 
      }
    }, 1000);
  }

  logOut(){
    localStorage.clear();
    sessionStorage.clear();
  }
}