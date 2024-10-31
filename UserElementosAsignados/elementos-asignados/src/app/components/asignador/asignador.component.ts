import { Component, EventEmitter, Output } from '@angular/core';
import { ElementosNoAsignadosM } from '../../models/elementos-no-asignados';
import { ApiService } from '../../services/api.service';
import { CommonModule } from '@angular/common';
import { UserElementoAsignadoM } from '../../models/user-elemento-asignado';
import { Router } from '@angular/router';
import { forkJoin } from 'rxjs';
import { MessagesComponent } from "../../messages/messages.component";
import { SpinnerComponent } from "../../spinner/spinner.component";
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-asignador',
  standalone: true,
  imports: [CommonModule, MessagesComponent, SpinnerComponent, TranslateModule, FormsModule],
  templateUrl: './asignador.component.html',
  styleUrl: './asignador.component.css'
})
export class AsignadorComponent {
  elementosNoAsignados: ElementosNoAsignadosM[] = [];
  elementosSeleccionados: ElementosNoAsignadosM[] = [];
  elementosNoAsignadosOriginal: ElementosNoAsignadosM[] = [];
  isLoadingDatos: boolean = false;
  isLoading: boolean = false;
  hayElementosSeleccionados: boolean = false;
  mostrarBtnAsignar: boolean = false;
  isVisibleModal: boolean = false;
  isVisibleExito: boolean = false;
  mensajeModal: string = ''; // Mensaje a mostrar en el modal
  mostrarBtnLimpiarSeleccion: boolean = false
  @Output() regresar = new EventEmitter<void>();
  @Output() mensajeExito = new EventEmitter<string>(); 
  @Output() mensajeError = new EventEmitter<string>();
  searchTerm: string = '';
  constructor(private apiService: ApiService, private router: Router, private translate: TranslateService) {}

  ngOnInit(): void {
    this.obtenerElementosNoAsignados();
  }

  obtenerElementosNoAsignados(): void {
    this.isLoadingDatos = true;
    const model = {}; 
    this.apiService.getElementosNoAsigandos(model).subscribe({
      next: (data: ElementosNoAsignadosM[]) => {
        console.log(data)
        this.elementosNoAsignados = data;
        this.elementosNoAsignadosOriginal = [...data];
        this.isLoadingDatos = false;
      },
      error: (error) => {
        this.isLoadingDatos = false; 
        console.error('Error al obtener los elementos:', error);
      }
    });
  }

  asignarElementos(): void {
    const user = this.apiService.getUser();
    const empresa = this.apiService.getEmpresa();
    if (this.elementosSeleccionados.length === 0) {
      alert("No hay elementos seleccionados para asignar.");
      return;
    }
    this.isLoading = true;
    const asignaciones = this.elementosSeleccionados.map(elemento => {
      const model = {
        UserName: user,
        Elemento_Asignado: elemento.elemento_Asignado,
        mensaje: '',
        resultado: false
      };
      return this.apiService.insertUserElementoAsignado(model);
    });

    forkJoin(asignaciones).subscribe({
      next: results => {
        const errores = results
          .flat()
          .filter((result: any) => !result.resultado);

        if (errores.length > 0) {
          const mensaje = errores.map(e => e.mensaje || 'Error desconocido').join(', ');
          console.error("Errores:", mensaje);
          this.mensajeError.emit(mensaje); // Emitimos el mensaje de error
        } else {
          this.elementosSeleccionados = [];
          this.mostrarBtnLimpiarSeleccion = false;
          this.translate.get('infoTextos.elementosAsignadosCorrectamente').subscribe(translatedMessage => {
            this.mensajeExito.emit(translatedMessage);
          });
        }
        this.onRegresar();
        this.isLoading = false;
      },
      error: error => {
        console.error("Error al asignar elementos:", error);
        this.mensajeError.emit('Ocurrió un error en la asignación.');
        this.isLoading = false;
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

  filtrarElementos(event: Event): void {
    const input = (event.target as HTMLInputElement).value.toLowerCase();
  
    if (input.length === 0) {
      // Si el input está vacío, se muestran todos los elementos sin perder las selecciones
      this.elementosNoAsignados = [...this.elementosNoAsignadosOriginal];
    } else {
      // Filtrar elementos según la búsqueda
      this.elementosNoAsignados = this.elementosNoAsignadosOriginal.filter(elemento =>
        elemento.descripcion.toLowerCase().includes(input)
      );
    }
  }
  
   
  clearInput(inputElement: HTMLInputElement): void {
    this.searchTerm = ''; // Limpiar el contenido
    inputElement.focus(); // Volver a enfocar el input
    this.elementosNoAsignados = [...this.elementosNoAsignadosOriginal]; // Restaurar todos los elementos
  }
}
