import { Component, Inject, PLATFORM_ID } from '@angular/core';
import { AsignadorComponent } from "../components/asignador/asignador.component";
import { DesasignadorComponent } from "../components/desasignador/desasignador.component";
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { UserElementoAsignadoM } from '../models/user-elemento-asignado';
import { ApiService } from '../services/api.service';
import { SharedService } from '../services/shared.service';
import { UtilidadService } from '../services/utilidad.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-inicio',
  standalone: true,
  imports: [AsignadorComponent, DesasignadorComponent,CommonModule],
  templateUrl: './inicio.component.html',
  styleUrl: './inicio.component.css'
})
export default class InicioComponent {
  userElementosAsignados: UserElementoAsignadoM[] = [];
  userElementosAsignadosOriginal: UserElementoAsignadoM[] = [];
  isLoading: boolean = false; // Bandera para mostrar el spinner mientras cargan los datos
  hayElementosCargados: boolean = false;

  constructor(private apiService: ApiService, private sharedService: SharedService, private utilidadService: UtilidadService,  ) {}

  ngOnInit(){
    this.obtenerUserElementosAsignados();
  }

  obtenerUserElementosAsignados(): void {
    const user = this.apiService.getUser();
    const empresa = this.apiService.getEmpresa();
    this.isLoading = true;
    const model = {
      pUserName: user,
    };
    this.apiService.getUserElementoAsignado(model).subscribe({
      next: (data: UserElementoAsignadoM[]) => {
        // Formatea las fechas antes de asignarlas al array
        this.userElementosAsignados = data.map((elemento) => ({
          ...elemento,
          fecha_Hora: this.utilidadService.formatFechaCompleta(new Date(elemento.fecha_Hora)),
        }));
        this.userElementosAsignadosOriginal = [...this.userElementosAsignados];
        // Establecer la bandera
        this.hayElementosCargados = this.userElementosAsignados.length > 0;
        this.isLoading = false;
        console.log('Elementos asignados', this.userElementosAsignados);
        this.sharedService.setUserElementosAsignados(this.userElementosAsignados);
      },
      error: (error) => {
        this.isLoading = false;
        console.error('Error al obtener los elementos:', error);
      },
    });
  }

  filtrarElementos(event: Event): void {
    const input = (event.target as HTMLInputElement).value.toLowerCase();

    if (input.length === 0) {
      // Si el input está vacío, se restauran todos los elementos
      this.userElementosAsignados = [...this.userElementosAsignadosOriginal];
    } else {
      // Filtrar elementos según la búsqueda
      this.userElementosAsignados = this.userElementosAsignadosOriginal.filter(elemento =>
        elemento.descripcion.toLowerCase().includes(input)
      );
    }
    this.hayElementosCargados = this.userElementosAsignados.length > 0;
  }
  

 
}
