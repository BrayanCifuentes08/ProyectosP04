import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class SessionService {
  private sessionExpiredSubject = new BehaviorSubject<boolean>(false);
  constructor(public router: Router) {}


  get sessionExpired$() {
    return this.sessionExpiredSubject.asObservable();
  }

  verificarSesion(): void {
    const guardarSesion = localStorage.getItem('guardarDatosSesion') === 'true';
    const datosLocal = this.obtenerDatos(localStorage);
    const datosSession = this.obtenerDatos(sessionStorage);

    if (guardarSesion && this.datosValidos(datosLocal)) {
      // Sesión persistente: No hacer nada, los datos están en localStorage
      return;
    } else if (!guardarSesion && this.datosValidos(datosSession)) {
      // Sesión temporal: Redirigir al login si se reinició la app
      this.router.navigate(['/login']);
    } else {
      // Sin datos válidos: Redirigir al login
      this.router.navigate(['/login']);
    }
  }

  obtenerDatos(storage: Storage): any {
    return {
      estacionTrabajo: JSON.parse(storage.getItem('estacionTrabajo') || '{}'),
      empresa: JSON.parse(storage.getItem('empresa') || '{}'),
      aplicacion: JSON.parse(storage.getItem('aplicacion') || '{}'),
      display: JSON.parse(storage.getItem('display') || '{}'),
      jwtToken: storage.getItem('jwtToken') || ''
    };
  }

  datosValidos(datos: any): boolean {
    // Verifica que todos los datos necesarios estén presentes y sean válidos
    return datos.estacionTrabajo && datos.empresa && datos.aplicacion && datos.display && datos.jwtToken;
  }

  limpiarDatos(): void {
    localStorage.clear();
    sessionStorage.clear();
  }

  cerrarSesion(): void {
    this.limpiarDatos(); // Limpiar datos de sesión
    this.router.navigate(['/login']); // Redirigir al login
  }

  manejarError401(): void {
    this.sessionExpiredSubject.next(true); // Notificar que la sesión expiró
    this.limpiarDatos(); // Limpiar todos los datos de sesión
  }
  

}
