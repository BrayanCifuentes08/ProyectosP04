import { Component } from '@angular/core';
import { AsignadorComponent } from "../asignador/asignador.component";
import { DesasignadorComponent } from "../desasignador/desasignador.component";
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-inicio',
  standalone: true,
  imports: [AsignadorComponent, DesasignadorComponent,CommonModule],
  templateUrl: './inicio.component.html',
  styleUrl: './inicio.component.css'
})
export class InicioComponent {
  mostrarAsignador: boolean = false; // Controla la visibilidad del componente de asignación
  mostrarDesasignador: boolean = false; // Controla la visibilidad del componente de desasignación
  mostrarContenidoInicial: boolean = true; // Controla la visibilidad del contenido inicial

  asignarElemento() {
    this.mostrarAsignador = true;
    this.mostrarDesasignador = false; // Ocultar el componente de desasignación
    this.mostrarContenidoInicial = false; // Ocultar el contenido inicial
  }

  desasignarElemento() {
    this.mostrarDesasignador = true;
    this.mostrarAsignador = false; // Ocultar el componente de asignación
    this.mostrarContenidoInicial = false; // Ocultar el contenido inicial
  }
}
