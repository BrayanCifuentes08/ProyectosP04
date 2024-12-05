import { Component, ElementRef, ViewChild } from '@angular/core';
import { SharedService } from '../../services/shared.service';
import { MigrarSqlService } from '../../services/migrar-sql.service';
import { CommonModule } from '@angular/common';
import { TranslateModule } from '@ngx-translate/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, TranslateModule, FormsModule],
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
  mostrarAreaSubida: boolean = true; 
  rutaEspecificada: string = 'C:\\Users\\dev005\\Downloads';
  puedeEditarRuta: boolean = false;
  cargandoTraslado: boolean = false;
  
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
    this.cargandoTraslado = true;
  
    const selectedFile = this.fileSeleccionado;
    if (!selectedFile) {
      this.mostrarMensajeAdvertencia = true;
      setTimeout(() => {
        this.mostrarMensajeAdvertencia = false;
      }, 7000);
      return;
    }
  
    // Iteración sobre las hojas seleccionadas, pero solo para una hoja (sin ciclo)
    const hojaSeleccionada = this.hojas[0]; // Selecciona solo la primera hoja
    if (hojaSeleccionada) {
      const model = {
        archivo: selectedFile,
        nombreHoja: hojaSeleccionada,
        rutaDestino: this.rutaEspecificada 
      };
  
      this.migrarSqlService.enviarDatos(model).subscribe({
        next: (response: any) => {
          if (response.statusCode === 200) {
            console.log('Datos insertados correctamente para la hoja:', hojaSeleccionada);
            // Aquí puedes procesar la respuesta si es necesario, como se hacía en Dart
            //this.mostrarMensajeExito(`Datos trasladados correctamente para la hoja ${hojaSeleccionada}`);
            this.cargandoTraslado = true;
          } else {
            const errorMessage = response.message || 'Error desconocido';
            console.error('Error al realizar la solicitud al servidor:', response.statusCode);
            //this.mostrarMensajeError('Error al realizar la solicitud', errorMessage);
            this.cargandoTraslado = false;
          }
        },
        error: (err) => {
          console.error('Error al realizar la solicitud:', err);
          this.cargandoTraslado = false;
          //this.mostrarMensajeError('Error al realizar la solicitud', err.message || 'Error desconocido');
        },
        complete: () => {
          this.cargandoTraslado = false;
        }
      });
    }
  }

  seleccionarHoja(hoja: string): void {
    this.hojaSeleccionada = hoja;
    console.log('Hoja seleccionada:', hoja); // Verifica en consola
    this.sharedService.setAccion('seleccionHojas');

  }

  alternarEdicionRuta(): void {
    if (this.puedeEditarRuta) {
      // Si ya está en modo de edición, se bloquea
      this.puedeEditarRuta = false;
    } else {
      this.puedeEditarRuta = true;
    }
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
}
