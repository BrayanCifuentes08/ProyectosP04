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
  isVisibleExito: boolean = false;
  mensajeModal: string = ''; // Mensaje a mostrar en el modal
  mostrarBtnLimpiarSeleccion: boolean = false
  @Output() regresar = new EventEmitter<void>();
  @Output() mensajeExito = new EventEmitter<string>(); 
  
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
        mensaje: '',
        resultado: false
      };
      return this.apiService.insertUserElementoAsignado(model);
    });
  
    forkJoin(asignaciones).subscribe({
      next: results => {
        console.log("Elementos asignados correctamente:", results);
        this.elementosSeleccionados = [];
        this.onRegresar();
        this.mostrarBtnLimpiarSeleccion = false; 
        this.mensajeExito.emit('Elementos asignados correctamente.');
      },
      error: error => {
        console.error("Error al asignar elementos:", error);
      }
    });
  }

  // Funcion para seleccionar/deseleccionar todos los elementos
  toggleSelectAll(event: Event): void {
    const isChecked = (event.target as HTMLInputElement).checked;

    if (isChecked) {
      this.elementosSeleccionados = [...this.elementosNoAsignados];
    } else {
      this.elementosSeleccionados = [];
    }

    this.hayElementosSeleccionados = this.elementosSeleccionados.length > 0;
    this.mostrarBtnLimpiarSeleccion = false
  }

  // Verifica si todos los elementos están seleccionados
  isAllSelected(): boolean {
    return this.elementosNoAsignados.length > 0 && 
           this.elementosNoAsignados.length === this.elementosSeleccionados.length;
  }

  // Verifica si un elemento específico está seleccionado
  isSelected(elemento: ElementosNoAsignadosM): boolean {
    return this.elementosSeleccionados.includes(elemento);
  }

  seleccionElemento(elemento: ElementosNoAsignadosM, event: Event): void {
    const inputElement = event.target as HTMLInputElement;  
  
    if (inputElement.checked) {
      this.elementosSeleccionados.push(elemento);
    } else {
      // Remueve el elemento si el checkbox se desmarca
      this.elementosSeleccionados = this.elementosSeleccionados.filter(e => e.elemento_Asignado !== elemento.elemento_Asignado);
    }
    
    // Actualiza el estado del checkbox "Seleccionar Todos"
    this.hayElementosSeleccionados = this.elementosSeleccionados.length > 0;
    this.mostrarBtnLimpiarSeleccion = this.hayElementosSeleccionados
  }

  
  limpiarSelecciones(): void {
    this.elementosSeleccionados = [];
    this.hayElementosSeleccionados = false;
    this.mostrarBtnLimpiarSeleccion = false
    //desmarcar los checkboxes en la UI, puedes hacerlo aquí
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach((checkbox) => {
      (checkbox as HTMLInputElement).checked = false;
    });
  }

  
  onRegresar() {
    this.regresar.emit(); // Emitir el evento
  }

  // Funcion para mostrar el modal
  mostrarModalConfirmacion(): void {
      this.isVisibleModal = true;
  }

}
