import { CommonModule, isPlatformBrowser } from '@angular/common';
import { Component, ElementRef, Inject, PLATFORM_ID, ViewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../services/api.service';
import * as XLSX from 'xlsx';
import { MessagesComponent } from "../messages/messages.component";
import { DocumentoEstructura } from '../../models/documento-estructura';
import { TranslateModule } from '@ngx-translate/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-traslado',
  standalone: true,
  imports: [CommonModule, FormsModule, MessagesComponent, TranslateModule],
  templateUrl: './traslado.component.html',
  styleUrl: './traslado.component.css'
})
export default class TrasladoComponent {
  fileSeleccionado: File | null = null;
  hojas: string[] = [];
  hojaSeleccionada: string = '';
  cargandoHojas: boolean = false;
  cargandoTraslado: boolean = false;
  mostrarMensajeAdvertencia: boolean = false;
  isVisibleModal: boolean = false;
  isVisibleExito: boolean = false;
  mensajeExito: string = ''; 
  isVisibleAlerta: boolean = false;
  mensajeAlerta: string = ''; 
  dropdownAbierto: boolean = false;
  datosTabla: DocumentoEstructura[] = [];
  estructuraSeleccionada: string | null = null;
  mostrarEstructura: boolean = false;
  mostrarFiltros: boolean = false;
  mostrarComoTabla: boolean = false;
  datosTablaDetalle: any[] = [];
  encabezadosTabla: string[] = []; 
  datosFiltrados: any[] = [];
  columnaSeleccionada: boolean = false;

  usuario: string =''
  horaInicioSesionFormatted: string | null = null;
  fechaVencimientoToken: string | null = null;
  usandoHoraPerma: boolean = false;
  tooltipVisible: boolean = false;
  tiempoRestante: string = '';

  @ViewChild('fileInput') fileInput: ElementRef | undefined;
  constructor(private apiService: ApiService, @Inject(PLATFORM_ID) private platformId: Object, private router: Router,){}

  ngOnInit() {
    if (isPlatformBrowser(this.platformId)) {
      // Recuperar valores del localStorage
      this.horaInicioSesionFormatted = localStorage.getItem('horaInicioSesionFormatted');
      this.fechaVencimientoToken = localStorage.getItem('fechaVencimientoToken');
      this.usuario = this.apiService.getUser();
      
      // Determinar si se esta usando una sesion permanente o temporal
      const horaInicioSesionLocal = localStorage.getItem('horaInicioSesion');
      this.usandoHoraPerma = !!horaInicioSesionLocal; 
  
      if (this.fechaVencimientoToken) {
        this.iniciarContador();  // Inicia el contador
      }
      // Obtener los datos de localStorage y sessionStorage
      const estacionTrabajo = JSON.parse(localStorage.getItem('estacionTrabajo') || '{}');
      const empresa = JSON.parse(localStorage.getItem('empresa') || '{}');
      const aplicacion = JSON.parse(localStorage.getItem('aplicacion') || '{}');
      const display = JSON.parse(localStorage.getItem('display') || '{}');
  
      // Verificar si los datos estan en localStorage
      const datosEnLocalStorage = estacionTrabajo && empresa && aplicacion && display;
  
      // Si los datos no estan en localStorage
      if (!datosEnLocalStorage) {
        const datosEnSessionStorage = sessionStorage.getItem('estacionTrabajo') ||
                                      sessionStorage.getItem('empresa') ||
                                      sessionStorage.getItem('aplicacion') ||
                                      sessionStorage.getItem('display');
  
        if (datosEnSessionStorage) {
          // Si hay datos en sessionStorage, redirigir al login
          this.limpiarSessionStorageYRedirigir();
        } else {
          // Si no hay datos en ninguno, redirigir al login
          this.router.navigate(['/login']);
        }
      } else {
        this.router.navigate(['/trasladoDatos']);
      }
    }
  }

  limpiarSessionStorageYRedirigir(): void {
    sessionStorage.clear(); 
    console.log('sessionStorage limpiado');
    this.router.navigate(['/login']); 
  }

  cargarFile(event: any): void {
    const file: File = event.target.files[0];
    // Validar si ya hay un archivo cargado
    if (this.fileSeleccionado) {
      this.mostrarMensajeAdvertencia = true;
      event.target.value = '';  // Limpiar el input de archivo
      setTimeout(() => {
        this.mostrarMensajeAdvertencia = false;
      }, 7000);
      return;
    }

    this.hojas = [];
    if (file) {
      this.fileSeleccionado = file;
      console.log("Hojas antes de solicitud: ", this.hojas)
      console.log('Archivo seleccionado:', file);
      this.cargandoHojas = true;
      // Llamada al método obtenerHojasExcel
      this.apiService.obtenerHojasExcel(file).subscribe({
        next: (hojas: string[]) => {
          this.hojas = hojas; // Asigna las hojas obtenidas a la variable local
          this.cargandoHojas = false;
          console.log('Hojas obtenidas:', hojas);
        },
        error: (err) => {
          console.error('Error al obtener hojas:', err); // Manejo de errores
          this.cargandoHojas = false;
        }
      });
    }
  }

  trasladarDatos(): void {
    const user = this.apiService.getUser();
    const empresa = this.apiService.getEmpresa();
    this.isVisibleModal = false;
    this.datosTabla = []; 
    this.datosTablaDetalle = []; 
    this.encabezadosTabla = [];
    this.estructuraSeleccionada = null; 
    this.mostrarEstructura = false;
    this.mostrarComoTabla = false;
    this.columnaSeleccionada = false;
    if (!this.fileSeleccionado) {
      this.manejarMensajeError('No se ha seleccionado ningún archivo.');
      return;
    }
  
    const model = {
      tAccion: 1,
      tOpcion: 1,
      pUserName: user,
      pConsecutivoInterno: 0,
      pTipoEstructura: 1,
      pEstado: 1,
      archivo: this.fileSeleccionado,
      nombreHoja: this.hojaSeleccionada
    };
    this.cargandoTraslado = true;
    // Llamada a la API para trasladar los datos
    this.apiService.enviarDatosExcel(model).subscribe({
      next: (data) => {
        console.log('Datos trasladados correctamente:', data);
        this.cargandoTraslado = false;
        this.datosTabla = data;
        this.manejarMensajeExito('Datos trasladados correctamente.')
      },
      error: (err) => {
        this.cargandoTraslado = false;
        console.error('Error al trasladar los datos:', err);
        this.manejarMensajeError('Error al trasladar los datos.');
      }
    });
  }

  seleccionarEstructura(estructura: string | any): void {
    try {
      // Establecer columna seleccionada como verdadera
      this.columnaSeleccionada = true;

      // Validar si el contenido es una cadena JSON o ya es un objeto
      const json = typeof estructura === 'string' ? JSON.parse(estructura) : estructura;

      if (!json || (typeof json !== 'object' && !Array.isArray(json))) {
        throw new Error('El JSON no tiene un formato válido.');
      }

      this.estructuraSeleccionada = json; // Asignar el JSON parseado
      this.mostrarEstructura = false; // Mostrar JSON
      this.mostrarComoTabla = true; // Ocultar la tabla

      // Si es un arreglo, determinar encabezados automáticamente para la tabla
      if (Array.isArray(json)) {
        this.datosTablaDetalle = json;
        this.encabezadosTabla = Object.keys(json[0] || {});
      } else {
        // Convertir el objeto en un arreglo de un solo elemento para la tabla
        this.datosTablaDetalle = [json];
        this.encabezadosTabla = Object.keys(json);
      }
    } catch (error) {
      console.error('No se pudo procesar el JSON:', error);
      this.estructuraSeleccionada = null;
      this.mostrarEstructura = false;
      this.mostrarComoTabla = true; // Volver a mostrar la tabla si hay un error
      this.columnaSeleccionada = false; // Resetear columna seleccionada
    }
  }
  
  formatearJSON(json: any): string {
    if (!json) return 'No hay datos para mostrar.';
    
    const jsonString = JSON.stringify(json, null, 2); // JSON formateado
    return jsonString
      .replace(/"([^"]+)":/g, '<span class="text-red-600 font-bold">"$1"</span>:') // Claves en rojo
      .replace(/: "([^"]+)"/g, ': <span class="text-yellow-500">"$1"</span>') // Valores en amarillo
      .replace(/: (\d+)/g, ': <span class="text-purple-600">$1</span>') // Números en morado
      .replace(/: (true|false)/g, ': <span class="text-orange-500">$1</span>'); // Booleanos en naranja
  }
  
  // Función para borrar el archivo
  removerFile(): void {
    // Si existe el fileInput, limpiamos el valor
    if (this.fileInput) {
      this.fileInput.nativeElement.value = ''; // Limpiar el input
    }
    this.fileSeleccionado = null;
    this.hojas = []; 
    this.mostrarMensajeAdvertencia = false; 
    this.hojaSeleccionada = '';
    this.datosTabla = [];
    this.mostrarEstructura = false;
    this.estructuraSeleccionada = ''
    this.datosFiltrados = [];
    this.datosTablaDetalle = [];
    this.encabezadosTabla = []; 
    this.mostrarComoTabla = false;
    this.columnaSeleccionada = false;
    console.log('Archivo eliminado');
  }

  mostrarModalTraslado(): void {
    this.isVisibleModal = true;
  }

  seleccionarHoja(sheet: string): void {
    this.hojaSeleccionada = sheet;
    this.dropdownAbierto = false; // Cerrar el dropdown
    console.log('Hoja seleccionada:', sheet);
  }

  manejarMensajeExito(mensaje: string): void {
    this.mensajeExito = mensaje;
    this.isVisibleExito = true;

    setTimeout(() => {
      this.ocultarExito();
    }, 5000);
  }

  manejarMensajeError(mensaje: string): void {
    this.mensajeAlerta = mensaje;
    this.isVisibleAlerta = true;
    setTimeout(() => {
      this.ocultarAlerta();
    }, 5000);
  }

  ocultarExito(){
    this.isVisibleExito = false;
  }

  ocultarAlerta(){
    this.isVisibleAlerta = false;
  }

  toggleDropdown(): void {
    this.dropdownAbierto = !this.dropdownAbierto;
  }

  cerrarVista(): void {
    this.mostrarComoTabla = false; // Ocultar tabla
    this.mostrarEstructura = false; // Ocultar JSON
    this.columnaSeleccionada = false; // Resetear columna seleccionada
  }
  
  iniciarContador() {
    const partesFecha = this.fechaVencimientoToken!.split(', ');
    const [fecha, hora] = partesFecha;
    const [dia, mes, anio] = fecha.split('/');
    const [horas, minutos, segundos] = hora.split(':');
  
    const fechaVencimiento = new Date(+anio, +mes - 1, +dia, +horas, +minutos, +segundos);
  
    if (isNaN(fechaVencimiento.getTime())) {
      console.error("Fecha de vencimiento no válida: ", this.fechaVencimientoToken);
      this.tiempoRestante = 'Fecha no válida';
      return;
    }
  
    const actualizarContador = () => {
      const ahora = new Date().getTime();
      const diferencia = fechaVencimiento.getTime() - ahora;
  
      if (diferencia <= 0) {
        this.tiempoRestante = '00:00:00';  // Sesión expirada
        clearInterval(intervalo);
      } else {
        const horas = Math.floor(diferencia / (1000 * 60 * 60));
        const minutos = Math.floor((diferencia % (1000 * 60 * 60)) / (1000 * 60));
        const segundos = Math.floor((diferencia % (1000 * 60)) / 1000);
  
        this.tiempoRestante = 
          `${this.pad(horas)}:${this.pad(minutos)}:${this.pad(segundos)}`;
      }
    };
  
    const intervalo = setInterval(actualizarContador, 1000);
    actualizarContador();  // Inicializa el contador de inmediato
  }
  
  // Función pad para formatear números menores a 10 con ceros a la izquierda
  pad(n: number): string {
    return n < 10 ? '0' + n : '' + n;
  }
  
}
