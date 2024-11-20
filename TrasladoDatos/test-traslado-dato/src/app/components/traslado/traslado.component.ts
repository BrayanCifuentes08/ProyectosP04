import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../services/api.service';
import * as XLSX from 'xlsx';
import { MessagesComponent } from "../messages/messages.component";

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

  // Función para manejar la selección de la hoja
  onHojaSeleccionada(): void {
    console.log('Hoja seleccionada:', this.hojaSeleccionada);
  }

  trasladarDatos(): void {
    this.isVisibleModal = false;
    if (!this.fileSeleccionado) {
      console.error('No se ha seleccionado ningún archivo.');
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
      next: (data: Response) => {
        this.cargandoTraslado = false;
        console.log('Datos trasladados correctamente:', data);
      },
      error: (err) => {
        this.cargandoTraslado = false;
        console.error('Error al trasladar los datos:', err);
      }
    });
  }
  
  // Función para borrar el archivo
  removerFile(fileInput: HTMLInputElement): void {
    this.fileSeleccionado = null;
    this.hojas = []; 
    this.hojaSeleccionada = '';
    this.mostrarMensajeAdvertencia = false; 
    fileInput.value = '';

    console.log('Archivo eliminado');
  }

  mostrarModalTraslado(): void {
    this.isVisibleModal = true;
  }
}
