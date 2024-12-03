import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MigrarSqlService {
  private baseUrl:  string = 'http://192.168.10.39:9098/api/';
  constructor(private http: HttpClient) { }

  getTipoCanalDistribucion(model: any): Observable<any> {
    const url = `${this.baseUrl}PaCrudTipoCanalDistribucionCtrl`;
    const params = new HttpParams({ fromObject: model });
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    
    // Realizar la solicitud GET con los parámetros y encabezados
    return this.http.get<any>(url, { params, headers });
  }

  getCanalDistribucion(model: any): Observable<any> {
      const url = `${this.baseUrl}PaCrudCanalDistribucionCtrl`;
      const params = new HttpParams({ fromObject: model });
      const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
      const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
      
      // Realizar la solicitud GET con los parámetros y encabezados
      return this.http.get<any>(url, { params, headers });
  }

  getElementosAsignados(model: any): Observable<any> {
    const url = `${this.baseUrl}PaCrudElementoAsignadoCtrl`;
    const params = new HttpParams({ fromObject: model });
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    
    // Realizar la solicitud GET con los parámetros y encabezados
    return this.http.get<any>(url, { params, headers });
  }

  getCatalogoUser(model: any): Observable<any> {
    const url = `${this.baseUrl}PaCrudUserCtrl`;
    const params = new HttpParams({ fromObject: model });
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    
    // Realizar la solicitud GET con los parámetros y encabezados
    return this.http.get<any>(url, { params, headers });
  }
}
