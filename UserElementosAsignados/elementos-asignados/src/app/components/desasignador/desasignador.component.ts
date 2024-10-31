import { Component, EventEmitter, Output } from '@angular/core';
import { SharedService } from '../../services/shared.service';
import { UserElementoAsignadoM } from '../../models/user-elemento-asignado';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api.service';
import { forkJoin } from 'rxjs';
import { MessagesComponent } from "../../messages/messages.component";
import { SpinnerComponent } from "../../spinner/spinner.component";
import { TranslateModule, TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-desasignador',
  standalone: true,
  imports: [CommonModule, MessagesComponent, SpinnerComponent, TranslateModule],
  templateUrl: './desasignador.component.html',
  styleUrl: './desasignador.component.css'
})
export class DesasignadorComponent {
  elementosAsignadosInicio: UserElementoAsignadoM[] = [];
  elementosAsignadosSeleccionado: UserElementoAsignadoM[] = [];
  hayElementosSeleccionados: boolean = false; 
  @Output() regresar = new EventEmitter<void>();
  constructor(private sharedService: SharedService, private apiService: ApiService, private translate: TranslateService){}
  isLoading: boolean = false;
  isVisibleModal: boolean = false;
  mensajeModal: string = ''; 
  mostrarBtnLimpiarSeleccion: boolean = false
  @Output() mensajeExito = new EventEmitter<string>(); 
  @Output() mensajeError = new EventEmitter<string>();
  private elementosAsignadosOriginal: UserElementoAsignadoM[] = [];

  ngOnInit(): void {
    this.sharedService.userElementosAsignados$.subscribe((elementos) => {
      this.elementosAsignadosInicio = elementos;
      this.elementosAsignadosOriginal = [...elementos];
    });
  }

  desasignarElementos(): void {
    const user = this.apiService.getUser();
    const empresa = this.apiService.getEmpresa();
    if (this.elementosAsignadosSeleccionado.length === 0) {
      alert("No hay elementos seleccionados para desasignar.");
      return;
    }
    this.isLoading = true; 
    const desasignaciones = this.elementosAsignadosSeleccionado.map(elemento => {
      const model = {
        UserName: user,
        Elemento_Asignado: elemento.elemento_Asignado,
        mensaje: '',
        resultado: false,
      };
      return this.apiService.deleteUserElementoAsignado(model);
    });
  
    forkJoin(desasignaciones).subscribe({
      next: results => {
        const errores = results
          .flat()
          .filter((result: any) => !result.resultado);

          this.isLoading = false;  
        if (errores.length > 0) {
          const mensaje = errores.map(e => e.mensaje || 'Error desconocido').join(', ');
          console.error("Errores:", mensaje);
          this.mensajeError.emit(mensaje); // Emitimos el mensaje de error
          this.onRegresar();
        } else {
          this.elementosAsignadosSeleccionado = [];
          this.onRegresar();
          this.mostrarBtnLimpiarSeleccion = false;
          this.translate.get('infoTextos.elementosDesasignadosCorrectamente').subscribe(translatedMessage => {
            this.mensajeExito.emit(translatedMessage);
          });
        }
      },
      error: error => {
        console.error("Error al desasignar elementos:", error);
        this.isLoading = false;
      }
    });
  }

  // Funcion para seleccionar/deseleccionar todos los elementos
  toggleSelectAll(event: Event): void {
    const isChecked = (event.target as HTMLInputElement).checked;

    if (isChecked) {
      this.elementosAsignadosSeleccionado = [...this.elementosAsignadosInicio];
    } else {
      this.elementosAsignadosSeleccionado = [];
    }

    this.hayElementosSeleccionados = this.elementosAsignadosSeleccionado.length > 0;
    this.mostrarBtnLimpiarSeleccion = false
  }

  // Verifica si todos los elementos están seleccionados
  isAllSelected(): boolean {
    return this.elementosAsignadosInicio.length > 0 && 
           this.elementosAsignadosInicio.length === this.elementosAsignadosSeleccionado.length;
  }

  // Verifica si un elemento está seleccionado
  isSelected(elemento: UserElementoAsignadoM): boolean {
    return this.elementosAsignadosSeleccionado.includes(elemento);
  }

  seleccionElemento(elemento: UserElementoAsignadoM, event: Event): void {
    const inputElement = event.target as HTMLInputElement;  
  
    if (inputElement.checked) {
      this.elementosAsignadosSeleccionado.push(elemento);
    } else {
      // Remueve el elemento si el checkbox se desmarca
      this.elementosAsignadosSeleccionado = this.elementosAsignadosSeleccionado.filter(e => e.elemento_Asignado !== elemento.elemento_Asignado);
    }
    
    // Actualiza el estado del checkbox "Seleccionar Todos"
    this.hayElementosSeleccionados = this.elementosAsignadosSeleccionado.length > 0;
    this.mostrarBtnLimpiarSeleccion = this.hayElementosSeleccionados
  }


  onRegresar() {
    this.regresar.emit();
  }

  // Funcion para mostrar el modal
  mostrarModalConfirmacion(): void {
    this.isVisibleModal = true;
  }

  limpiarSelecciones(): void {
    this.elementosAsignadosSeleccionado = [];
    this.hayElementosSeleccionados = false;
    this.mostrarBtnLimpiarSeleccion = false
    //desmarcar los checkboxes en la UI, puedes hacerlo aquí
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach((checkbox) => {
      (checkbox as HTMLInputElement).checked = false;
    });
  }

  
  filtrarElementos(event: Event): void {
    const input = (event.target as HTMLInputElement).value.toLowerCase();

    if (input.length === 0) {
      // Si el input está vacío, restaurar todos los elementos
      this.elementosAsignadosInicio = [...this.elementosAsignadosOriginal];
    } else {
      // Filtrar elementos según la búsqueda
      this.elementosAsignadosInicio = this.elementosAsignadosOriginal.filter(elemento =>
        elemento.descripcion.toLowerCase().includes(input)
      );
    }
  }
      
}
