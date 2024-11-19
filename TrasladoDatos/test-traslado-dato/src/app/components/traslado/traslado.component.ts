import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';

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


  onFileSeleccionado(event: any): void {
    const file: File = event.target.files[0];
    if (file) {
      this.fileSeleccionado = file;
      console.log('Archivo seleccionado:', file);
      
      // Simulamos que el archivo tiene 3 hojas
      this.hojas = ['Hoja 1', 'Hoja 2', 'Hoja 3']; // Aquí usar una librería como xlsx.js para leer las hojas
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
