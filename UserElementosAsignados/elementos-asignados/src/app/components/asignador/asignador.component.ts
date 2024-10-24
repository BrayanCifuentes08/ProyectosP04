import { Component, EventEmitter, Output } from '@angular/core';
import { ElementosNoAsignadosM } from '../../models/elementos-no-asignados';
import { ApiService } from '../../services/api.service';
import { CommonModule } from '@angular/common';
import { UserElementoAsignadoM } from '../../models/user-elemento-asignado';
import { Router } from '@angular/router';
import { forkJoin } from 'rxjs';
import { MessagesComponent } from "../../messages/messages.component";

@Component({
  selector: 'app-asignador',
  standalone: true,
  imports: [CommonModule, MessagesComponent],
  templateUrl: './asignador.component.html',
  styleUrl: './asignador.component.css'
})
export class AsignadorComponent {
  elementosNoAsignados: ElementosNoAsignadosM[] = [];
  elementosSeleccionados: ElementosNoAsignadosM[] = [];
  isLoading: boolean = false;
  hayElementosSeleccionados: boolean = false;
  mostrarBtnAsignar: boolean = false;
  isVisibleModal: boolean = false;
  mensajeModal: string = ''; // Mensaje a mostrar en el modal
  mostrarBtnLimpiarSeleccion: boolean = false
  @Output() regresar = new EventEmitter<void>();
  
  constructor(private apiService: ApiService, private router: Router) {}

  ngOnInit(): void {
    this.obtenerElementosNoAsignados();
  }

  obtenerElementosNoAsignados(): void {
    this.isLoading = true;
    const model = {}; 
    this.apiService.getElementosNoAsigandos(model).subscribe({
      next: (data: ElementosNoAsignadosM[]) => {
        console.log(data)
        this.elementosNoAsignados = data;
        this.isLoading = false;
      },
      error: (error) => {
        this.isLoading = false; 
        console.error('Error al obtener los elementos:', error);
      }
    });
  }

  asignarElementos(): void {
    console.log("Iniciando la asignación de elementos.");
    if (this.elementosSeleccionados.length === 0) {
      alert("No hay elementos seleccionados para asignar.");
      return;
    }
  
    console.log("Elementos seleccionados:", this.elementosSeleccionados);
    const asignaciones = this.elementosSeleccionados.map(elemento => {
      const model = {
        UserName: 'AUDITOR01',
        Elemento_Asignado: elemento.elemento_Asignado,
      };
      return this.apiService.insertUserElementoAsignado(model);
    });
  
    forkJoin(asignaciones).subscribe({
      next: results => {
        console.log("Elementos asignados correctamente:", results);
        this.elementosSeleccionados = [];
        this.onRegresar();
        this.mostrarBtnLimpiarSeleccion = false; 
      },
      error: error => {
        console.error("Error al asignar elementos:", error);
      }
    });
  }

  seleccionElemento(elemento: ElementosNoAsignadosM, event: Event): void {
    const inputElement = event.target as HTMLInputElement;  
  
    if (inputElement.checked) {
      this.elementosSeleccionados.push(elemento);
      console.log("Elementos seleccionados", this.elementosSeleccionados)
    } else {
      // Remueve el elemento si el checkbox se desmarca
      this.elementosSeleccionados = this.elementosSeleccionados.filter(e => e.elemento_Asignado !== elemento.elemento_Asignado);
    }
      this.hayElementosSeleccionados = this.elementosSeleccionados.length > 0;
      this.mostrarBtnLimpiarSeleccion = this.hayElementosSeleccionados; 
  }

  onRegresar() {
    this.regresar.emit(); // Emitir el evento
  }

  // Método para mostrar el modal
  mostrarModalConfirmacion(): void {
      this.isVisibleModal = true;
  }

  limpiarSelecciones(): void {
    this.elementosSeleccionados = [];
    this.hayElementosSeleccionados = false;
    this.mostrarBtnLimpiarSeleccion = false
    // Opcional: si necesitas desmarcar los checkboxes en la UI, puedes hacerlo aquí
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach((checkbox) => {
      (checkbox as HTMLInputElement).checked = false;
    });
  }

}
