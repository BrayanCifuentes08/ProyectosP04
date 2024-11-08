import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';

@Component({
  selector: 'app-messages',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './messages.component.html',
  styleUrl: './messages.component.css'
})
export class MessagesComponent {
  @Input() mensajeAlerta:   string = ''; // Mensaje para la alerta
  @Input() mensajeModal:    string = '';  // Mensaje para el modal
  @Input() mensajeExito:    string = '';
  @Input() isVisibleAlerta: boolean = false; // Controla la visibilidad de la alerta
  @Input() isVisibleModal:  boolean = false;  // Controla la visibilidad del modal
  @Input() isVisibleExito:  boolean = false;

  @Output() confirmarAccion = new EventEmitter<void>();
  @Output() cancelarAccion =  new EventEmitter<void>();
  @Output() cerrar =          new EventEmitter<void>(); // Para cerrar la alerta

  constructor() {}

  ocultarAlerta() {
    this.cerrar.emit(); 
  }

  ocultarModal() {
    this.isVisibleModal = false;
  }

  confirmar() {
    this.confirmarAccion.emit();
    this.ocultarModal();
  }

  cancelar() {
    this.cancelarAccion.emit();
    this.ocultarModal();
  }
  ocultarExito() {
    this.isVisibleExito = false;
  }
}
