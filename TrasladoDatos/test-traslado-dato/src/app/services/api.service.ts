import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { map, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = 'http://192.168.10.39:9091/api/'; // URL base de la API
  constructor(private http: HttpClient) { }

  obtenerHojasExcel(archivo: File): Observable<string[]> {
    const url = `${this.apiUrl}Ctrl_ObtenerHojasExcel`;
    
    // const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    // const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    
    const formData = new FormData();
    formData.append('archivoExcel', archivo);
  
    return this.http.post<string[]>(url, formData /*, { headers }*/)
      .pipe(
        map(response => response)
      );
  }
  
}
