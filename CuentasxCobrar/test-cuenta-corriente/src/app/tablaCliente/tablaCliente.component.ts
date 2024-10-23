import {
  Component,
  EventEmitter,
  Input,
  OnInit,
  Output,
  ViewChild,
} from '@angular/core';
import { ApiService } from '../services/api.service';
import { Subscription } from 'rxjs';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { PaBscCuentaCorrentistaMovilM } from '../models/cliente';
import { CreacionReciboComponent } from '../creacionRecibo/creacionRecibo.component';
import { MensajeAdvertenciaComponent } from '../mensajeAdvertencia/mensajeAdvertencia.component';
import { LoadingComponent } from '../loading/loading.component';
import { ParametrosTipoDocumento } from '../models/tipo-documento';
import { TablaDocsPendientesComponent } from '../tablaDocsPendientesPago/tablaDocsPendientesPago.component';
import { TranslateModule, TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-tabla',
  standalone: true,
  templateUrl: './tablaCliente.component.html',
  styleUrls: ['./tablaCliente.component.css'],
  imports: [
    CommonModule,
    FormsModule,
    CreacionReciboComponent,
    MensajeAdvertenciaComponent,
    LoadingComponent,
    TablaDocsPendientesComponent,
    TranslateModule,
  ],
})
export class TablaComponent implements OnInit {
  pCriterioBusqueda:           string = '';
  mostrarAdvertencia:          boolean = false;
  cargando:                    boolean = false;
  mostrarNoDatos:              boolean = false;
  noDatosEncontrados:          boolean = false;
  mostrarTabla:                boolean = false;
  showDocumentosPendientesTab: boolean = true;
  mostrarDocumentosPendientes: boolean = false;
  mostrarTarjeta:              boolean = false;
  selectedCheckbox:            number | null = null;
  clienteSeleccionado:         any;
  private subscription:        Subscription | undefined;
  clientes:                    PaBscCuentaCorrentistaMovilM[] = [];
  @ViewChild(MensajeAdvertenciaComponent)
  mensajeAdvertencia!: MensajeAdvertenciaComponent;
  @Input() parametrosArray!:   ParametrosTipoDocumento[];
  @Output() datosSeleccionados: EventEmitter<any[]> = new EventEmitter<any[]>();
  @Output() dataEmitted:          EventEmitter<any[]> = new EventEmitter<any[]>();
  @Output() clienteSeleccionadoEvent = new EventEmitter<any>();
  @Output() datosSeleccionadosEvent: EventEmitter<any[]> = new EventEmitter<
    any[]
  >();
  private initialized = false;

  constructor(
    private apiService: ApiService,
  ) {}

  onClienteSeleccionado(cliente: any): void {
    //Guardar los datos del cliente seleccionado en el servicio compartido
    this.apiService.setClienteSeleccionado(cliente);
  }

  ngOnInit() {
    this.mostrarTabla = false; // Inicialmente ocultar la tabla
    setTimeout(() => {
      this.mostrarTabla = true; // Mostrar la tabla con un retraso
    }, 100); // Ajusta el tiempo según sea necesario
  }


  cerrarMensaje() {
    this.mostrarAdvertencia = false;
    this.noDatosEncontrados = false;
  }
  
  public buscarCliente(): void {
    const pEmpresa = this.apiService.getEmpresa();
    const pUserName = this.apiService.getUser();
    const pCriterioBusqueda = this.pCriterioBusqueda;

    // Si no hay criterio de búsqueda, solo mostrar el mensaje de advertencia
    if (!pCriterioBusqueda) {
        this.mostrarAdvertencia = true;
        this.mostrarNoDatos = false;  // Asegurarse de ocultar el mensaje de no datos
        return;
    }

    this.mostrarAdvertencia = false;

    if (this.subscription) {
        this.subscription.unsubscribe();
    }
    this.cargando = true;
    this.subscription = this.apiService
        .buscarClientes(pUserName, pCriterioBusqueda, pEmpresa)
        .subscribe(
            (clientes) => {
                this.clientes = clientes;
                this.noDatosEncontrados = clientes.length === 0;
                this.mostrarNoDatos = this.noDatosEncontrados;
                this.cargando = false;
                this.mostrarTabla = true;
            },
            (error) => {
                console.error('Error al buscar clientes:', error);
                this.cargando = false;
            }
        );
  }

  onCheckboxChange(index: number) {
    if (this.selectedCheckbox === index) {
      this.selectedCheckbox = null; // Deseleccionar el checkbox
      this.mostrarTarjeta = false;
      this.clienteSeleccionado = null; // Limpiar los datos
    } else {
      this.selectedCheckbox = index; // Seleccionar el checkbox
      this.mostrarTarjeta = true;
      
      // Asignar los datos seleccionados al clienteSeleccionado
      this.clienteSeleccionado = {
        cuenta_Correntista: this.clientes[this.selectedCheckbox].cuenta_Correntista,
        cuenta_Cta: this.clientes[this.selectedCheckbox].cuenta_Cta,
        factura_Nombre: this.clientes[this.selectedCheckbox].factura_Nombre,
        ccDireccion: this.clientes[this.selectedCheckbox].cC_Direccion, // Aquí revisa si tienes cC_Direccion o ccDireccion
        factura_Nit: this.clientes[this.selectedCheckbox].factura_Nit,
        factura_Direccion: this.clientes[this.selectedCheckbox].factura_Direccion,
        telefono: this.clientes[this.selectedCheckbox].telefono,
      };
      console.log("Cliente seleccionado: ", this.clienteSeleccionado);
  
      // Emitir los datos seleccionados si es necesario
      this.sendDataToParent([this.clienteSeleccionado]);
    }
  
    // Verifica si hay algún checkbox seleccionado para mostrar/ocultar la pestaña
    this.mostrarDocumentosPendientes = this.selectedCheckbox !== null;
  
    if (this.selectedCheckbox === null) {
      this.sendDataToParent([]); // Enviar arreglo vacío si no hay checkbox seleccionado
    }
  }
  
  seleccionarCliente(cliente: any): void {
    this.clienteSeleccionadoEvent.emit(cliente);
  } 

  sendDataToParent(data: any[]) {
    this.dataEmitted.emit(data);
  }

  emitirDatosSeleccionados(datos: any[]) {
    this.datosSeleccionadosEvent.emit(datos);
  }

  clearInput(inputElement: HTMLInputElement) {
    this.pCriterioBusqueda = '';
    inputElement.focus();
  }

  cerrarTarjeta() {
    this.mostrarTarjeta = false;
  }

}
