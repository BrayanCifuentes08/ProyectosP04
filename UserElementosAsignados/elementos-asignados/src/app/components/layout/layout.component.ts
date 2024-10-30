import { Component, Inject, PLATFORM_ID } from '@angular/core';
import { HeaderComponent } from '../header/header.component';
import { SidebarComponent } from '../sidebar/sidebar.component';
import { FooterComponent } from '../footer/footer.component';
import { Router, RouterOutlet } from '@angular/router';

import { SharedService } from '../../services/shared.service';
import { isPlatformBrowser } from '@angular/common';
import InicioComponent from '../../inicio/inicio.component';

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [HeaderComponent, SidebarComponent, FooterComponent, RouterOutlet, InicioComponent],
  templateUrl: './layout.component.html',
  styleUrl: './layout.component.css'
})
export default class LayoutComponent {
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
    if (isPlatformBrowser(this.platformId)) {
      // Calcular la fecha de vencimiento del token solo si hay hora de inicio de sesión real
      if (localStorage.getItem('horaInicioSesion')) {
        this.calcularFechaVencimientoToken();
        this.verificarExpiracionToken();
      }
    
        window.addEventListener('beforeunload', this.limpiarSessionStorage.bind(this));
        this.verificarSesion();
      } else {
        this.router.navigate(['/login']);
      }
    this.sharedService.currentHeaderText.subscribe(text => {
      this.headerText = text || '';
    });
  }

  verificarSesion(): void {
    if (isPlatformBrowser(this.platformId)) {
        const jwtTokenLocal = localStorage.getItem('jwtToken');
        const jwtTokenSession = sessionStorage.getItem('jwtToken');

        // Verificar si hay un token
        if (!jwtTokenLocal && !jwtTokenSession) {
          //this.sharedService.hideLoading();
            this.router.navigate(['/login']);
            return;
        }

        // Verificar datos en localStorage
        const aplicacionGuardada = localStorage.getItem('aplicacion');
        const usuarioGuardado = localStorage.getItem('usuario');
        const estacionTrabajoGuardada = localStorage.getItem('estacionTrabajo');
        const empresaGuardada = localStorage.getItem('empresa');

        if (!aplicacionGuardada || !usuarioGuardado || !estacionTrabajoGuardada || !empresaGuardada) {
            //this.sharedService.hideLoading();
            this.router.navigate(['/login']);
        } else {

            console.log('Sesión activa con datos en localStorage.');
        }
    }
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
