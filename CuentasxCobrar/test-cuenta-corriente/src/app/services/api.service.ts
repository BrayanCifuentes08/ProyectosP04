import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { BehaviorSubject, Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { ParametrosTipoDocumento } from '../models/tipo-documento';
import { PaBscUser2M, ParametrosLogin } from '../models/login';

@Injectable({
  providedIn: 'root'
})
export class ApiService {

  private baseUrl: string = 'http://192.168.1.25/ApiCuentaCorriente/api/';
  private clienteSeleccionadoSubject: BehaviorSubject<any> = new BehaviorSubject<any>(null);
  public clienteSeleccionado$: Observable<any> = this.clienteSeleccionadoSubject.asObservable();
  private datosReciboSubject: BehaviorSubject<any> = new BehaviorSubject<any>(null);
  public datosRecibo$:Observable<any> = this.clienteSeleccionadoSubject.asObservable();
  private _montosAplicados: any;
  private _montosAplicadosAcumulados: any;
  private _documentosSeleccionados: any;
  private _documentosSeleccionadosAcumulados: any;
  private user: string = ''
  private estacion: any = null;
  private empresa: any = null;

  constructor(private http: HttpClient) { }

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

  //TODO: Metodos para datos de Cliente Seleccionado
  setClienteSeleccionado(cliente: any): void {
    this.clienteSeleccionadoSubject.next(cliente);
  }

  //TODO: Metodos para recibir y enviar datos de Cliente Seleccionado
  setUser(user: string): void {
    this.user = user;
    localStorage.setItem('user', user);
  }
  
  getUser(): string {
    if (!this.user) {
      const storedUser = localStorage.getItem('user');
      this.user = storedUser !== null ? storedUser : ''; 
    }
    return this.user;
  }
  
  setEstacion(estacion: any): void {
    this.estacion = estacion;
    localStorage.setItem('estacion', JSON.stringify(estacion));
  }
  
  public getEstacion(): number {
    if (!this.estacion) {
      const estacionFromStorage = localStorage.getItem('estacion');
      this.estacion = estacionFromStorage ? JSON.parse(estacionFromStorage) : null;
    }
    return this.estacion ? this.estacion.estacion_Trabajo : null;
  }
  
  setEmpresa(empresa: any): void {
    this.empresa = empresa;
    localStorage.setItem('empresa', JSON.stringify(empresa));
  }
  
  public getEmpresa(): number {
    if (!this.empresa) {
      const empresaFromStorage = localStorage.getItem('empresa');
      this.empresa = empresaFromStorage ? JSON.parse(empresaFromStorage) : null;
    }
    return this.empresa ? this.empresa.empresa : null;
  }

  //TODO:Metodos para establecer los datos del recibo
  setDatosRecibo(datos: any): void {
    this.datosReciboSubject.next(datos);
    console.log("Datos recibidos en (Service); ",datos)
  }
  
  getDatosRecibo(): Observable<any> {
    return this.datosReciboSubject.asObservable();
  }

  //TODO: Metodos para establecer los datos de los montos modificados
  getMontosAplicados(): any {
    return this._montosAplicados;
  }

  getMontosAplicadosAcumulados(): any {
    return this._montosAplicadosAcumulados;
  }

  setMontosAplicados(montosAplicados: any, montosAplicadosAcumulados: any): void {
    this._montosAplicados = montosAplicados;
    this._montosAplicadosAcumulados = montosAplicadosAcumulados;
  }

  //TODO: Metodos para establecer los datos de documentos seleccionados
  getDocumentosSeleccionados(): any {
    return this._documentosSeleccionados;
  }

  getDocumentosSeleccionadosAcumulados():any{
    return this._documentosSeleccionadosAcumulados
  }
  
  setDocumentosSeleccionados(documentosSeleccionados: any, documentosSeleccionadosAcumulados: any): void {
    this._documentosSeleccionados = documentosSeleccionados;
    this._documentosSeleccionadosAcumulados = documentosSeleccionadosAcumulados;
  }

  //TODO: Metodos para realizar peticion de busqueda de Clientes
  public buscarClientes(pUserName: string, pCriterioBusqueda: string, pEmpresa: number): Observable<any> {
    const url = `${this.baseUrl}PaBscCuentaCorrentistaMovilCtrl`;
    const params = {
      pUserName: pUserName,
      pCriterio_Busqueda: pCriterioBusqueda,
      pEmpresa: pEmpresa  
    };
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, { params, headers })
    .pipe(
      map(response => response)
    );
  }

  //TODO: Metodos GET para recibir datos
  getCuentaCorriente(model: any): Observable<any> {
    const url = `${this.baseUrl}PaBscCuentaCorriente1Ctrl`; //Se pasa el nombre del controlador para concatenarlo con la url
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, { params: model, headers })
      .pipe(
        map(response => response)
      );
  }
  
  getTipoDocumento(parametros: ParametrosTipoDocumento): Observable<any> {
    const url = `${this.baseUrl}PaBscTipoDocumentoMovilCtrl`;
    let httpParams = new HttpParams()
      .set('pUserName',             parametros.pUserName)
      .set('pOpc_Cuenta_Corriente', parametros.pOpc_Cuenta_Corriente ? '1' : '0')
      .set('pCuenta_Corriente',     parametros.pCuenta_Corriente ? '1' : '0')
      .set('pEmpresa',              parametros.pEmpresa.toString())
      .set('pIngreso',              parametros.pIngreso ? '1' : '0')
      .set('pCosto',                parametros.pCosto ? '1' : '0');

      const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
      const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
  
      return this.http.get<any>(url, { params: httpParams, headers })
        .pipe(
          map(response => response)
        );
  }

  getSerieDocumento(model: any): Observable<any> {
    const url = `${this.baseUrl}PaBscSerieDocumento1Ctrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
  
  return this.http.get<any>(url, { params: model, headers })
    .pipe(
      map(response => response)
    );
  }

  getTiposDePago(model: any): Observable<any> {
    const url = `${this.baseUrl}PaBscTipoCargoAbono1Ctrl`;
    //Crear los parámetros de la consulta
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, { params: model, headers })
    .pipe(
      map(response => response)
    );
  }

  getVerBancos(model: any): Observable<any>{
    const url = `${this.baseUrl}PaBscBanco1Ctrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, { params: model, headers })
    .pipe(
      map(response => response)
    );
  }

  getCuentaBancaria(model: any): Observable<any>{
    const url = `${this.baseUrl}PaBscCuentaBancaria1Ctrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, { params: model, headers })
    .pipe(
      map(response => response)
    );
  }
  
  getDocumentoValidar(model: any): Observable<any>{
    const url = `${this.baseUrl}PaDocumentoValidar1Ctrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, { params: model, headers })
    .pipe(
      map(response => response)
    );
  }

  getValidarCargoAbono(model: any): Observable<any> {
    const url = `${this.baseUrl}PaCargoAbonoValidar1Ctrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get<any>(url, { params: model, headers })  
      .pipe(
        map(response => response)
      );
  }

  crearCargoAbono(model: any): Observable<any> {
    const url = `${this.baseUrl}PaTblCargoAbonoCtrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.post<any>(url, model, { headers })
      .pipe(
        map(response => response)
      );
  }

  //TODO: Metodos POST para crear Encabezado
  crearEncabezado(model: any): Observable<any> {
    const url = `${this.baseUrl}PaTblDocumentoCtrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.post<any>(url, model, { headers })
      .pipe(
        map(response => response)
      );
  }

  documentoAplicar(model: any): Observable<any> {
    const url = `${this.baseUrl}PaDocumentoAplicar31Ctrl`;
    const token = sessionStorage.getItem('jwtToken') || localStorage.getItem('jwtToken');
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.post<any>(url, model, {headers})
      .pipe(
        map(response => response)
      );
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
