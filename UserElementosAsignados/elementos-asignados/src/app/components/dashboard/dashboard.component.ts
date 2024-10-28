import { BootstrapOptions, Component } from '@angular/core';
import { InicioComponent } from '../inicio/inicio.component';
import { AsignadorComponent } from "../asignador/asignador.component";
import { DesasignadorComponent } from "../desasignador/desasignador.component";
import { CommonModule } from '@angular/common';
import { MessagesComponent } from "../../messages/messages.component";


@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [InicioComponent, AsignadorComponent, DesasignadorComponent, CommonModule, MessagesComponent],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export default class DashboardComponent {
  mostrarAsignador: boolean = false;
  mostrarDesasignador: boolean = false;
  mostrarInicio: boolean = true;
  headerText: string = 'Inicio';
  isVisibleExito: boolean = false;
  mensajeExito: string = ''; 

  asignarElemento() {
    if (this.mostrarAsignador) {
      this.volverInicio();
    } else {
      this.mostrarAsignador = true;
      this.mostrarDesasignador = false;
      this.mostrarInicio = false;
      this.headerText = 'Asignar Elemento';
    }
  }

  desasignarElemento() {
    if (this.mostrarDesasignador) {
      this.volverInicio();
    } else {
      this.mostrarDesasignador = true;
      this.mostrarAsignador = false;
      this.mostrarInicio = false;
      this.headerText = 'Desasignar Elemento';
    }
  }

  manejarMensajeExito(mensaje: string): void {
    this.mensajeExito = mensaje;
    this.isVisibleExito = true;

    setTimeout(() => {
      this.ocultarExito();
    }, 5000);
  }

  ocultarExito(): void {
    this.isVisibleExito = false;
  }

  volverInicio(): void {
    this.mostrarAsignador = false;
    this.mostrarDesasignador = false;
    this.mostrarInicio = true;
    this.headerText = 'Inicio';
  }
}
