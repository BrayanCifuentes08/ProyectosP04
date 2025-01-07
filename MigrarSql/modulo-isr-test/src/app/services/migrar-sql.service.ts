import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { map, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MigrarSqlService {
  private baseUrl:  string = '';
  constructor(private http: HttpClient) { 
       // Leer la URL desde localStorage o sessionStorage si está disponible
       const storedUrl = localStorage.getItem('urlApi') || sessionStorage.getItem('urlApi');
       if (storedUrl) {
         this.baseUrl = storedUrl;
       }
       console.log("URL en servicio de migrar: ", this.baseUrl);
  }

  getBaseUrl(): string {
    return this.baseUrl;
  }

  // Método para actualizar la URL
  setBaseUrl(url: string): void {
    this.baseUrl = url;
    console.log(`URL de MigrarSqlService actualizada a: ${this.baseUrl}`);
    localStorage.setItem('urlApi', this.baseUrl);  // Persistente en todas las sesiones
    sessionStorage.setItem('urlApi', this.baseUrl);  // Persistente solo durante la sesión actual
  }
  
  obtenerHojasExcel(archivo: File): Observable<string[]> {
    const url = `${this.baseUrl}ObtenerHojasExcelCtrl`;
    
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    
    const formData = new FormData();
    formData.append('archivoExcel', archivo);
  
    return this.http.post<string[]>(url, formData , {headers} )
      .pipe(
        map(response => response)
      );
  }


  enviarDatos(formData: FormData): Observable<any> {
    const url = `${this.baseUrl}SqlAExcelCtrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.post(url, formData, { 
      headers, 
      responseType: 'blob'
    });
  }



}

