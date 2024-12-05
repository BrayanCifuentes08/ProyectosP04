import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { map, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MigrarSqlService {
  private baseUrl:  string = 'http://192.168.10.43:9094/api/';
  constructor(private http: HttpClient) { }
  
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


}
