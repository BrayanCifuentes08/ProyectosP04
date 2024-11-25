import { CommonModule } from '@angular/common';
import { Component, ElementRef, ViewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../services/api.service';
import * as XLSX from 'xlsx';
import { MessagesComponent } from "../messages/messages.component";
import { DocumentoEstructura } from '../../models/documento-estructura';

@Component({
  selector: 'app-traslado',
  standalone: true,
  imports: [CommonModule, FormsModule, MessagesComponent],
  templateUrl: './traslado.component.html',
  styleUrl: './traslado.component.css'
})
export class TrasladoComponent {
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
  
  @ViewChild('fileInput') fileInput: ElementRef | undefined;
  constructor(private apiService: ApiService){}

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
    this.isVisibleModal = false;
    if (!this.fileSeleccionado) {
      this.manejarMensajeError('No se ha seleccionado ningún archivo.');
      return;
    }
  
    const model = {
      tAccion: 1,
      tOpcion: 1,
      pUserName: 'ds',
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

  seleccionarEstructura(estructura: string): void {
    try {
      const json = JSON.parse(estructura); // Convierte la cadena JSON a un objeto
      this.estructuraSeleccionada = json;
      this.mostrarEstructura = true;
    } catch (error) {
      console.error('No se pudo parsear el JSON:', error);
      this.estructuraSeleccionada = estructura;
      this.mostrarEstructura = true;
    }
  }
  
  formatearJSON(json: any): string {
    const jsonString = JSON.stringify(json, null, 2); // JSON formateado
    return jsonString
      .replace(/"([^"]+)":/g, '<span class="text-red-600 font-bold">"$1"</span>:') // Claves en azul
      .replace(/: "([^"]+)"/g, ': <span class="text-yellow-500">"$1"</span>') // Valores en verde
      .replace(/: (\d+)/g, ': <span class="text-purple-600">$1</span>') // Números en amarillo
      .replace(/: (true|false)/g, ': <span class="text-orange-500">$1</span>'); // Booleanos en rojo
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
}
