import { Component, ElementRef, ViewChild } from '@angular/core';
import { SharedService } from '../../services/shared.service';
import { MigrarSqlService } from '../../services/migrar-sql.service';
import { CommonModule } from '@angular/common';
import { TranslateModule } from '@ngx-translate/core';
import { FormsModule } from '@angular/forms';
import { MessagesComponent } from "../../messages/messages.component";

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, TranslateModule, FormsModule, MessagesComponent],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css',
})
export default class DashboardComponent {
  fileSeleccionado: File | null = null;
  hojas: string[] = [];
  hojaSeleccionada: string | null = null;
  cargandoHojas: boolean = false;
  mostrarMensajeAdvertencia: boolean = false;
  isVisibleModal: boolean = false;
  isVisibleExito: boolean = false;
  mensajeExito: string = '';
  isVisibleAlerta: boolean = false;
  mensajeAlerta: string = '';
  @ViewChild('fileInput') fileInput: ElementRef | undefined;
  rutaOrigen: string | null = null;
  mostrarArea: boolean = false;
  mostrarAreaSubida: boolean = true;
  cargandoTraslado: boolean = false;
  nombreArchivo: string = '';
  constructor(private sharedService:SharedService, private migrarSqlService: MigrarSqlService){}

  ngOnInit(){
    this.sharedService.setAccion('vistaModulo');
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
      this.sharedService.setAccion('cargaHojas');
      this.fileSeleccionado = file;
      this.mostrarAreaSubida = false;
      console.log("Hojas antes de solicitud: ", this.hojas)
      console.log('Archivo seleccionado:', file);
      this.cargandoHojas = true;
      // Llamada al método obtenerHojasExcel
      this.migrarSqlService.obtenerHojasExcel(file).subscribe({
        next: (hojas: string[]) => {
          this.hojas = hojas; // Asigna las hojas obtenidas a la variable local
          this.cargandoHojas = false;
          this.sharedService.setAccion('exitoHojasCargadas');
          console.log('Hojas obtenidas:', hojas);
        },
        error: (err) => {
          console.error('Error al obtener hojas:', err); // Manejo de errores
          this.sharedService.setAccion('errorCarga');
          this.cargandoHojas = false;
        }
      });
    }
  }

  trasladarDatos(): void {
    if (this.cargandoTraslado) {
      return; // Evitar múltiples solicitudes si ya está en curso
    }
    this.cargandoTraslado = true;
    console.log('Ejecutando traslado datos')
    const selectedFile = this.fileSeleccionado;
    if (!selectedFile) {
      this.mostrarMensajeAdvertencia = true;
      setTimeout(() => {
        this.mostrarMensajeAdvertencia = false;
      }, 7000);
      this.cargandoTraslado = false;
      return;
    }
  
    // Iteración sobre las hojas seleccionadas, pero solo para una hoja (sin ciclo)
    const hojaSeleccionada = this.hojas[0]; // Selecciona solo la primera hoja
    if (hojaSeleccionada) {
      const model = {
        archivo: selectedFile,
        nombreHoja: hojaSeleccionada,
      };
  
      this.migrarSqlService.enviarDatos(model).subscribe({
        next: (blob: Blob) => {

          const nombreArchivoOriginal = this.fileSeleccionado
          ? this.fileSeleccionado.name.replace(/\.[^/.]+$/, '.xlsx')
          : 'archivo_actualizado.xlsx';

          // Crear un enlace para descargar el archivo
          const url = window.URL.createObjectURL(blob);
          const a = document.createElement('a');
          a.href = url;
          a.download = nombreArchivoOriginal; // Nombre del archivo descargado
          document.body.appendChild(a);
          a.click();
          document.body.removeChild(a);
          window.URL.revokeObjectURL(url); // Liberar el objeto Blob
          this.manejarMensajeExito('Archivo descargado correctamente.');
          setTimeout(() => {
            this.actualizarInterfaz();
          }, 5000);
        },
        error: (err) => {
          console.error('Error al realizar la solicitud:', err);
          this.manejarMensajeError(`Error al realizar la solicitud: ${err.message}`);
        },
        complete: () => {
          this.cargandoTraslado = false;
        }
      });
    }
  }


  private actualizarInterfaz(): void {
    console.log('Actualizando la interfaz...');
    
    // Reiniciar variables relacionadas con el proceso
    this.fileSeleccionado = null;
    this.hojas = [];
    this.hojaSeleccionada = '';
    this.mostrarAreaSubida = true;
  
    // Si es necesario recargar datos o vistas
    this.sharedService.setAccion('vistaModulo'); // Notificar cambio de vista
  }
  

  seleccionarHoja(hoja: string): void {
    this.hojaSeleccionada = hoja;
    console.log('Hoja seleccionada:', hoja); // Verifica en consola
    this.sharedService.setAccion('seleccionHojas');

  }

  //Función para borrar el archivo
  removerFile(): void {
    // Si existe el fileInput, limpiamos el valor
    if (this.fileInput) {
      this.fileInput.nativeElement.value = ''; // Limpiar el input
    }
    this.fileSeleccionado = null;
    this.hojas = [];
    this.mostrarMensajeAdvertencia = false;
    this.hojaSeleccionada = '';
    this.mostrarAreaSubida = true;
    this.sharedService.setAccion('vistaModulo');

    console.log('Archivo eliminado');
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

  mostrarModalTraslado(): void {
    this.isVisibleModal = true;
  }

}