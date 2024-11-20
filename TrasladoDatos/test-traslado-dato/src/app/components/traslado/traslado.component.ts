import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../services/api.service';

@Component({
  selector: 'app-traslado',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './traslado.component.html',
  styleUrl: './traslado.component.css'
})
export class TrasladoComponent {
  fileSeleccionado: File | null = null;
  hojas: string[] = [];
  hojaSeleccionada: string = '';
  cargandoHojas: boolean = false;
  constructor(private apiService: ApiService){}

  onFileSeleccionado(event: any): void {
    const file: File = event.target.files[0];
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

  // Función para trasladar los datos
  trasladarDatos(): void {
    console.log('Datos trasladados desde la hoja:', this.hojaSeleccionada);
    // Aquí iría la lógica para trasladar los datos a la base de datos
  }

  // Función para borrar el archivo
  removerFile(fileInput: HTMLInputElement): void {
    this.fileSeleccionado = null;
    this.hojas = []; 
    this.hojaSeleccionada = '';

    fileInput.value = '';

    console.log('Archivo eliminado');
  }
}
