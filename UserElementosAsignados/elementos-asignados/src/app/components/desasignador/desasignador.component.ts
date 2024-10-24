import { Component, EventEmitter, Output } from '@angular/core';
import { SharedService } from '../../services/shared.service';
import { UserElementoAsignadoM } from '../../models/user-elemento-asignado';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api.service';
import { forkJoin } from 'rxjs';
import { MessagesComponent } from "../../messages/messages.component";

@Component({
  selector: 'app-desasignador',
  standalone: true,
  imports: [CommonModule, MessagesComponent],
  templateUrl: './desasignador.component.html',
  styleUrl: './desasignador.component.css'
})
export class DesasignadorComponent {
  elementosAsignadosInicio: UserElementoAsignadoM[] = [];
  elementosAsignadosSeleccionado: UserElementoAsignadoM[] = [];
  hayElementosSeleccionados: boolean = false; 
  @Output() regresar = new EventEmitter<void>();
  constructor(private sharedService: SharedService, private apiService: ApiService){}
  isLoading: boolean = false;
  isVisibleModal: boolean = false;
  mensajeModal: string = ''; 
  mostrarBtnLimpiarSeleccion: boolean = false

  ngOnInit(): void {
    this.sharedService.userElementosAsignados$.subscribe((elementos) => {
      this.elementosAsignadosInicio = elementos;
    });
  }

  desasignarElementos(): void {
    if (this.elementosAsignadosSeleccionado.length === 0) {
      alert("No hay elementos seleccionados para desasignar.");
      return;
    }
    // Crear un arreglo de observables para las llamadas
    const desasignaciones = this.elementosAsignadosSeleccionado.map(elemento => {
      const model = {
        UserName: 'AUDITOR01',
        Elemento_Asignado: elemento.elemento_Asignado,
      };
      return this.apiService.deleteUserElementoAsignado(model);
    });

    //forkJoin para esperar a que todas las solicitudes se completen
    forkJoin(desasignaciones).subscribe({
      next: results => {
        console.log("Elementos desasignados correctamente:", results);
        this.elementosAsignadosSeleccionado = [];
        this.onRegresar();
        this.mostrarBtnLimpiarSeleccion = false; 
      },
      error: error => {
        console.error("Error al desasignar elementos:", error);

      }
    });
  }

  seleccionElemento(elemento: UserElementoAsignadoM, event: Event): void {
    const inputElement = event.target as HTMLInputElement;
  
    if (inputElement.checked) {
      this.elementosAsignadosSeleccionado.push(elemento);
      console.log("Elementos seleccionados", this.elementosAsignadosSeleccionado)
    } else {
      // Remueve el elemento si el checkbox se desmarca
      this.elementosAsignadosSeleccionado = this.elementosAsignadosSeleccionado.filter(e => e.elemento_Asignado !== elemento.elemento_Asignado);
    }
    this.hayElementosSeleccionados = this.elementosAsignadosSeleccionado.length > 0;
    this.mostrarBtnLimpiarSeleccion = this.hayElementosSeleccionados; 
  }

  onRegresar() {
    this.regresar.emit();
  }

  // Método para mostrar el modal
  mostrarModalConfirmacion(): void {
    this.isVisibleModal = true;
  }

  limpiarSelecciones(): void {
    this.elementosAsignadosSeleccionado = [];
    this.hayElementosSeleccionados = false;
    this.mostrarBtnLimpiarSeleccion = false
    // Opcional: si necesitas desmarcar los checkboxes en la UI, puedes hacerlo aquí
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach((checkbox) => {
      (checkbox as HTMLInputElement).checked = false;
    });
  }
      
}
