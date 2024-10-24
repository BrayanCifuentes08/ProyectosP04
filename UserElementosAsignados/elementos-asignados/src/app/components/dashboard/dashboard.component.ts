import { BootstrapOptions, Component } from '@angular/core';
import { InicioComponent } from '../inicio/inicio.component';
import { AsignadorComponent } from "../asignador/asignador.component";
import { DesasignadorComponent } from "../desasignador/desasignador.component";
import { CommonModule } from '@angular/common';


@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [InicioComponent, AsignadorComponent, DesasignadorComponent,CommonModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export default class DashboardComponent {
  mostrarAsignador: boolean = false;
  mostrarDesasignador: boolean = false;
  mostrarInicio: boolean = true;
  headerText: string = 'Inicio';
  asignarElemento() {
    this.mostrarInicio = false;
    this.mostrarAsignador = true;
    this.mostrarDesasignador = false;
    this.headerText = 'Asignar Elemento'; // Cambia el texto del encabezado
  }

  desasignarElemento() {
    this.mostrarDesasignador = true;
    this.mostrarInicio = false;
    this.mostrarAsignador = false;
    this.headerText = 'Desasignar Elemento'; // Cambia el texto del encabezado
  }
}
