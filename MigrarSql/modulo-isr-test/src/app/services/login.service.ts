import { isPlatformBrowser } from '@angular/common';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Inject, Injectable, PLATFORM_ID } from '@angular/core';
import { catchError, map, Observable, of } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class LoginService {
  //http://192.168.10.34:9094/api/
  private baseUrl:  string = '';
  private usuario:  string = ''
  private estacion: any = null;
  private empresa:  any = null;
  private aplicacion: any = null;
  
  constructor(private http: HttpClient,  @Inject(PLATFORM_ID) private platformId: object) {
           // Leer la URL desde localStorage o sessionStorage si está disponible
           const storedUrl = localStorage.getItem('urlApi') || sessionStorage.getItem('urlApi');
           if (storedUrl) {
             this.baseUrl = storedUrl;
           }
           console.log("URL en servicio de migrar: ", this.baseUrl);
   }

  private isBrowser(): boolean {
    return isPlatformBrowser(this.platformId);
  }

  setBaseUrl(url: string): void {
    this.baseUrl = url;
    localStorage.setItem('urlApi', this.baseUrl);  // Persistente en todas las sesiones
    sessionStorage.setItem('urlApi', this.baseUrl);  // Persistente solo durante la sesión actual
  }

  getBaseUrl(): string {
    return this.baseUrl;
  }

  private getHeaders(token: string): HttpHeaders {
    return new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    });
  }
  
   //TODO: Metodos para recibir y enviar datos de usuario y datos extra
  setUser(usuario: string): void {
    this.usuario = usuario;
    if (this.isBrowser()) {
      localStorage.setItem('usuario', usuario);
      sessionStorage.setItem('usuario', usuario);
    }

  }
  
  getUser(): string {
    if (!this.usuario && this.isBrowser()) {
      const storedUser = sessionStorage.getItem('usuario') || localStorage.getItem('usuario');
      this.usuario = storedUser !== null ? storedUser : ''; 
    }
    return this.usuario;
  }
  
  setEstacion(estacion: any): void {
    this.estacion = estacion;
    if (this.isBrowser()) {
      localStorage.setItem('estacion', JSON.stringify(estacion));
      sessionStorage.setItem('estacion', JSON.stringify(estacion));
    }
  }

  getEstacion(): { id: number | null, descripcion: string | null } {
    if (!this.estacion && this.isBrowser()) {
      const estacionFromStorage = localStorage.getItem('estacion') || sessionStorage.getItem('estacion');
      this.estacion = estacionFromStorage ? JSON.parse(estacionFromStorage) : null;
    }
    return this.estacion
      ? { id: this.estacion.estacion_Trabajo, descripcion: this.estacion.descripcion }
      : { id: null, descripcion: null };
  }

  setEmpresa(empresa: any): void {
    this.empresa = empresa;
    if (this.isBrowser()) {
      localStorage.setItem('empresa', JSON.stringify(empresa));
      sessionStorage.setItem('empresa', JSON.stringify(empresa));
    }
  }

  getEmpresa(): any {
    if (!this.empresa && this.isBrowser()) {
      const empresaFromStorage = localStorage.getItem('empresa') || sessionStorage.getItem('empresa');
      this.empresa = empresaFromStorage ? JSON.parse(empresaFromStorage) : null;
    }
    return this.empresa;
  }
  
  setAplicacion(aplicacion: any): void {
    this.aplicacion = aplicacion;
    if (this.isBrowser()) {
      localStorage.setItem('aplicacion', JSON.stringify(aplicacion));
      sessionStorage.setItem('aplicacion', JSON.stringify(aplicacion));
    }
  }

  getAplicacion(): any {
    if (!this.aplicacion && this.isBrowser()) {
      const aplicacionFromStorage = localStorage.getItem('aplicacion') || sessionStorage.getItem('aplicacion');
      this.aplicacion = aplicacionFromStorage ? JSON.parse(aplicacionFromStorage) : null;
    }
    return this.aplicacion ? this.aplicacion.application : null;
  }
  
  buscarUser2(model: any): Observable<any> {
    const url = `${this.baseUrl}PaBscUser2Ctrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, { params: model, headers })
      .pipe(
        map(response => response)
      );
  }

  buscarEstacionTrabajo(model: any): Observable<any> {
    const url = `${this.baseUrl}PaBscEstacionTrabajo2Ctrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, {params: model, headers})
      .pipe(
        map(response => response)
      );
  }

  buscarEmpresa(model: any): Observable<any> {
    const url = `${this.baseUrl}PaBscEmpresa1Ctrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, { params: model, headers })
      .pipe(
        map(response => response)
      );
  }

  buscarApplication(model: any): Observable<any> {
    const url = `${this.baseUrl}PaBscApplication1Ctrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, { params: model, headers })
      .pipe(
        map(response => response)
      );
  }

  buscarUserDisplay2(model: any): Observable<any> {
    const url = `${this.baseUrl}PaBscUserDisplay2Ctrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, { params: model, headers })
      .pipe(
        map(response => response)
      );
  }

  verificarBaseUrl(urlApi: string): Observable<boolean> {
    const url = `${urlApi}VerificarUrlCtrl/estado`;
    return this.http.get(url, {responseType: 'text' }).pipe(
      map(response => true), // Si responde, la URL es valida
      catchError(error => {
        console.error('Error verificando URL:', error);
        return of(false); // En caso de error, retorna false
      })
    );
  }
}