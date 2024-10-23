import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-mensaje-advertencia',
  standalone: true,
  imports: [FormsModule,CommonModule],
  templateUrl: './mensajeAdvertencia.component.html',
  styleUrl: './mensajeAdvertencia.component.css'
})
export class MensajeAdvertenciaComponent {
  @Output() cerrar: EventEmitter<void> = new EventEmitter<void>();
  mostrarAdvertencia: boolean = true;
  @Input() mostrar: boolean = false;
  @Input() titulo: string = 'Advertencia';
  @Input() mensaje: string = '';
  @Input() iconoClase: string = 'fa-solid fa-triangle-exclamation';
  @Input() iconoColor: string = 'text-orange-300';
  @Input() mostrarBotonCerrar: boolean = true
  @Input() mostrarFondo: boolean = true; 
  cerrarMensaje() {
    this.mostrarAdvertencia = false;
    this.cerrar.emit();
  }

}
