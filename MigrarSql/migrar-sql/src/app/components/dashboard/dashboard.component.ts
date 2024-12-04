import { Component, ElementRef, ViewChild } from '@angular/core';
import { SharedService } from '../../services/shared.service';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css',
})
export default class DashboardComponent {
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
  usuario: string = '';
  horaInicioSesionFormatted: string | null = null;
  fechaVencimientoToken: string | null = null;
  usandoHoraPerma: boolean = false;
  tooltipVisible: boolean = false;
  tiempoRestante: string = '';
  @ViewChild('fileInput') fileInput: ElementRef | undefined;

  constructor(private sharedService:SharedService){}

  ngOnInit(){
    this.sharedService.setAccion('modulo');
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
    console.log('Archivo eliminado');
  }
}
