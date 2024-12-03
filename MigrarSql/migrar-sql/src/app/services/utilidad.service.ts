import { Inject, Injectable, PLATFORM_ID } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { LoginService } from './login.service';
import { TraduccionService } from './traduccion.service';

@Injectable({
  providedIn: 'root'
})
export class UtilidadService {
  private cargaSubject = new BehaviorSubject<boolean>(false);
  public carga$ = this.cargaSubject.asObservable();
  private darkModeKey = 'darkMode';
  private baseUrl: string = '';
  public colorSeleccionado: string = '';
  private esModoOscuro: boolean = false;
  constructor(@Inject(PLATFORM_ID) private platformId: Object, private loginService: LoginService,
  private idiomaService: TraduccionService ) {
    this.baseUrl = this.loginService.getBaseUrl();
  }

  getUrlService(): string {
    return this.baseUrl;
  }

  setUrlService(newUrl: string): void {
    this.baseUrl = newUrl;
    this.loginService.setBaseUrl(this.baseUrl);
    console.log(`URL API actualizada a: ${this.baseUrl}`);
  }

  formatearFecha(fechaString: string): string {
    if (!fechaString) return ''; //Manejo de casos donde la fecha es nula o indefinida

    const fecha = new Date(fechaString);
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const año = fecha.getFullYear();
    
    return `${dia}/${mes}/${año}`;
  }

  formatFechaCompleta(fecha: Date): string {
    const opciones: Intl.DateTimeFormatOptions = {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
    };
    return new Date(fecha).toLocaleString('es-ES', opciones);
  }

  formatearNumeros(valor: number): string {
    return valor.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
  }
}
