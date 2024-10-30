import { BootstrapOptions, Component, Inject, PLATFORM_ID } from '@angular/core';

import { AsignadorComponent } from "../asignador/asignador.component";
import { DesasignadorComponent } from "../desasignador/desasignador.component";
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { MessagesComponent } from "../../messages/messages.component";
import { SharedService } from '../../services/shared.service';
import InicioComponent from '../../inicio/inicio.component';
import { Router } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { UserElementoAsignadoM } from '../../models/user-elemento-asignado';


@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [InicioComponent, AsignadorComponent, DesasignadorComponent, CommonModule, MessagesComponent],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export default class DashboardComponent {
  mostrarAsignador: boolean = false;
  mostrarDesasignador: boolean = false;
  mostrarInicio: boolean = true;
  headerText: string = 'Inicio';
  isVisibleExito: boolean = false;
  mensajeExito: string = ''; 
  isVisibleAlerta: boolean = false;
  mensajeAlerta: string = ''; 
  usuario: string =''
  horaInicioSesionFormatted: string | null = null;
  fechaVencimientoToken: string | null = null;
  usandoHoraPerma: boolean = false;
  tooltipVisible: boolean = false;
  tiempoRestante: string = '';
  tieneElementos: boolean = false; 
  elementosAsignadosInicio: UserElementoAsignadoM[] = [];

  constructor(private router: Router, private sharedService: SharedService,private apiService: ApiService,@Inject(PLATFORM_ID) private platformId: Object ){

  }

  ngOnInit(){
    this.sharedService.userElementosAsignados$.subscribe((elementos) => {
      this.elementosAsignadosInicio = elementos;
      this.tieneElementos = elementos.length > 0;;
    });
    if (isPlatformBrowser(this.platformId)) {
      // Recuperar valores del localStorage
      //!  SI EN CASO SE LLEGARA A USAR O NECESITAR
      // this.horaInicioSesionFormatted = localStorage.getItem('horaInicioSesionFormatted');
      // this.fechaVencimientoToken = localStorage.getItem('fechaVencimientoToken');
      // this.usuario = this.apiService.getUser();

      // const horaInicioSesionLocal = localStorage.getItem('horaInicioSesion');
      // this.usandoHoraPerma = !!horaInicioSesionLocal; 
  
      // Obtener los datos de localStorage y sessionStorage
      const estacionTrabajo = JSON.parse(localStorage.getItem('estacionTrabajo') || '{}');
      const empresa = JSON.parse(localStorage.getItem('empresa') || '{}');
      const aplicacion = JSON.parse(localStorage.getItem('aplicacion') || '{}');
      const display = JSON.parse(localStorage.getItem('display') || '{}');
  
      // Verificar si los datos estan en localStorage
      const datosEnLocalStorage = estacionTrabajo && empresa && aplicacion && display;
  
      // Si los datos no estan en localStorage
      if (!datosEnLocalStorage) {
        const datosEnSessionStorage = sessionStorage.getItem('estacionTrabajo') ||
                                      sessionStorage.getItem('empresa') ||
                                      sessionStorage.getItem('aplicacion') ||
                                      sessionStorage.getItem('display');
  
        if (datosEnSessionStorage) {
          // Si hay datos en sessionStorage, redirigir al login
          this.limpiarSessionStorageYRedirigir();
        } else {
          // Si no hay datos en ninguno, redirigir al login
          this.router.navigate(['/login']);
        }
      } else {
        this.router.navigate(['/dashboard']);
      }
    }
  }

  asignarElemento() {
    if (this.mostrarAsignador) {
      this.volverInicio();
    } else {
      this.mostrarAsignador = true;
      this.mostrarDesasignador = false;
      this.mostrarInicio = false;
      this.sharedService.changeHeaderText('Asignar');
    }
  }

  desasignarElemento() {
    if (this.mostrarDesasignador) {
      this.volverInicio();
    } else {
      this.mostrarDesasignador = true;
      this.mostrarAsignador = false;
      this.mostrarInicio = false;
      this.sharedService.changeHeaderText('Desasignar');
    }
  }

  manejarMensajeExito(mensaje: string): void {
    this.mensajeExito = mensaje;
    this.isVisibleExito = true;

    setTimeout(() => {
      this.ocultarExito();
    }, 5000);
  }

  manejarMensajeError(mensaje: string): void {
    this.mensajeAlerta = mensaje;
    this.isVisibleAlerta = true;
    setTimeout(() => {
      this.ocultarAlerta();
    }, 5000);
  }

  ocultarExito(): void {
    this.isVisibleExito = false;
  }

  ocultarAlerta(): void {
    this.isVisibleAlerta = false;
  }

  volverInicio(): void {
    this.mostrarAsignador = false;
    this.mostrarDesasignador = false;
    this.mostrarInicio = true;
    this.sharedService.changeHeaderText('Inicio');
  }

  limpiarSessionStorageYRedirigir(): void {
    sessionStorage.clear(); 
    console.log('sessionStorage limpiado');
    this.router.navigate(['/login']); 
  }

  logout(): void {
    sessionStorage.clear()
    localStorage.clear()
    this.router.navigate(['/login']); // Redirige al login
  }

  eliminarDatos(claves: string[]): void {
      claves.forEach((clave) => {
          localStorage.removeItem(clave);
          sessionStorage.removeItem(clave);
      });
  }

}
