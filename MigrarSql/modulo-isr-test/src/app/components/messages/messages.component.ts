import { Component, EventEmitter, Input, Output } from '@angular/core';

@Component({
  selector: 'app-messages',
  templateUrl: './messages.component.html',
  styleUrl: './messages.component.css'
})
export class MessagesComponent {
  @Input() mensajeAlerta: string = ''; // Mensaje para la alerta
  @Input() mensajeModal: string = '';  // Mensaje para el modal
  @Input() mensajeExito: string = '';
  @Input() isVisibleAlerta: boolean = false; 
  @Input() isVisibleModal: boolean = false;  
  @Input() isVisibleExito: boolean = false;

  @Output() confirmarAccion = new EventEmitter<void>();
  @Output() cancelarAccion = new EventEmitter<void>();
  @Output() cerrar = new EventEmitter<void>();


  constructor() {}

  ocultarAlerta() {
    this.cerrar.emit(); 
  }

  ocultarModal() {
    console.log("Ocultando modal");
    this.isVisibleModal = false;
  }

  confirmar() {
    this.confirmarAccion.emit();
    this.ocultarModal();
  }

  cancelar() {
    console.log("Modal cancelado");
    this.cancelarAccion.emit();
  }
  
  ocultarExito() {
    this.isVisibleExito = false;
  }
}

