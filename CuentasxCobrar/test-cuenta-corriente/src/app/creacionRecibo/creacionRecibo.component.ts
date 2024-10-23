import { CommonModule } from '@angular/common';
import { Component, ElementRef, HostListener, Input, OnInit, ViewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../services/api.service';
import { PaBscTipoDocumentoMovilM, ParametrosTipoDocumento } from '../models/tipo-documento';
import { PaBscSerieDocumento1M, ParametrosSerieDocumento } from '../models/serie-documento';
import { PaBscTipoCargoAbono1M } from '../models/tipo-pago';
import { PaBscCuentaBancaria1M, ParametrosCuentaBancaria } from '../models/cuenta-bancaria';
import { PaBscBanco1M } from '../models/banco';
import { PaDocumentoValidar1M } from '../models/validar-documento';
import { PaTblDocumentoM  } from '../models/encabezado-documento';
import { PaCargoAbonoValidar1M } from '../models/validar-cargo-abono';
import { PaTblCargoAbonoM } from '../models/cargo-abono';
import { ImprimirDocumentoComponent } from '../imprimirDocumento/imprimirDocumento.component';
import { PaBscCuentaCorriente1M } from '../models/docPendientes';
import { MensajeAdvertenciaComponent } from '../mensajeAdvertencia/mensajeAdvertencia.component';
import { LoadingComponent } from "../loading/loading.component";
import { LangChangeEvent, TranslateModule, TranslateService } from '@ngx-translate/core';
import { catchError, EmptyError, forkJoin, map, Observable, of } from 'rxjs';
import { RecaptchaService } from '../services/recaptcha.service';
import { TraduccionService } from '../services/traduccion.service';

@Component({
  selector: 'app-creacion-recibo',
  standalone: true,
  imports: [FormsModule, CommonModule, MensajeAdvertenciaComponent, LoadingComponent, TranslateModule],
  templateUrl: './creacionRecibo.component.html',
  styleUrl: './creacionRecibo.component.css',
  providers: [ImprimirDocumentoComponent]
})
export class CreacionReciboComponent implements OnInit{
  bancosHabilitados:            boolean = false;
  referenciaHabilitada:         boolean = false;
  mostrarInputFecha:            boolean = false;
  mostrarAutorizacion:          boolean = false;
  mostrarBloquearDoc:           boolean = false;
  mostrarBotonesAcciones:       boolean = false;
  mostrarBotonCxC:              boolean = false;
  mostrarBotonHuerfano:         boolean = false;
  mostrarTarjetaCuentas:        boolean = false;
  mostrarTablaCargoAbono:       boolean = false;
  resultadoValidar:             boolean | null = null;
  mostrarMensajeConfirmacion:   boolean = false;
  mostrarMensajeConfirmarOtroCAA: boolean = false;
  mostrarMensajeImprimir:         boolean = false;
  mostrarMensajeConfirmacioncargoAbono: boolean = false;
  mostrarMensajeAdvertenciaCargoAbono:  boolean = false;
  mostrarMensajeImpresion:      boolean = false;
  mostrarAdvertencia:           boolean = false;
  afectar:                      boolean= false;
  cargando:                     boolean = false;
  cargandoTiposDocumentos:      boolean = true;
  cargandoSeriesDocumentos:     boolean = true;
  cargandoTiposPago:            boolean = true;
  cargandoBanco:                boolean = true;
  cargandoCuentasBancarias:     boolean = true;
  creadoAfectar:                boolean = false;
  mostrarModalInfo:             boolean = false;
  mostrarBotonModal: boolean = false;
  isExiting: boolean = false;
  monto:                        number | null = null;
  bancoSeleccionado:            number | null = null;
  cuentaSeleccionada:           number | null = null;
  tipoCargoAbono:               number |null = null;
  errorMessage:                 string | null = null;
  autorizacion:                 string | null = null;
  referencia:                   string | null = null;
  opcionSeleccionadaTipoPago: PaBscTipoCargoAbono1M | null = null;
  opcionSeleccionadaEstado:     string = '';
  opcionSeleccionadaBanco:      string | null = null ;
  opcionSeleccionadaCuentaBancaria: string = '';
  fechaActual:                  string = '';
  observaciones:                string = '';
  tiposDocumentos:              PaBscTipoDocumentoMovilM[] = [];
  seriesDocumentos:             PaBscSerieDocumento1M[] = [];
  tiposPago:                    PaBscTipoCargoAbono1M[] = [];
  tipoPagoID:                   PaBscTipoCargoAbono1M[] = []; 
  bancos:                       PaBscBanco1M[]=[];
  cuentas:                      PaBscCuentaBancaria1M[] =[];
  cuentasBancarias:             PaBscCuentaBancaria1M[] = []; 
  mensajeValidar:               PaDocumentoValidar1M[] = [];
  mensajeValidarCargoAbono:     PaCargoAbonoValidar1M[] = [];
  encabezado:                   PaTblDocumentoM[] = [];
  cargoAbono:                   PaTblCargoAbonoM[] = [];
  opcionSeleccionadaSerie:      PaBscSerieDocumento1M | null = null;
  opcionSeleccionadaDocumento:  PaBscTipoDocumentoMovilM | null = null;
  opcionSeleccionadaCuenta: string | null = null;
  registrosCargoAbono:          PaTblCargoAbonoM[] = [];
  registrosCargoAbonoAfectar:   PaTblCargoAbonoM[] = [];
  registrosCargosAbonosAfectaA: PaTblCargoAbonoM[] = [];
  @Input() datosRecibidos:      any[] = [];
  datosParaImpresion:           any | null = null;
  clienteSeleccionado:          any;
  montosAplicados:              any;
  montosAplicadosAcumulados:    any;
  documentosSeleccionados:           PaBscCuentaCorriente1M[];
  documentosSeleccionadosAcumulados: PaBscCuentaCorriente1M[];

  @ViewChild('fechaInput', { static: false }) fechaInput!: ElementRef;
  @ViewChild('botonConfirmar') botonConfirmar!: ElementRef;
  @ViewChild(MensajeAdvertenciaComponent)
  mensajeAdvertencia!:         MensajeAdvertenciaComponent;

  constructor(private apiService: ApiService, private imprimirDocumento: ImprimirDocumentoComponent,
     private translate: TranslateService, private captchaService: RecaptchaService, private traduccionService: TraduccionService) {
    this.mostrarBotonesAcciones = false;
    this.mostrarBotonCxC = false;
    this.mostrarBotonHuerfano = false;
    this.cargandoSeriesDocumentos = false;
    this.cargandoTiposPago = false;
    this.montosAplicados = this.apiService.getMontosAplicados();
    this.montosAplicadosAcumulados = this.apiService.getMontosAplicadosAcumulados();
    this.documentosSeleccionados = this.apiService.getDocumentosSeleccionados();
    this.documentosSeleccionadosAcumulados = this.apiService.getDocumentosSeleccionadosAcumulados();
    console.log('Montos Aplicados:', this.apiService.getMontosAplicados());
    console.log('Montos Aplicados acumulados:', this.apiService.getMontosAplicadosAcumulados());
    console.log('Modelos seleccionados acumulados:', this.apiService.getDocumentosSeleccionadosAcumulados());
    console.log('Modelos seleccionados:', this.apiService.getDocumentosSeleccionados());

    this.translate.onLangChange.subscribe((event: LangChangeEvent) => {
      this.traducirTiposDocumentos(); 
      this.traducirTiposPago(); 
    });
  }

  abrirModalInformacion() {
    this.mostrarModalInfo = true;
  }

  // Función para cerrar el modal
  cerrarModalInformacion() {
    this.isExiting = true; // Iniciar la animación de salida
    setTimeout(() => {
      this.mostrarModalInfo = false; // Eliminar el modal del DOM después de la animación
      this.isExiting = false; // Restablecer el estado de salida
    }, 400); // Duración de la animación de salida (0.4s)
  }

  // Traducir tipos de documentos
  traducirTiposDocumentos() {
    this.tiposDocumentos = this.traducirElementos(this.tiposDocumentos, 'documento');
  }

  // Traducir tipos de pago
  traducirTiposPago() {
    this.tiposPago = this.traducirElementos(this.tiposPago, 'pago');
  }

  // Función genérica para traducir elementos
  traducirElementos<T extends { descripcion: string, claveOriginal?: string }>(
    elementos: T[],
    tipo: 'documento' | 'pago'
  ): T[] {
    return elementos.map(elemento => {
      if (!elemento.claveOriginal) {
        elemento.claveOriginal = this.obtenerClavePorDescripcion(elemento.descripcion, tipo);
      }

      elemento.descripcion = this.traduccionService.traducirTexto(elemento.claveOriginal);
      return elemento;
    });
  }

  // Función genérica para obtener clave por descripción
  obtenerClavePorDescripcion(descripcion: string, tipo: 'documento' | 'pago'): string {
    const mapaDocumentos: any = {
      'abono cxc': 'AbonoCxC',
      'cargo cxc': 'CargoCxC',
      'nota de credito cxc': 'NotaCreditoCxC',
      'nota de debito cxc': 'NotaDebitoCxC',
      'recibo de caja cxc': 'ReciboCajaCxC'
    };

    const mapaPagos: any = {
      'efectivo (cxc)': 'EfectivoCxC',
      'tarjeta de credito (cxc)': 'TarjetaCreditoCxC',
      'cheque (cxc)': 'ChequeCxC',
      'exenciones de iva': 'ExencionesIVA',
      'nota de debito (cxp)': 'NotaDebitoCP',
      'nota de credito (cxc)': 'NotaCreditoCxCPago',
      'retenciones iva': 'RetencionesIVA',
      'devoluciones': 'Devoluciones',
      'abono (cxc)': 'AbonoCxCPago',
      'cargo (cxc)': 'CargoCxCPago'
    };

    if (tipo === 'documento') {
      return mapaDocumentos[descripcion.toLowerCase()] || descripcion;
    } else if (tipo === 'pago') {
      return mapaPagos[descripcion.toLowerCase()] || descripcion;
    }
    return descripcion;
  }
  
  //TODO: Funciones para cerrar ditintos mensajes
  cerrarMensaje() {
    this.mostrarMensajeConfirmacion = false;
    this.mostrarMensajeImprimir = false;
    this.mostrarMensajeConfirmacioncargoAbono = false
    this.mostrarMensajeConfirmarOtroCAA = false
    this.mostrarAdvertencia = false
    this.mostrarMensajeImpresion = false;
  }

  cerrarMensajeValidacion() {
    // Ocultar el mensaje de validación
    this.mostrarMensajeAdvertenciaCargoAbono = false;
  }

  mostrarMensajeErrorInput(mensaje: string) {
    this.errorMessage = mensaje;
    setTimeout(() => {
      this.errorMessage = null;
    }, 3000); // El mensaje desaparecerá después de 3 segundos
  }

  ngOnInit(){
    this.montosAplicados = this.apiService.getMontosAplicados();
    this.montosAplicadosAcumulados = this.apiService.getMontosAplicadosAcumulados();
    this.documentosSeleccionados = this.apiService.getDocumentosSeleccionados();
    this.documentosSeleccionadosAcumulados = this.apiService.getDocumentosSeleccionadosAcumulados();
    console.log('Montos que se aplicaron pasada a CreacionRecibo:', this.montosAplicados);
    console.log('Datos seleccionados de docs CreacionRecibo:', this.documentosSeleccionados);
    console.log('Datos seleccionados acumulados de docs CreacionRecibo:' , this.documentosSeleccionadosAcumulados);
    this.cargarTiposDocumentoMovil();
    this.cargarSeriesDocumento();
    this.cargarTiposCargoAbono();
    this.cargarCuentaBancaria();
    this.apiService.clienteSeleccionado$.subscribe(cliente => {
      //console.log('Datos del cliente recibidos en el componente de creación de recibo:', cliente);
      this.clienteSeleccionado = cliente;
    });
  }
  
  ngAfterViewInit(): void {
    this.establecerFechaActual(); 
  }

  establecerFechaActual(): void {
    if (this.fechaInput) {
      const hoy = new Date().toISOString().split('T')[0]; //Obtiene la fecha actual en formato YYYY-MM-DD
      this.fechaInput.nativeElement.value = hoy; //Establece la fecha actual como valor del input de fecha
    }
  }
  
  //TODO: Funcion para asignar teclas a botones 
  @HostListener('document:keydown', ['$event'])
  handleKeyboardEvent(event: KeyboardEvent) {
    if (event.key === 'F1') {
      event.preventDefault();
      if (this.mostrarBotonCxC) {
        this.ejecutarCxC();
      }
    } 
    if (event.key === 'F2') {
      event.preventDefault(); // Evitar la acción por defecto de la tecla F2
      if (this.mostrarBotonHuerfano ) {
        this.ejecutarHuerfano();
      }
    } 
    if (event.key === 'F3') {
      event.preventDefault(); // Evitar la acción por defecto de la tecla F3
      if (this.cargoAbono.length > 0 && this.validarCampos()) {
        this.datosParaImprimir(this.encabezado, this.cargoAbono, this.clienteSeleccionado, this.montosAplicados);
      }
    }
    if (event.key === 'F4') {
      event.preventDefault(); // Evitar la acción por defecto de la tecla F3
      this.abrirModalInformacion()
    }
    if (event.key === 'Enter' && this.mostrarMensajeConfirmacion) {
      this.confirmarCreacion();
    }

    if (event.key === 'Enter' && this.mostrarMensajeImpresion) {
      this.confirmarImpresion();
    }
    if (event.key === 'Enter' && this.mostrarMensajeConfirmarOtroCAA) {
      this.validarCargoAbono(this.encabezado);
    }
  }

  copiarTexto(): void {
    const textarea = document.getElementById('editor') as HTMLTextAreaElement;
    if (textarea) {
      navigator.clipboard.writeText(textarea.value).then(() => {
        console.log('Texto copiado al portapapeles');
      }).catch(err => {
        console.error('Error al copiar el texto: ', err);
      });
    }
  }
  

  pegarTexto(): void {
    const textarea = document.getElementById('editor') as HTMLTextAreaElement;
    if (textarea) {
      navigator.clipboard.readText().then(text => {
        textarea.value = text;
        this.observaciones = text; // Actualiza la variable observaciones con el texto pegado
      }).catch(err => {
        console.error('Error al pegar el texto: ', err);
      });
    }
  }
  
  
  //TODO: Funciones para la carga de los datos 
  cargarTiposDocumentoMovil() {
    this.cargandoTiposDocumentos = true;
    const user = this.apiService.getUser();
    const empresa = this.apiService.getEmpresa();
    const parametros: ParametrosTipoDocumento = {
      pUserName: user,
      pOpc_Cuenta_Corriente: true,
      pCuenta_Corriente: true,
      pEmpresa: empresa, 
      pIngreso: true,
      pCosto: true
    };
  
    this.apiService.getTipoDocumento(parametros).subscribe(
      (data: PaBscTipoDocumentoMovilM[]) => {
        // Ordenar los tipos de documento dependiendo del campo 'orden_Cuenta_Corriente'
        this.tiposDocumentos = data.sort((a, b) => a.orden_Cuenta_Corriente - b.orden_Cuenta_Corriente);
        this.traducirTiposDocumentos();
        this.cargandoTiposDocumentos = false;
      },
      error => {
        console.error('Error al obtener los tipos de documentos', error);
        this.cargandoTiposDocumentos = false;
      }
    );
  }

  //*Funcion cargar Series
  cargarSeriesDocumento() {
    if (!this.opcionSeleccionadaDocumento || !this.opcionSeleccionadaDocumento.tipo_Documento) {
      return; 
    }
  
    const tipoDocumentoId = this.opcionSeleccionadaDocumento.tipo_Documento;
  
    if (!tipoDocumentoId || tipoDocumentoId === 0) {
      //console.warn('El tipo de documento seleccionado no tiene un tipo_Documento válido.');
      return; //Retorna si tipo_Documento no es un valor válido
    }
    const user = this.apiService.getUser();
    const estacion = this.apiService.getEstacion();
    const empresa = this.apiService.getEmpresa();
    const parametros: ParametrosSerieDocumento = {
      
      pTipo_Documento: tipoDocumentoId,
      pEmpresa: empresa, 
      pEstacion_Trabajo: estacion,
      pUserName: user,
      pT_Filtro_6: false,
      pGrupo: 1,
      pDocumento_Conv: false,
      pFE_Tipo: false,
      pPOS_Tipo: 0,
      pVer_FE: true
    };

    this.apiService.getSerieDocumento(parametros).subscribe(
      (data: PaBscSerieDocumento1M[]) => {
        this.seriesDocumentos = data;
        //console.log('Series de Documentos asignados:', this.seriesDocumentos);
        this.cargandoSeriesDocumentos = false;
      },
      error => {
        console.error('Error al obtener las series de documentos', error);
        this.cargandoSeriesDocumentos = false;
      }
    );
  }

  //*Funcion cargar Tipos de Pago
  cargarTiposCargoAbono() {
    if (!this.opcionSeleccionadaSerie) {
        //console.warn('No se ha seleccionado ninguna serie de documentos.');
        return;
    }

    const tipoDocumentoId = this.opcionSeleccionadaSerie.tipo_Documento;
    const serieDocumentoId = this.opcionSeleccionadaSerie.serie_Documento;
    const empresa = this.opcionSeleccionadaSerie.empresa;

    if (!tipoDocumentoId || tipoDocumentoId === 0 || !serieDocumentoId || serieDocumentoId === 0 || !empresa || empresa === 0) {
        //console.warn('No se pueden cargar los tipos de pago debido a parámetros faltantes.');
        return;
    }
    const parametros = {
        pTipo_Documento: tipoDocumentoId,
        pSerie_Documento: serieDocumentoId,
        pEmpresa: empresa
    };

    console.log("Parametros antes de solicitud: ", parametros)
    this.apiService.getTiposDePago(parametros).subscribe(
      (tiposPagoP: PaBscTipoCargoAbono1M[]) => {
          console.log('Tipos de Pago para el Tipo de Documento y Serie seleccionados:', tiposPagoP);
          this.tiposPago = tiposPagoP; // Asegúrate de que esto tenga los datos correctos
          this.traducirTiposPago(); // Aquí es donde se traduce
          this.cargandoTiposPago = false;
      },
      error => {
          console.error('Error al obtener los tipos de pago', error);
          this.cargandoTiposPago = false;
      }
  );
  }
  
  //*Funcion cargar Bancos
  cargarBancos() {
    if (!this.opcionSeleccionadaTipoPago) {
        return;
    }

    const tipoPagoSeleccionado = this.tiposPago.find(tp => tp.descripcion === this.opcionSeleccionadaTipoPago?.descripcion);
    if (!tipoPagoSeleccionado) {
        return;
    }

    // Cargar bancos solo si el tipo de pago requiere banco
    if (tipoPagoSeleccionado.banco) {
        this.bancos = [];
        this.bancoSeleccionado = null;
        const user = this.apiService.getUser();
        const empresa = this.apiService.getEmpresa();
        const parametros = {
            pUserName: user,
            pEmpresa: empresa,
            pOpcion: 4
        };
        this.apiService.getVerBancos(parametros).subscribe(
            (bancos: PaBscBanco1M[]) => {
                this.bancos = bancos.sort((a, b) => a.orden - b.orden);
                this.cargandoBanco = false;
            },
            error => {
                console.error('Error al obtener los bancos', error);
                this.cargandoBanco = false;
            }
        );
    } else {
        // Si no necesita banco, limpiar selección
        this.bancos = [];
        this.bancoSeleccionado = null;
        this.opcionSeleccionadaBanco = null;
        this.cuentasBancarias = [];
        this.opcionSeleccionadaCuenta = null;
        this.mostrarTarjetaCuentas = false; // Ocultar tarjeta de cuentas
    }
  }

  
  cargarCuentaBancaria() {
    if (!this.bancoSeleccionado) {
        console.warn('No se ha seleccionado ningún banco.');
        return;
    }

    const user = this.apiService.getUser();
    const empresa = this.apiService.getEmpresa();
    const parametros: ParametrosCuentaBancaria = {
        pUserName: user,
        pBanco: this.bancoSeleccionado,
        pEmpresa: empresa,
    };

    this.apiService.getCuentaBancaria(parametros).subscribe(
        (cuentas: PaBscCuentaBancaria1M[]) => {
            this.cuentasBancarias = cuentas; 
            this.mostrarTarjetaCuentas = this.cuentasBancarias.length > 0;
            console.log('Cuentas bancarias después de cargar:', this.cuentasBancarias);
            console.log('Banco seleccionado:', this.bancoSeleccionado);

        },
        error => {
            console.error('Error al obtener las cuentas bancarias', error);
            this.mostrarTarjetaCuentas = false; // Ocultar tarjeta en caso de error
        }
    );
  }

  
  //TODO: Funciones de seleccion de diferentes elementos
  seleccionarTipoDocumento(tipoDocumento: PaBscTipoDocumentoMovilM) {
    this.reiniciarTarjetas(); // Limpia las tarjetas y opciones anteriores
    this.cargandoSeriesDocumentos = true;
    this.opcionSeleccionadaDocumento = tipoDocumento;

    if (tipoDocumento && tipoDocumento.tipo_Documento) {
      this.cargarSeriesDocumento();
      this.mostrarBotonModal = true;
    }

    // Limpia banco y cuenta
    this.bancoSeleccionado = null;
    this.opcionSeleccionadaBanco = null;
    this.cuentasBancarias = [];
    this.opcionSeleccionadaCuenta = null;
    this.mostrarTarjetaCuentas = false;
  }

  //*Funcion para seleccionar Series
  seleccionarSerie(serie: PaBscSerieDocumento1M) {
    this.reiniciarTarjetaTipoPago(); // Limpia las tarjetas y opciones relacionadas con el tipo de pago
    this.opcionSeleccionadaSerie = serie;
    this.cargandoTiposPago = true;
  
    if (this.opcionSeleccionadaSerie) {
      this.cargarTiposCargoAbono();
    }
  
    // Limpia banco y cuenta
    this.bancoSeleccionado = null;
    this.opcionSeleccionadaBanco = null;
    this.cuentasBancarias = [];
    this.opcionSeleccionadaCuenta = null;
    this.mostrarTarjetaCuentas = false;
  
    console.log("Opcion Seleccionada de serie: ", this.opcionSeleccionadaSerie);
  }
  
  //*Funcion para seleccionar Tipos de Pago
  seleccionarTipoPago(tipoPago: PaBscTipoCargoAbono1M) {
    this.opcionSeleccionadaTipoPago = tipoPago;
    this.tipoCargoAbono = tipoPago.tipo_Cargo_Abono;
    this.referenciaHabilitada = tipoPago.referencia === 1;
    
    // Verificar si se requiere banco y/o cuenta bancaria
    this.bancosHabilitados = tipoPago.banco; 
    this.mostrarAutorizacion = tipoPago.autorizacion === 1;
    this.mostrarInputFecha = tipoPago.req_Fecha === 1;
    this.mostrarBloquearDoc = tipoPago.bloquear_Documento;
    console.log('Mostrar tarjeta de cuentas:', this.mostrarTarjetaCuentas);

    // Si no se necesita banco, mostrar botones y limpiar selección
    if (!tipoPago.banco) {
        this.mostrarBotonCxC = true;
        this.mostrarBotonHuerfano = true;
        this.bancoSeleccionado = null;
        this.opcionSeleccionadaBanco = null;
        this.bancos = [];
        this.cuentasBancarias = [];
        this.opcionSeleccionadaCuenta = null;
        this.mostrarTarjetaCuentas = false;
        console.log('Banco:', this.opcionSeleccionadaBanco);
        console.log('Cuenta Bancaria:', this.opcionSeleccionadaCuentaBancaria);
    } else {
        this.opcionSeleccionadaBanco = null;
        this.cargandoBanco = true;
        this.cargarBancos();
    }
  }

  
  // Función para seleccionar Bancos
  seleccionarBanco(bancoId: number) {
    // Si no se requiere banco, salir
    const tipoPagoSeleccionado = this.tiposPago.find(tp => tp.descripcion === this.opcionSeleccionadaTipoPago?.descripcion);
    if (!tipoPagoSeleccionado || !tipoPagoSeleccionado.banco) {
        return;
    }

    // Limpiar cuentas si se selecciona un nuevo banco
    this.cuentasBancarias = [];
    this.cuentaSeleccionada = null;
    this.opcionSeleccionadaCuenta = null;
    this.mostrarTarjetaCuentas = false;

    // Asignar banco seleccionado
    this.bancoSeleccionado = bancoId;

    if (bancoId !== null) {
        const bancoSeleccionado = this.bancos.find(b => b.banco === bancoId);
        this.opcionSeleccionadaBanco = bancoSeleccionado ? bancoSeleccionado.nombre : null;
          this.mostrarBotonCxC = true;
          this.mostrarBotonHuerfano = true;
          console.log('Cuenta Bancaria:', this.opcionSeleccionadaCuentaBancaria);
        if(this.opcionSeleccionadaTipoPago?.req_Cuenta_Bancaria == 1){
        this.cargarCuentaBancaria();
        this.mostrarBotonCxC = false;
        this.mostrarBotonHuerfano = false;
      } // Cargar cuentas asociadas
    } else {
        this.opcionSeleccionadaBanco = null;
    }
  }


  // Función para seleccionar Cuenta Bancaria
  seleccionarCuenta(cuentaId: number) {
    const tipoPagoSeleccionado = this.tiposPago.find(tp => tp.descripcion === this.opcionSeleccionadaTipoPago?.descripcion);
    if (!tipoPagoSeleccionado || tipoPagoSeleccionado.req_Cuenta_Bancaria !== 1) {
      return;
    }

    this.cuentaSeleccionada = cuentaId;

    const cuentaSeleccionada = this.cuentasBancarias.find(c => c.cuenta === Number(cuentaId));
    if (cuentaSeleccionada) {
      this.opcionSeleccionadaCuenta = cuentaSeleccionada.descripcion;
    } else {
      this.opcionSeleccionadaCuenta = 'Cuenta no encontrada'; // Mensaje de depuración
    }

    // Actualizar la vista
    this.mostrarBotonCxC = this.bancoSeleccionado != null && this.cuentaSeleccionada != null;
    this.mostrarBotonHuerfano = this.bancoSeleccionado != null && this.cuentaSeleccionada != null;
  }

  //TODO: Funciones para limpiar las tarjetas dependiendo el documento y serie
  reiniciarTarjetas() {
    this.seriesDocumentos = [];
    this.tiposPago = [];
    this.bancos = [];
    this.cuentasBancarias = [];
    this.opcionSeleccionadaSerie = null;
    this.opcionSeleccionadaTipoPago = null;
    this.bancoSeleccionado = null;
    this.cuentaSeleccionada = null;
    this.referenciaHabilitada = false;
    this.bancosHabilitados = false;
    this.mostrarTarjetaCuentas = false;
    this.mostrarInputFecha = false;
    this.mostrarAutorizacion = false;
    this.mostrarBloquearDoc = false;
    this.mostrarBotonCxC = false;
    this.mostrarBotonHuerfano = false;
    this.opcionSeleccionadaBanco = null; 
    this.opcionSeleccionadaCuenta = null;
  }

  reiniciarTarjetaTipoPago() {
    this.tiposPago = [];
    this.bancos = [];
    this.cuentasBancarias = [];
    this.opcionSeleccionadaTipoPago = null;
    this.bancoSeleccionado = null;
    this.cuentaSeleccionada = null;
    this.referenciaHabilitada = false;
    this.bancosHabilitados = false;
    this.mostrarTarjetaCuentas = false;
    this.mostrarInputFecha = false;
    this.mostrarAutorizacion = false;
    this.mostrarBloquearDoc = false;
    this.mostrarBotonCxC = false;
    this.mostrarBotonHuerfano = false;
    this.opcionSeleccionadaBanco = null; 
    this.opcionSeleccionadaCuenta = null;
  }
  
  //TODO: Validaciones y creaciones de documentos y CA
  //*Funcion para validar el Documento
  validarDocumento(clienteSeleccionado: any) {
    const user = this.apiService.getUser();
    const estacion = this.apiService.getEstacion();
    const empresa = this.apiService.getEmpresa();
    let fechaDocumento: string | null = null; // Cambiado de undefined a null
    
    if (this.fechaInput && this.fechaInput.nativeElement.value) {
      const fechaInputValue = this.fechaInput.nativeElement.value;
      fechaDocumento = fechaInputValue;
    } else {
      console.log('No se seleccionó ninguna fecha. La fecha será nula.');
    }
  
    const parametrosBase: any = {
      pUserName: user,
      pDocumento: 0,
      pTipo_Documento: this.opcionSeleccionadaDocumento?.tipo_Documento || 0,
      pSerie_Documento: this.opcionSeleccionadaSerie?.serie_Documento.toString() || '',
      pEmpresa: empresa,
      pLocalizacion: 1,
      pEstacion_Trabajo: estacion,
      pFecha_Reg: 0,
      pFecha_Documento: fechaDocumento || '', //Utiliza la fecha seleccionada o nula
      pCuenta_Correntista: clienteSeleccionado.cuenta_Correntista,
      pCuenta_Cta: clienteSeleccionado.cuenta_Cta,
      pBloqueado: false,
      pEstado_Objeto: 1,
      pMensaje: "''",
      pResultado: true,
      pId_Documento: "231321",
      pAccion: 0
    };
  
    const parametrosOpcionales: any = {
      pElemento_Asignado: null,
      pReferencia: null,
      pRef_Serie: null,
      pFecha_Vencimiento: null,
      pCuenta_Correntista_Ref: null,
      pIVA_Exento: null,
      pRef_Id_Documento: null,
      pResultado_Opcion: null,
      pBodega_Origen: null,
      pBodega_Destino: null,
      pObservacion_1: null,
      pObservacion_2: null,
      pObservacion_3: null,
    };
  
    // Agrega solo los campos opcionales que no son null ni undefined
    Object.keys(parametrosOpcionales).forEach(key => {
      if (parametrosOpcionales[key] !== null && parametrosOpcionales[key] !== undefined) {
        parametrosBase[key] = parametrosOpcionales[key];
      }
    });
  
    console.log('Parámetros enviados:', parametrosBase);
    this.cargando = true;
    // Realizar la llamada a la API para validar el documento
    this.apiService.getDocumentoValidar(parametrosBase).subscribe(
      (mensaje: PaDocumentoValidar1M[]) => {
        this.cargando = false;
        //console.log('Mensaje', mensaje);
        if (mensaje !== null && mensaje !== undefined) {
          // Asignar el mensaje y resultado
          this.mensajeValidar = mensaje;
          this.resultadoValidar = mensaje.length > 0 ? mensaje[0].resultado : null;
  
          //Muestra mensajes de confirmación si el mensaje es vacío
          if (this.mensajeValidar.length === 0) {
            this.mostrarMensajeConfirmacion = true;
            console.log('Mostrando mensaje de confirmación');
          } else if (this.resultadoValidar === false) {
            this.mostrarMensajeImprimir = true;
            console.log('Mostrando mensaje de validación');
          } else {
            console.log('El resultado es válido, se puede proceder a imprimir');
          }
        } else {
          // Manejo de casos donde el mensaje es null o undefined
          console.log('Mensaje es null o undefined');
          this.mostrarMensajeConfirmacion = true;
        }
      },
      error => {
        console.error('Error al obtener el mensaje', error);
        this.mostrarMensajeImprimir = true;
      }
    );
  }

  //*Funcion para validar el Cargo Abono
  validarCargoAbono(parametrosBase: any) {

      const user = this.apiService.getUser();
      const estacion = this.apiService.getEstacion();
      const empresa = this.apiService.getEmpresa();
      let fechaCargoAbono: string | null = null;
      
      if (this.fechaInput && this.fechaInput.nativeElement.value) {
        const fechaInputValue = this.fechaInput.nativeElement.value;
        fechaCargoAbono = fechaInputValue;
      }else {
        fechaCargoAbono = null;
        console.log('No se seleccionó ninguna fecha. La fecha será nula.');
      }
    
      let montosValidos = this.montosAplicados.filter((item: { montoAplicado: number }) => item.montoAplicado !== 0.0);
      const parametrosCargoAbono: any = {
        pUserName: user,
        pCargo_Abono: 0, 
        pEmpresa: empresa,
        pLocalizacion:1,
        pEstacion_Trabajo: estacion,
        pFecha_Reg: 0,
        pD_Documento: this.encabezado[0].documento,
        pDTipo_Documento:  this.encabezado[0].tipo_Documento,
        pD_Serie_Documento:  this.encabezado[0].serie_Documento,
        pD_Empresa:  this.encabezado[0].empresa,
        pD_Localizacion:  this.encabezado[0].localizacion,
        pD_Estacion_Trabajo:  this.encabezado[0].estacion_Trabajo,
        pD_Fecha_Reg:  this.encabezado[0].fecha_Reg,
        pTipo_Cargo_Abono:this.tipoCargoAbono , 
        pMonto: this.afectar ? (montosValidos.length > 0 ? montosValidos[0].montoAplicado : 0.0) : (this.monto || 0.0),
        pMonto_Moneda: this.afectar ? (montosValidos.length > 0 ? montosValidos[0].montoAplicado : 0.0) : (this.monto || 0.0),      
        pTipo_Cambio: 7, // de donde viene?
        pMoneda: 1, // de doncde viene?
        pMensaje: null,
        pResultado: true,
        pRef_Documento: this.referencia || null,//'1' this.referencia
        pReferencia: this.referencia || null, //null
        pAutorizacion: this.autorizacion || null, 
        pTrigger_Ins:true,
        pVer_Tabla: true,
        pRef_Fecha: fechaCargoAbono,
        pResultado_Opcion: 1,
      };
      if (this.bancoSeleccionado !== null && this.bancoSeleccionado !== undefined) {
        parametrosCargoAbono.pBanco = this.bancoSeleccionado;
      }
      if (this.cuentaSeleccionada !== null && this.cuentaSeleccionada !== undefined) {
        parametrosCargoAbono.pCuenta_Bancaria = this.cuentaSeleccionada;
      }
      
      console.log('Parámetros para validar cargo/abono:', parametrosCargoAbono);
      this.cargando = true;
      this.apiService.getValidarCargoAbono(parametrosCargoAbono).subscribe(
        (data: PaCargoAbonoValidar1M[]) => {
          this.cargando = false;
          //console.log('Mensaje de cargo abono:', data[1]);
          if (data !== null && data !== undefined) {
            this.mensajeValidarCargoAbono = data;
            this.resultadoValidar = data[0].resultado;
            
            //Muestra mensajes de confirmación si el mensaje es vacío
            if (this.mensajeValidarCargoAbono[0] && !this.mensajeValidarCargoAbono[1]) {
              
              if (this.afectar === false) {
                this.crearCargoAbono();
                this.mostrarMensajeConfirmarOtroCAA = false
              } else {
              
                  this.crearCargoAbonoAfectar();
                  this.mostrarMensajeConfirmarOtroCAA = false
                
              }
              console.log('Mostrando mensaje de cargo abono');
            } else if (this.resultadoValidar === false ) {
              this.mostrarMensajeAdvertenciaCargoAbono = true;
              console.log('Mostrando advertencia de cargo abono');
            } else {   
              console.log('El resultado es válido, se puede proceder a imprimir');
            }
          } else {
            console.log('El mensaje es null o undefined');
            this.mostrarMensajeAdvertenciaCargoAbono = true;
          }
        },
        error => {
          this.mostrarMensajeAdvertenciaCargoAbono = true;
          console.error('Error al validar cargo/abono:', error);
        }
      );
  }  
  
  //*Funcion para validar campos/inputs
  validarCampos(): Observable<boolean> {
    return new Observable<boolean>(observer => {
      // Validar monto
      if (!this.monto && this.afectar === false) {
        this.translate.get('messages.seRequiereMonto').pipe(
          map((res: string) => {
            this.mostrarMensajeErrorInput(res);
            observer.next(false);
            observer.complete();
          })
        ).subscribe();
        return;
      }
  
      // Validar referencia si está habilitada
      if (this.referenciaHabilitada && !this.referencia) {
        this.translate.get('messages.seRequiereReferencia').pipe(
          map((res: string) => {
            this.mostrarMensajeErrorInput(res);
            observer.next(false);
            observer.complete();
          })
        ).subscribe();
        return;
      }
  
      // Validar autorización si está habilitada
      if (this.mostrarAutorizacion && !this.autorizacion) {
        this.translate.get('messages.seRequiereAutorizacion').pipe(
          map((res: string) => {
            this.mostrarMensajeErrorInput(res);
            observer.next(false);
            observer.complete();
          })
        ).subscribe();
        return;
      }
  
      // Si todas las validaciones pasan
      observer.next(true);
      observer.complete();
    });
  }
  
  mostrarMensajesError(mensajes: string[]) {
    mensajes.forEach(mensaje => {
      this.mostrarMensajeErrorInput(mensaje);
    });
  }

  //*Funcion para crear el Encabezado de Documento
  crearEncabezadoDocumento(clienteSeleccionado: any){
    this.captchaService.ejecutarRecaptcha('crear_encabezado_documento').then(tokenRC => {
      const user = this.apiService.getUser();
      const estacion = this.apiService.getEstacion();
      const empresa = this.apiService.getEmpresa();
      
      let fechaDocumentoEncabezado: string | null = null;
      
      if (this.fechaInput && this.fechaInput.nativeElement.value) {
        const fechaInputValue = this.fechaInput.nativeElement.value;
        fechaDocumentoEncabezado = fechaInputValue;
      } else {
        fechaDocumentoEncabezado = new Date().toISOString();
        console.log('No se seleccionó ninguna fecha. La fecha será nula.');
      }
      const parametrosBase: any = {
        tAccion: 1,
        documento: 0,
        tipo_Documento: this.opcionSeleccionadaDocumento?.tipo_Documento,
        serie_Documento: this.opcionSeleccionadaSerie?.serie_Documento.toString(),
        empresa: empresa,
        localizacion: 1,
        estacion_Trabajo: estacion,
        fecha_Reg: 0,
        fecha_Hora: new Date().toISOString(),
        userName: user,
        m_Fecha_Hora: null,
        m_UserName: null,
        cuenta_Correntista: clienteSeleccionado.cuenta_Correntista,
        cuenta_Cta: clienteSeleccionado.cuenta_Cta,
        id_Documento: "''",
        documento_Nombre: clienteSeleccionado.factura_Nombre,
        documento_NIT: clienteSeleccionado.factura_Nit,
        documento_Direccion: clienteSeleccionado.factura_Direccion,
        id_Reservacion: null,
        bodega_Origen: null,
        bodega_Destino: null,
        observacion_1: this.observaciones,
        fecha_Documento: fechaDocumentoEncabezado,
        observacion_2:null,
        elemento_Asignado: null,
        estado_Documento: 1,
        impresion_Doc: null,
        referencia: null,
        doc_Det: null,
        fecha_Ini: null,
        fecha_Fin: null,
        fecha_Vencimiento: null,
        per_O_Cargos: null,
        clasificacion: null,
        cierre: null,
        fecha_Documento_Aux: null,
        ref_Serie: null,
        contabilizado: null,
        turno: null,
        observacion_3: null,
        cuenta_Correntista_Ref: null,
        cambio: null ,
        cambio_Moneda: null,
        bloqueado: null,
        bloquear_Venta: null,
        razon: null,
        proceso: null,
        consecutivo_Interno: null,
        cuenta_Correntista_Ref_2: null,
        localizacion_Ref: null,
        tipo_Pago: null,
        campo_1: null,
        campo_2: null,
        campo_3: null,
        fecha_Hora_N: null,
        fecha_Documento_N: null,
        seccion: null,
        tipo_Actividad: null,
        cierre_Contable: null,
        id_Unc: null,
        ivA_Exento: null,
        tOpcion: 1,
        ref_Fecha_Documento: null, 
        ref_Fecha_Vencimiento: null,
        t_Tra_M: null,
        t_Tra_MM: null,
        t_Car_Abo_M: null,
        t_Car_Abo_MM: null,
        propina_Monto: null,
        propina_Monto_Moneda: null,
        ref_Id_Documento: null,
        t_Tra_M_NImp: null,
        t_Tra_MM_NImp: null,
        t_Tra_M_Imp_IVA: null,
        t_Tra_MM_Imp_IVA: null,
        t_Tra_M_Imp_ITU: null,
        t_Tra_MM_Imp_ITU: null,
        t_Tra_M_Propina: null,
        t_Tra_MM_Propina: null,
        t_Tra_M_Cargo: null,
        t_Tra_MM_Cargo: null,
        t_Tra_M_Descuento: null,
        t_Tra_MM_Descuento: null,
        t_Car_Abo_M_Por_Aplicar: null,
        t_Car_Abo_MM_Por_Aplicar: null,
        t_Tra_M_Sub: null,
        t_Tra_MM_Sub: null,
        vehiculo_Marca: null,
        vehiculo_Modelo: null,
        vehiculo_Year: null,
        vehiculo_Color: null,
        survey_Record: null,
        periodo: null,
        adults: null,
        childrens: null,
        id_Doc_Alt: null,
        isR_Retener: null,
        fE_Cae: null,
        fE_numeroDocumento: null,
        fE_numeroDte: null,
        gpS_Latitud: null,
        gpS_Longitud: null,
        consecutivo_Interno_Ref: null,
        feL_UUID_Anulacion: null,
        feL_Numero_Acceso: null,
        fE_Fecha_Certificacion: null,
        id_Unc_Sync: null,
        recaptchaToken: tokenRC,
        isMobile: false
      };
      console.log( "TOKEN RC ANTES DE CREAR ENCABEZADO: ", parametrosBase.recaptchaToken)
      this.apiService.crearEncabezado(parametrosBase).subscribe(
        (data: PaTblDocumentoM[]) => {
          console.log('Solicitud de creación de encabezado completada con éxito:', data);
          if (data.length > 0) {
  
            this.encabezado = data;         
            console.log(this.encabezado)
            //Se llama a validarCargoAbono con los parametros correctos
            this.validarCargoAbono(parametrosBase);
          } else {
            console.error('La respuesta del servicio de creación de encabezado está vacía.');
          }
        },
        error => {
          console.error('Error al realizar la solicitud de creación de encabezado:', error);
          //console.log('Datos del cliente para el encabezado:', parametrosBase);
        }
      );

    }).catch(error => {
      console.error('Error al ejecutar reCAPTCHA:', error);
    });
   
  }

  //*Funcion para crear el Cargo Abono
  crearCargoAbono(){
    this.captchaService.ejecutarRecaptcha('crear_cargo_abono').then(tokenRC => {
      const user = this.apiService.getUser();
      const estacion = this.apiService.getEstacion();
      const empresa = this.apiService.getEmpresa();
      
      let fechaDocumentoCargoAbono: string | null = null;
      let fechaHora: string;
      if (this.fechaInput && this.fechaInput.nativeElement.value) {
        const fechaInputValue = this.fechaInput.nativeElement.value;
        fechaDocumentoCargoAbono = fechaInputValue;
      } else {
        fechaDocumentoCargoAbono = new Date().toISOString();
        console.log('No se seleccionó ninguna fecha. La fecha será nula.');
      }
      fechaHora = new Date().toISOString();
  
      // Calcular el total de montos aplicados
      const totalMontoAplicado = this.montosAplicados.reduce((acc: number, curr: { montoAplicado: number }) => acc + curr.montoAplicado, 0);
      const parametrosBase: any = {
        TAccion: 1,
        Cargo_Abono: 0,
        Empresa: empresa,
        Localizacion: 1,
        Estacion_Trabajo: estacion,
        Fecha_Reg: 0,
        Tipo_Cargo_Abono: this.tipoCargoAbono ,
        Estado: 1,
        Fecha_Hora:  fechaHora,
        UserName: user ,
        M_Fecha_Hora: null,
        M_UserName: null ,
        Monto: this.monto,
        Tipo_Cambio: 7,
        Moneda: 1 ,
        Monto_Moneda: this.monto,
        Referencia: this.referencia || null, 
        Autorizacion: this.autorizacion || null,
        Banco: this.bancoSeleccionado || null ,
        Observacion_1: this.observaciones || null ,
        Razon: null,
        D_Documento:  this.encabezado[0].documento,
        D_Tipo_Documento :  this.encabezado[0].tipo_Documento ,
        D_Serie_Documento:   this.encabezado[0].serie_Documento,
        D_Empresa:  this.encabezado[0].empresa ,
        D_Localizacion:   this.encabezado[0].localizacion,
        D_Estacion_Trabajo:   this.encabezado[0].estacion_Trabajo,
        D_Fecha_Reg:  this.encabezado[0].fecha_Reg ,
        Propina:null ,
        Propina_Moneda:null ,
        Monto_O:null ,
        Monto_O_Moneda:null ,
        F_Cuenta_Corriente_Padre:null ,
        F_Cobrar_Pagar_Padre:null ,
        F_Empresa_Padre: null,
        F_Localizacion_Padre:null,
        F_Estacion_Trabajo_Padre: null,
        F_Fecha_Reg_Padre:null ,
        Ref_Documento: this.referencia || null, //'1' this.referencia
        Cuenta_Bancaria: this.cuentaSeleccionada || null,
        Propina_Monto: null ,
        Propina_Monto_Moneda: null ,
        Cuenta_PIN:  null,
        TOpcion:1 ,
        Fecha_Ref: fechaDocumentoCargoAbono,
        Consecutivo_Interno_Ref: null,
        CA_Monto_Total: totalMontoAplicado,
        recaptchaToken: tokenRC,
        isMobile: false
      };
      this.cargando = true;
      console.log('Token RC ANTES DE CREAR CARGO ABONO:', tokenRC)
      this.apiService.crearCargoAbono(parametrosBase).subscribe(
        (data: PaTblCargoAbonoM[]) => {
          console.log('Solicitud de creación de cargo abono completada con éxito:', data);
          if (data.length > 0) {
            // Aquí actualizamos parametrosBase con los valores retornados en 'data'
            this.mostrarTablaCargoAbono = true;
            this.cargando = false;
            this.creadoAfectar = false;
            this.registrosCargoAbono = [];
            this.cargoAbono = data;
            this.registrosCargoAbono.push(...data); 
          } else {
            console.error('La respuesta del servicio de creación de cargo abono está vacía.');
          }
        },
        error => {
          console.error('Error al realizar la solicitud de creación de cargo abono:', error);
        }
      );
    }).catch(error => {
      console.error('Error al ejecutar reCAPTCHA:', error);
    });
   
  }

  //*Funcion para crear el Cargo Abono Afectar CxC
  crearCargoAbonoAfectar() {
    this.captchaService.ejecutarRecaptcha('crear_Cargo_Abono_Afectar').then(tokenRC => {
      const user = this.apiService.getUser();
      const estacion = this.apiService.getEstacion();
      const empresa = this.apiService.getEmpresa();
    
      let fechaDocumentoCargoAbono: string | null = null;
      let fechaHora: string;
      fechaHora = new Date().toISOString();
    
      if (this.fechaInput && this.fechaInput.nativeElement.value) {
        const fechaInputValue = this.fechaInput.nativeElement.value;
        fechaDocumentoCargoAbono = fechaInputValue;
      } else {
        fechaDocumentoCargoAbono = new Date().toISOString();
        console.log('No se seleccionó ninguna fecha. La fecha será nula.');
      }
      this.montosAplicados = this.apiService.getMontosAplicados();
      this.montosAplicadosAcumulados = this.apiService.getMontosAplicadosAcumulados();
      this.documentosSeleccionados = this.apiService.getDocumentosSeleccionados();
      this.documentosSeleccionadosAcumulados = this.apiService.getDocumentosSeleccionadosAcumulados();
      let montosValidos = this.montosAplicados.filter((item: { montoAplicado: number }) => item.montoAplicado !== 0.0);
      console.log('Montos validos: ', montosValidos);
      console.log('Documentos selec: ', this.documentosSeleccionados);
      // Calcular el total de montos aplicados
      const totalMontoAplicado = this.registrosCargoAbonoAfectar.reduce((acc: number, curr: { monto: number }) => acc + curr.monto, 0);
      //Llamada secuencial para manejar la secuencia
      this.ordenAfectarCarboAbono(montosValidos, 0, user,empresa, estacion, fechaHora, fechaDocumentoCargoAbono, totalMontoAplicado, tokenRC);
    }).catch(error => {
      console.error('Error al ejecutar reCAPTCHA:', error);
    });
   
  }
  
  //*Función secuencial para manejar la secuencia de llamadas A.CxC
  private ordenAfectarCarboAbono(montosValidos: any[], index: number, user: string, estacion: number, empresa: number, fechaHora: string, fechaDocumentoCargoAbono: string | null, totalMontoAplicado: number, tokenRC: string) {
    
    if (this.documentosSeleccionados.length === 0){
      this.mostrarMensajeConfirmarOtroCAA = false
      this.mostrarAdvertencia = true
      this.mensajeAdvertencia.mostrarAdvertencia == true
      
      return;
    }

    if (index >= montosValidos.length) {
      console.log('Todas las llamadas completadas.');
      this.creadoAfectar = true;
      const total = this.registrosCargoAbonoAfectar.reduce((acc: number, curr: { monto: number }) => acc + curr.monto, 0);

      this.documentosAplicar(total, this.clienteSeleccionado);
      return;
    }
   
    const montoAplicando = montosValidos[index].montoAplicado;
  
    const parametrosBase = {
      TAccion: 1,
      Cargo_Abono: 0,
      Empresa: empresa,
      Localizacion: 1,
      Estacion_Trabajo: estacion,
      Fecha_Reg: 0,
      Tipo_Cargo_Abono: this.tipoCargoAbono,
      Estado: 1,
      Fecha_Hora: fechaHora,
      UserName: user,
      M_Fecha_Hora: null,
      M_UserName: null,
      Monto: montoAplicando,
      Tipo_Cambio: 7,
      Moneda: 1,
      Monto_Moneda: montoAplicando,
      Referencia: this.referencia || null,
      Autorizacion: this.autorizacion || null,
      Banco: this.bancoSeleccionado || null,
      Observacion_1: this.observaciones || null,
      Razon: null,
      D_Documento: this.encabezado[0].documento,
      D_Tipo_Documento: this.encabezado[0].tipo_Documento,
      D_Serie_Documento: this.encabezado[0].serie_Documento,
      D_Empresa: this.encabezado[0].empresa,
      D_Localizacion: this.encabezado[0].localizacion,
      D_Estacion_Trabajo: this.encabezado[0].estacion_Trabajo,
      D_Fecha_Reg: this.encabezado[0].fecha_Reg,
      Propina: null,
      Propina_Moneda: null,
      Monto_O: null,
      Monto_O_Moneda: null,
      F_Cuenta_Corriente_Padre: this.documentosSeleccionados[index].Cuenta_Corriente,
      F_Cobrar_Pagar_Padre: this.documentosSeleccionados[index].Cobrar_Pagar,
      F_Empresa_Padre: this.documentosSeleccionados[index].Empresa,
      F_Localizacion_Padre: this.documentosSeleccionados[index].Localizacion,
      F_Estacion_Trabajo_Padre: this.documentosSeleccionados[index].Estacion_Trabajo,
      F_Fecha_Reg_Padre: this.documentosSeleccionados[index].Fecha_Reg,
      Ref_Documento: this.referencia || null,
      Cuenta_Bancaria: this.cuentaSeleccionada || null,
      Propina_Monto: null,
      Propina_Monto_Moneda: null,
      Cuenta_PIN: null,
      TOpcion: 1,
      Fecha_Ref: fechaDocumentoCargoAbono,
      Consecutivo_Interno_Ref: null,
      CA_Monto_Total: totalMontoAplicado,
      recaptchaToken: tokenRC,
      isMobile: false
    };
    this.cargando = true;
    console.log("parametros CAA", parametrosBase);
    console.log('Token RC ANTES DE CREAR CARGO ABONO AFECTAR:', tokenRC)
    this.apiService.crearCargoAbono(parametrosBase).subscribe(
      (data: PaTblCargoAbonoM[]) => {
        console.log('Solicitud de creación de cargo abono completada con éxito:', data);
        if (data.length > 0) {
          this.mostrarTablaCargoAbono = true;
          this.cargando = false;
          this.cargoAbono = data;
          this.registrosCargoAbonoAfectar.push(...data); 
          this.registrosCargosAbonosAfectaA.push(...data); 
          console.log('Elementos en registrosCargoAbono:', this.registrosCargoAbonoAfectar);
          console.log("Se CREO CA AFECTAR CXC");
        } else {
          console.error('La respuesta del servicio de creación de cargo abono está vacía.');
        }
       
        //Llamadas secuenciales para procesar el siguiente índice
        this.ordenAfectarCarboAbono(montosValidos, index + 1, user, empresa, estacion ,fechaHora, fechaDocumentoCargoAbono, totalMontoAplicado, tokenRC);
      },
      
      error => {
        console.error('Error al realizar la solicitud de creación de cargo abono:', error);
        //Llamadas secuenciales para continuar con el siguiente índice
        this.ordenAfectarCarboAbono(montosValidos, index + 1, user, empresa, estacion, fechaHora, fechaDocumentoCargoAbono,totalMontoAplicado, tokenRC);
      }
    );
  }

  documentosAplicar(total: number, clienteSeleccionado: any) {
    this.captchaService.ejecutarRecaptcha('crear_documentos_aplicar').then(tokenRC => {
      const user = this.apiService.getUser();
  
      let montosValidos = this.montosAplicados.filter((item: { montoAplicado: number }) => item.montoAplicado !== 0.0);
      const documentosAfectados: any[] = [];
      console.log('DATOS CLIENTE DOCUMENTOS APLICAR ',clienteSeleccionado)
      for (let i = 0; i < montosValidos.length; i++) {
        const montoAplicando = montosValidos[i].montoAplicado;
        const doc = this.documentosSeleccionados[i];
        //Crear la estructura JSON para el parametro Estructura
        documentosAfectados.push({
          CC_Cuenta_Corriente: doc.Cuenta_Corriente,
          CC_Cobrar_Pagar: doc.Cobrar_Pagar,
          CC_Empresa: doc.Empresa,
          CC_Localizacion: doc.Localizacion,
          CC_Estacion_Trabajo: doc.Estacion_Trabajo,
          CC_Fecha_Reg: doc.Fecha_Reg,
          CC_D_Documento: this.encabezado[0].documento,
          CC_D_Tipo_Documento: this.encabezado[0].tipo_Documento,
          CC_D_Serie_Documento: this.encabezado[0].serie_Documento,
          CC_D_Empresa: this.encabezado[0].empresa,
          CC_D_Localizacion: this.encabezado[0].localizacion,
          CC_D_Estacion_Trabajo: this.encabezado[0].estacion_Trabajo,
          CC_D_Fecha_Reg: this.encabezado[0].fecha_Reg,
          CC_Monto: montoAplicando,
          CC_Monto_M: montoAplicando / 7,
          CC_Cuenta_Correntista: clienteSeleccionado.cuenta_Correntista,
          CC_Cuenta_Cta: clienteSeleccionado.cuenta_Cta,

        });
      }
    
      const estructura = {
        CuentaCorriente: documentosAfectados
      };
    
      const parametrosDocumentoAplicar: any = {
        pOpcion: 1,
        pUserName: user,
        pTipo_Cambio: 7,
        pMoneda: 1,
        pMensaje: "",
        pResultado: false,
        pDoc_CC_Documento: this.encabezado[0].documento,
        pDoc_CC_Tipo_Documento: this.encabezado[0].tipo_Documento,
        pDoc_CC_Serie_Documento: this.encabezado[0].serie_Documento,
        pDoc_CC_Empresa: this.encabezado[0].empresa,
        pDoc_CC_Localizacion: this.encabezado[0].localizacion,
        pDoc_CC_Estacion_Trabajo: this.encabezado[0].estacion_Trabajo,
        pDoc_CC_Fecha_Reg: this.encabezado[0].fecha_Reg,
        pDoc_CC_Cuenta_Correntista: clienteSeleccionado.cuenta_Correntista,
        pDoc_CC_Cuenta_Cta: clienteSeleccionado.cuenta_Cta,
        pDoc_CC_Fecha_Documento: this.encabezado[0].fecha_Documento,
        pCA_Monto_Total: total,
        pTCA_Monto: this.opcionSeleccionadaDocumento?.opc_Verificar,
        pEstructura: estructura,
        recaptchaToken: tokenRC,
        isMobile: false
      };
    
      console.log('Parametros enviados DOCUMENTO APLICAR : ', parametrosDocumentoAplicar);
      console.log('Token RC ANTES DE DOCUMENTO APLICAR:', tokenRC)
      this.apiService.documentoAplicar(parametrosDocumentoAplicar).subscribe(
        (data: any[]) => {
          console.log('Solicitud exitosa:', data);
          console.log('ante:' , this.documentosSeleccionados);
          this.documentosSeleccionados = [];
          this.apiService.setDocumentosSeleccionados(this.documentosSeleccionados,this.documentosSeleccionadosAcumulados);
          console.log('depue:', this.documentosSeleccionados);
        },
        error => {
          console.error('Error al realizar la solicitud de documento aplicar:', error);
        }
      );
    }).catch(error => {
      console.error('Error al ejecutar reCAPTCHA:', error);
    })
    
  }

  confirmarCreacion() {
    this.mostrarMensajeConfirmacion = false;
    // Aquí se puede realizar alguna validación antes de llamar a crearEncabezadoDocumento si es necesario
    this.crearEncabezadoDocumento(this.clienteSeleccionado);
  }

  //TODO: Funciones para ejecutar cada accion
  ejecutarHuerfano() {
    this.afectar = false;
  
    // Validar campos
    this.validarCampos().subscribe(valid => {
      if (!valid) {
        return;
      }
  
      // Validar fecha si es necesario
      if (this.mostrarInputFecha && !this.fechaInput.nativeElement.value) {
        this.translate.get('messages.seRequiereFecha').pipe(
          map((res: string) => {
            this.mostrarMensajeErrorInput(res);
          })
        ).subscribe();
        return;
      }
  
      // Continuar con la lógica si las validaciones son correctas
      console.log("Valor del clienteSeleccionado:", this.clienteSeleccionado);
      if (this.cargoAbono.length === 0 && this.mostrarTablaCargoAbono === false) {
        this.validarDocumento(this.clienteSeleccionado);
      } else if (this.cargoAbono.length > 0 && this.mostrarTablaCargoAbono === true) {
        this.validarDocumento(this.clienteSeleccionado);
      }
    });
  }

  ejecutarCxC() {
    console.log('PRESIONANDO CXC');
    this.afectar = true;
  
    // Validar campos
    this.validarCampos().subscribe(valid => {
      if (!valid) {
        return;
      }
  
      // Validar fecha si es necesario
      if (this.mostrarInputFecha && !this.fechaInput.nativeElement.value) {
        this.translate.get('messages.seRequiereFecha').pipe(
          map((res: string) => {
            this.mostrarMensajeErrorInput(res);
          })
        ).subscribe();
        return;
      }
  
      // Continuar con la lógica si las validaciones son correctas
      console.log("Valor del clienteSeleccionado:", this.clienteSeleccionado);
      if (this.cargoAbono.length === 0 && this.mostrarTablaCargoAbono === false) {
        this.validarDocumento(this.clienteSeleccionado);
      } else if (this.cargoAbono.length > 0 && this.mostrarTablaCargoAbono === true) {
        if (this.creadoAfectar === true) {
          this.mostrarMensajeConfirmarOtroCAA = true;
        } else {
          this.validarDocumento(this.clienteSeleccionado);
        }
      }
    });
  }
  

  confirmarImpresion() {
    if (this.datosParaImpresion) {
      this.apiService.setDatosRecibo(this.datosParaImpresion);
      this.imprimirDocumento.generarPDF(); // Generar el PDF
      this.datosParaImpresion = null; // Limpiar los datos para evitar impresiones no confirmadas
    } else {
      console.error('No hay datos para imprimir.');
    }

    // Ocultar el mensaje de confirmación
    this.mostrarMensajeImpresion = false;
  }
  
  //TODO: Funion para imprimir el documento
  datosParaImprimir(encabezado: any, cargoAbono: any, clienteSeleccionado: any, montosValidos: any[]): void {
    this.mostrarMensajeImpresion = true;
    if (encabezado && cargoAbono && clienteSeleccionado && montosValidos &&
        this.opcionSeleccionadaDocumento && this.opcionSeleccionadaSerie && this.documentosSeleccionados) {
    this.datosParaImpresion = { 
        clienteSeleccionadoDatoImpresion: clienteSeleccionado,
        encabezado: encabezado,
        cargoAbono: cargoAbono,// Aquí pasamos montosValidos
        descripcionSerie: this.opcionSeleccionadaSerie,
        descripcionTipoDoc: this.opcionSeleccionadaDocumento,
        documentosSeleccionados:this.documentosSeleccionadosAcumulados,
        montosSeleccionados: this.montosAplicadosAcumulados,
        registrosCargosAbonos: this.registrosCargoAbono,
        registrosCargosAbonosAfectar: this.registrosCargoAbonoAfectar,
        afectar: this.creadoAfectar,
      };
    } else {
      console.error('Datos de impresión incompletos.');
    }
  }
}
 