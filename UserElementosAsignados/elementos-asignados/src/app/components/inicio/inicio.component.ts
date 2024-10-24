import { Component } from '@angular/core';
import { AsignadorComponent } from "../asignador/asignador.component";
import { DesasignadorComponent } from "../desasignador/desasignador.component";
import { CommonModule } from '@angular/common';
import { UserElementoAsignadoM } from '../../models/user-elemento-asignado';
import { ApiService } from '../../services/api.service';
import { SharedService } from '../../services/shared.service';

@Component({
  selector: 'app-inicio',
  standalone: true,
  imports: [AsignadorComponent, DesasignadorComponent,CommonModule],
  templateUrl: './inicio.component.html',
  styleUrl: './inicio.component.css'
})
export class InicioComponent {
  userElementosAsignados: UserElementoAsignadoM[] = [];
  isLoading: boolean = false; // Bandera para mostrar el spinner mientras cargan los datos
  hayElementosSeleccionados: boolean = false; // Bandera para controlar si se ha seleccionado algún elemento

  constructor(private apiService: ApiService, private sharedService: SharedService, ) {}

  ngOnInit(){
    this.obtenerUserElementosAsignados()
  }

  obtenerUserElementosAsignados(): void {
    this.isLoading = true;
    const model = {
      pUserName: 'AUDITOR01',

    };
    this.apiService.getUserElementoAsignado(model).subscribe({
      next: (data: UserElementoAsignadoM[]) => {
        this.userElementosAsignados = data;  // Almacena los elementos obtenidos
        this.isLoading = false;
        console.log('Elementos asignados', this.userElementosAsignados);
        this.sharedService.setUserElementosAsignados(this.userElementosAsignados);
      },
      error: (error) => {
        this.isLoading = false; 
        console.error('Error al obtener los elementos:', error);
      }
    });
  }
  
}
