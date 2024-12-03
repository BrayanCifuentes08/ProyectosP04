import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, map, Observable, of } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private baseUrl = 'http://192.168.10.39:9091/api/'; // URL base de la API
  private usuario: string = ''
  private estacion: any = null;
  private empresa: any = null;
  
  constructor(private http: HttpClient) { }

  obtenerHojasExcel(archivo: File): Observable<string[]> {
    const url = `${this.baseUrl}Ctrl_ObtenerHojasExcel`;
    
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    
    const formData = new FormData();
    formData.append('archivoExcel', archivo);
    
    console.log(headers)
    return this.http.post<string[]>(url, formData , {headers} )
      .pipe(
        map(response => response)
      );
  }

  enviarDatosExcel(model: any): Observable<any> {
    const url = `${this.baseUrl}PaTblDocumentoEstructuraCtrl`;
    const formData = new FormData();
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    if (model.archivo) {
      formData.append('ArchivoExcel', model.archivo, model.archivo.name);
    }
    formData.append('NombreHojaExcel', model.nombreHoja);
    formData.append('TAccion', model.tAccion.toString());
    formData.append('TOpcion', model.tOpcion.toString());
    formData.append('pUserName', model.pUserName);
    formData.append('pConsecutivo_Interno', model.pConsecutivoInterno.toString());
    formData.append('pTipo_Estructura', model.pTipoEstructura.toString());
    formData.append('pEstado', model.pEstado.toString());
  
    return this.http.post<any>(url, formData, {headers});
  }

  setBaseUrl(url: string): void {
    this.baseUrl = url;
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
    localStorage.setItem('usuario', usuario);
  }
  
  getUser(): string {
    if (!this.usuario) {
      const storedUser = localStorage.getItem('usuario');
      this.usuario = storedUser !== null ? storedUser : ''; 
    }
    return this.usuario;
  }
  
  setEstacion(estacion: any): void {
    this.estacion = estacion;
    localStorage.setItem('estacion', JSON.stringify(estacion));
  }
  
  getEstacion(): { id: number | null, descripcion: string | null } {
    if (!this.estacion) {
      const estacionFromStorage = localStorage.getItem('estacion');
      this.estacion = estacionFromStorage ? JSON.parse(estacionFromStorage) : null;
    }
    // Retornar un objeto con el ID y la descripción
    return this.estacion ? { id: this.estacion.estacion_Trabajo, descripcion: this.estacion.descripcion } : { id: null, descripcion: null };
  }
  

  setEmpresa(empresa: any): void {
    this.empresa = empresa;
    localStorage.setItem('empresa', JSON.stringify(empresa));
  }
  
  getEmpresa(): number {
    if (!this.empresa) {
      const empresaFromStorage = localStorage.getItem('empresa');
      this.empresa = empresaFromStorage ? JSON.parse(empresaFromStorage) : null;
    }
    return this.empresa ? this.empresa.empresa : null;
  }

  getTipoCanalDistribucion(model: any): Observable<any> {
    const url = `${this.baseUrl}PaBscTipoCanalDistribucionCtrl`;
    const params = new HttpParams({ fromObject: model });
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    
    // Realizar la solicitud GET con los parámetros y encabezados
    return this.http.get<any>(url, { params, headers });
  }

  getCanalDistribucion(model: any): Observable<any> {
      const url = `${this.baseUrl}PaBscCanalDistribucionCtrl`;
      const params = new HttpParams({ fromObject: model });
      const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
      const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
      
      // Realizar la solicitud GET con los parámetros y encabezados
      return this.http.get<any>(url, { params, headers });
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
