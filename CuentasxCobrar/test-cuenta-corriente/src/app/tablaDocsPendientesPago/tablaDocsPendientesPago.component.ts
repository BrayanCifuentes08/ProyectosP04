import {
  Component,
  Input,
  OnInit,
  ViewChildren,
  QueryList,
  ElementRef,
  HostListener,
  EventEmitter,
  Output,
  ViewChild,
  ChangeDetectorRef,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { PaBscCuentaCorriente1M, Parametros } from '../models/docPendientes';
import { ApiService } from '../services/api.service';
import { LoadingComponent } from '../loading/loading.component';
import { CreacionReciboComponent } from '../creacionRecibo/creacionRecibo.component';
import { MensajeAdvertenciaComponent } from "../mensajeAdvertencia/mensajeAdvertencia.component";
import { trackByEventId } from 'angular-calendar/modules/common/util/util';
import { TranslateModule } from '@ngx-translate/core';

@Component({
    selector: 'app-tabla-docs-pendientes',
    standalone: true,
    templateUrl: './tablaDocsPendientesPago.component.html',
    styleUrl: './tablaDocsPendientesPago.component.css',
    imports: [
        CommonModule,
        FormsModule,
        LoadingComponent,
        CreacionReciboComponent,
        MensajeAdvertenciaComponent,
        TranslateModule
    ]
})
export class TablaDocsPendientesComponent implements OnInit {
  orden:                  'asc' | 'desc' = 'asc';
  cargando:                boolean = false;
  mostrarConfirmacion:     boolean = false;
  mostrarCreacionRecibo:   boolean = false;
  mostrarBotonAplicar:     boolean = false;
  mostrarMensajeErrorMonto:   boolean = false;
  mostrarMensajeErrorMontoPC: boolean = false;
  mostrarMontoCronologico: boolean = false;
  documentoSeleccionado:   number | null = null;
  private pendingRequests: number = 0;
  sumaAplicada:            number = 0;
  sumaMontos:              number = 0;
  sumaSaldos:              number = 0;
  aplicar:                 number = 0;
  diferenciaSaldos:        number = 0;
  saldoSeleccionado:       number = 0;
  montoCronologico:        number = 0;
  checkboxesSeleccionados: number[] = [];
  datosRecibidos:          any[] = [];
  modelosSeleccionadosAcumulados: any[] = [];
  modelosSeleccionados:    any[] = [];
  montosAplicados:         any[] = [];
  montosAplicadosAcumulados: any[] = [];
  monto: PaBscCuentaCorriente1M[] = [];
  docs:  PaBscCuentaCorriente1M[] = [];
  @Input() parametrosArray!:Parametros[];
  @Output() dataEmitted: EventEmitter<any[]> = new EventEmitter<any[]>();
  @ViewChildren('input') inputs!: QueryList<ElementRef>;
  @ViewChild('botonConfirmar') botonConfirmar!: ElementRef;

  constructor(
    private apiService: ApiService,
  ) {}
  
  sendDataToParent(data: any[]) {
    this.dataEmitted.emit(data);
  }

  cerrarMensaje() {
    this.mostrarMensajeErrorMonto = false;
    this.mostrarMensajeErrorMontoPC = false;
  }

  onDatosSeleccionados(event: any[]) {
    this.datosRecibidos = event;
  }

  ngAfterViewInit(): void {
    // Enfoque automático en el botón de confirmar cuando se muestra la confirmación
    if (this.mostrarConfirmacion) {
      this.botonConfirmar.nativeElement.focus();
    }
  }

  ngOnInit(): void {
    if (this.parametrosArray && this.parametrosArray.length > 0) {
      this.cargando = true;
      this.pendingRequests = this.parametrosArray.length;

      this.parametrosArray.forEach((parametros) => {
        this.apiService.getCuentaCorriente(parametros).subscribe(
          (response) => {
            this.docs.push(
              ...response.filter((item: PaBscCuentaCorriente1M) => !!item)
            );
            this.docs.forEach((model) => {
              model['aplicar'] = model.Saldo || 0;
            });
            this.checkLoadingState();
            this.actualizarSumaMontos();
            this.actualizarSumaSaldos();
            this.calcularDiferencia();
          },
          (error) => {
            console.error('Error al obtener cuenta corriente:', error);
            this.checkLoadingState();
          }
        );
      });
    }
  }

  focusSiguenteInput(event: KeyboardEvent) {
    if (event.key === 'ArrowDown') {
      const currentIndex = this.getCurrentIndex();
      const nextIndex = (currentIndex + 1) % this.inputs.length;
      this.inputs.toArray()[nextIndex].nativeElement.focus();
      event.preventDefault();
    } else if (event.key === 'ArrowUp') {
      const currentIndex = this.getCurrentIndex();
      const previousIndex =
        currentIndex === 0 ? this.inputs.length - 1 : currentIndex - 1;
      this.inputs.toArray()[previousIndex].nativeElement.focus();
      event.preventDefault();
    }
  }

  getCurrentIndex(): number {
    const focusedInput = document.activeElement;
    return this.inputs
      .toArray()
      .findIndex((input) => input.nativeElement === focusedInput);
  }

  @HostListener('keydown', ['$event'])
  onKeyDown(event: KeyboardEvent) {
    const currentInput = event.target as HTMLInputElement;
    if (event.key === 'Enter' && this.mostrarConfirmacion) {
      this.confirmarCambios();
      this.deshabilitarCheckbox();
    } 

    if (currentInput.getAttribute('data-input-type') === 'number') {
      if (event.key === 'ArrowUp' || event.key === 'ArrowDown') {
        event.preventDefault();

        const inputs = document.querySelectorAll(
          'input[data-input-type="number"]'
        );
        const inputArray = Array.from(inputs);

        const currentIndex = inputArray.indexOf(currentInput);
        if (currentIndex !== -1) {
          let newIndex = currentIndex;
          if (event.key === 'ArrowUp') {
            newIndex = Math.max(0, newIndex - 1); //Mueve hacia arriba
          } else if (event.key === 'ArrowDown') {
            newIndex = Math.min(inputArray.length - 1, newIndex + 1); //Mueve hacia abajo
          }

          const nextInput = inputArray[newIndex] as HTMLInputElement;
          nextInput.focus();
        }
      }
    }
  }

  checkLoadingState(): void {
    this.pendingRequests--;
    if (this.pendingRequests === 0) {
      this.cargando = false;
    }
  }

  ordenarDocs(): void {
    this.docs.sort((a, b) => {
      const fechaA = new Date(a.D_Fecha_Vencimiento);
      const fechaB = new Date(b.D_Fecha_Vencimiento);
      if (this.orden === 'asc') {
        return fechaA.getTime() - fechaB.getTime();
      } else {
        return fechaB.getTime() - fechaA.getTime();
      }
    });
  }
  
  cambiarOrdenDocs(): void {
    this.orden = this.orden === 'asc' ? 'desc' : 'asc';
    this.ordenarDocs();
  }

  mostrarDetalles(model: PaBscCuentaCorriente1M): void {
    if (this.documentoSeleccionado === model.Consecutivo_Interno) {
      this.documentoSeleccionado = null;
    } else {
      this.documentoSeleccionado = model.Consecutivo_Interno;
    }
  }

  obtenerDetallesUsuario(FE_NumeroDocumento: string): string {
    const model = this.docs.find(
      (model) => model.FE_NumeroDocumento === FE_NumeroDocumento
    );
    return model ? model.FE_NumeroDocumento : '';
  }

  obtenerDetallesSaldo(Saldo: number): number {
    const model = this.docs.find((model) => model.Saldo === Saldo);
    return model ? model.Saldo : 0;
  }

  obtenerDetallesSaldoMoneda(Saldo_Moneda: number): number {
    const model = this.docs.find(
      (model) => model.Saldo_Moneda === Saldo_Moneda
    );
    return model ? model.Saldo_Moneda : 0;
  }

  estadoCheckbox(consecutivoInterno: number, event: any): void {
    if (event.target.checked) {
      if (!this.checkboxesSeleccionados.includes(consecutivoInterno)) {
        this.checkboxesSeleccionados.push(consecutivoInterno);
      }
    } else {
      const index = this.checkboxesSeleccionados.indexOf(consecutivoInterno);
      if (index > -1) {
        this.checkboxesSeleccionados.splice(index, 1);
        this.docs.forEach((model) => {
          model['aplicar'] = model['Saldo'] || 0;
        });
      }
      const model = this.docs.find(
        (item) => item.Consecutivo_Interno === consecutivoInterno
      );
      if (model) {
        this.aplicar = model.Saldo;
      }
    }
    this.mostrarBotonAplicar = this.checkboxesSeleccionados.length > 0;
    this.mostrarMontoCronologico = false;
    
  }

  onAplicarClick(): void {
    // Validar si el monto es válido
    if (this.mostrarMontoCronologico && (!this.montoCronologico || this.montoCronologico <= 0)) {
      this.mostrarMensajeErrorMontoPC = true;
      return;
    }
    // Si el monto es válido, proceder con la lógica existente
    this.mostrarMensajeErrorMontoPC = false;
    if (this.mostrarMontoCronologico) {
      this.distribuirPagoCronologico();
    }
    this.actualizarSaldosNuevos();
  }
  
  actualizarSaldosNuevos(){
    this.modelosSeleccionados = this.docs.filter((modelo) =>
      this.checkboxesSeleccionados.includes(modelo.Consecutivo_Interno)
    );

    const montoMayorAlSaldo = this.docs.some(
      (model) =>
        this.checkboxesSeleccionados.includes(model.Consecutivo_Interno) &&
        model.aplicar > model.Saldo
    );
   
    if (montoMayorAlSaldo) {
      this.mostrarMensajeErrorMonto = true;
    } else {

      if(this.mostrarMontoCronologico == true){
        this.distribuirPagoCronologico()
       
      }

      this.mostrarMensajeErrorMonto = false;
      this.mostrarConfirmacion = true;  

      this.sumaAplicada = this.modelosSeleccionados.reduce(
        (suma, modelo) => suma + (modelo.aplicar || 0),
        0
      );

      this.saldoSeleccionado = this.modelosSeleccionados.reduce(
        (suma, modelo) => suma + (modelo.Saldo || 0),
        0
      );

      this.montosAplicados = this.modelosSeleccionados.map(modelo => ({
        montoAplicado: modelo.aplicar || 0
      }));
    }
  }
  
  actualizarMontosAplicados(): void {
    if (this.checkboxesSeleccionados.length === 0) {
      this.sumaAplicada = 0;
    } else {
      this.sumaAplicada = this.docs
        .filter((model) => this.checkboxesSeleccionados.includes(model.Consecutivo_Interno))
        .reduce((suma, model) => suma + (model.aplicar || 0), 0);
    }
    
  }
  
  actualizarSumaMontos() {
    this.sumaMontos = this.docs.reduce((suma, model) => suma + (model.Monto || 0), 0);
    this.calcularDiferencia();
  }
  
  actualizarSumaSaldos() {
    this.sumaSaldos = this.docs.reduce((suma, model) => {
      return suma + (model.Saldo || 0);
    }, 0);
  }  

  calcularDiferencia(): void {
    this.diferenciaSaldos = this.sumaMontos - this.sumaSaldos;
  }
  
  actualizarSaldoNuevo(): void {
    this.docs.forEach((model) => {
      if (this.checkboxesSeleccionados.includes(model.Consecutivo_Interno)) {
        model.Saldo -= model.aplicar;
        model.aplicar = model.Saldo; //Actualiza el valor de aplicar al resultado de la resta
      }
    });
    this.actualizarSumaSaldos();
    this.actualizarMontosAplicados();
    this.calcularDiferencia(); 
    
    //console.log('Modelos actualizados:', this.docs);
    console.log('Suma de saldos actualizada:', this.sumaSaldos);
    console.log('Suma de montos aplicados actualizada *:', this.sumaAplicada);
  }

  confirmarCambios(): void {
    // Realiza las acciones necesarias para confirmar los cambios
    this.actualizarSaldoNuevo();

    // Actualiza los montos aplicados para reflejar los cambios
    this.actualizarMontosAplicados();

    // Oculta la confirmación y muestra la creación del recibo
    this.mostrarConfirmacion = false;
    this.mostrarCreacionRecibo = true;
    this.mostrarBotonAplicar = false;
    this.mostrarMontoCronologico = false;

    this.modelosSeleccionadosAcumulados = [
      ...this.modelosSeleccionadosAcumulados,
      ...this.modelosSeleccionados
    ];

    this.montosAplicadosAcumulados = [
      ...this.montosAplicadosAcumulados,
      ...this.montosAplicados
    ];
    
    this.apiService.setMontosAplicados(this.montosAplicados, this.montosAplicadosAcumulados);
    this.apiService.setDocumentosSeleccionados(this.modelosSeleccionados, this.modelosSeleccionadosAcumulados);

  }

  cancelarCambios(): void {
    this.mostrarConfirmacion = false;
  }

  mostrarInputPagoCronologico(){
    this.mostrarMontoCronologico = true
    this.mostrarBotonAplicar = true
  }

  distribuirPagoCronologico(): void {
    let monto = this.montoCronologico;
    // Ordenar los documentos por fecha de vencimiento (ascendente)
    this.docs.sort((a, b) => new Date(a.D_Fecha_Vencimiento).getTime() - new Date(b.D_Fecha_Vencimiento).getTime());
    // Reiniciar los checkboxes seleccionados
    this.checkboxesSeleccionados = [];
    // Iterar sobre los documentos ordenados y distribuir el monto
    for (let i = 0; i < this.docs.length; i++) {
      let saldoDisponible = this.docs[i].aplicar;
      // Verificar si hay saldo disponible en el documento actual
      if (saldoDisponible > 0) {
        // Calcular el monto a distribuir en este documento
        let montoAAplicar = monto;
        if (montoAAplicar > saldoDisponible) {
          montoAAplicar = saldoDisponible;
        }
        // Asignar el monto al _montoController correspondiente
        this.docs[i].aplicar = montoAAplicar;
        monto -= montoAAplicar; // Restar el monto distribuido del monto global
        // Agregar el consecutivo interno al arreglo de checkboxes seleccionados
        this.checkboxesSeleccionados.push(this.docs[i].Consecutivo_Interno);
        // Si ya no queda monto por distribuir, salir del bucle
        if (monto <= 0) {
          break;
        }
      }
    }
    // Actualizar el estado de los checkboxes en la interfaz
    this.actualizarEstadoCheckboxes();
  }

  actualizarEstadoCheckboxes(): void {
    // Iterar sobre los documentos y actualizar el estado de los checkboxes
    this.docs.forEach((doc) => {
      const checkbox = document.getElementById(`checkbox-table-search-${doc.Consecutivo_Interno}`) as HTMLInputElement;
      if (checkbox) {
        checkbox.checked = this.checkboxesSeleccionados.includes(doc.Consecutivo_Interno);
      }
    });
    this.modelosSeleccionados = this.docs.filter((modelo) =>
      this.checkboxesSeleccionados.includes(modelo.Consecutivo_Interno)
    );

    this.saldoSeleccionado = this.modelosSeleccionados.reduce(
      (suma, modelo) => suma + (modelo.Saldo || 0),
      0
    );
    this.sumaAplicada = this.modelosSeleccionados.reduce(
      (suma, modelo) => suma + (modelo.aplicar || 0),
      0
    );

    this.montosAplicados = this.modelosSeleccionados.map(modelo => ({
      montoAplicado: modelo.aplicar || 0
    }));
    
  }

  deshabilitarCheckbox() {
    this.docs.forEach((doc) => {
        const checkbox = document.getElementById(`checkbox-table-search-${doc.Consecutivo_Interno}`) as HTMLInputElement;
        if (checkbox) {
            checkbox.checked = false;
        }
        //Reinicia el valor del input aplicar a 0 solo si el checkbox no está seleccionado
        if (!this.checkboxesSeleccionados.includes(doc.Consecutivo_Interno)) {
           this.actualizarMontosAplicados();
        }
    });

    //Reinicia el array de checkboxes seleccionados
    this.checkboxesSeleccionados = [];

    //Actualizar la suma de montos aplicados
    this.actualizarMontosAplicados();
  }
}
