import { ChangeDetectorRef, Component, ElementRef, ViewChild } from '@angular/core';
import { SharedService } from '../../services/shared.service';
import { MigrarSqlService } from '../../services/migrar-sql.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export class DashboardComponent {
  fileSeleccionado: File | null = null;
  hojas: string[] = [];
  hojasSeleccionadas: string[] = [];
  cargandoHojas: boolean = false;
  mostrarMensajeAdvertencia: boolean = false;
  isVisibleModal: boolean = false;
  isVisibleExito: boolean = false;
  mensajeExito: string = '';
  isVisibleAlerta: boolean = false;
  mensajeAlerta: string = '';
  @ViewChild('fileInput') fileInput: ElementRef | undefined;
  rutaOrigen: string | null = null;
  mostrarArea: boolean = false;
  mostrarAreaSubida: boolean = true;
  cargandoTraslado: boolean = false;
  nombreArchivo: string = '';
  
  constructor(private sharedService:SharedService, private migrarSqlService: MigrarSqlService, private cdr: ChangeDetectorRef){}

  ngOnInit(){
    this.sharedService.setAccion('vistaModulo');
  }

  cargarFile(event: any): void {
    const file: File = event.target.files[0];
    // Validar si ya hay un archivo cargado
    if (this.fileSeleccionado) {
      this.mostrarMensajeAdvertencia = true;
      event.target.value = '';  // Limpiar el input de archivo
      setTimeout(() => {
        this.mostrarMensajeAdvertencia = false;
      }, 7000);
      return;
    }

    this.hojas = [];
    if (file) {
      this.sharedService.setAccion('cargaHojas');
      this.fileSeleccionado = file;
      this.mostrarAreaSubida = false;
      console.log("Hojas antes de solicitud: ", this.hojas)
      console.log('Archivo seleccionado:', file);
      this.cargandoHojas = true;
      // Llamada al método obtenerHojasExcel
      this.migrarSqlService.obtenerHojasExcel(file).subscribe({
        next: (hojas: string[]) => {
          this.hojas = hojas; // Asigna las hojas obtenidas a la variable local
          this.cargandoHojas = false;
          this.sharedService.setAccion('exitoHojasCargadas');
          console.log('Hojas obtenidas:', hojas);
        },
        error: (err) => {
          console.error('Error al obtener hojas:', err); // Manejo de errores
          this.sharedService.setAccion('errorCarga');
          this.cargandoHojas = false;
        }
      });
    }
  }

  trasladarDatos(): void {
    if (this.cargandoTraslado) {
      return; // Evitar múltiples solicitudes si ya está en curso
    }

    this.cargandoTraslado = true;
    console.log('Ejecutando traslado datos');
    const selectedFile = this.fileSeleccionado;
    if (!selectedFile) {
      this.mostrarMensajeAdvertencia = true;
      setTimeout(() => {
        this.mostrarMensajeAdvertencia = false;
      }, 5000);
      this.cargandoTraslado = false;
      return;
    }

    if (this.hojasSeleccionadas.length > 0) {
      const formData = new FormData();
      formData.append('ArchivoExcel', selectedFile, selectedFile.name);

      // Iterar sobre las hojas seleccionadas y agregar cada una al FormData
      this.hojasSeleccionadas.forEach(hoja => {
        formData.append('NombresHojasExcel', hoja);
      });

      this.migrarSqlService.enviarDatos(formData).subscribe({
        next: (blob: Blob) => {
          const nombreArchivoOriginal = this.fileSeleccionado
            ? this.fileSeleccionado.name.replace(/\.[^/.]+$/, '.xlsx')
            : 'archivoActualizado.xlsx';

          // Crear un enlace para descargar el archivo
          const url = window.URL.createObjectURL(blob);
          const a = document.createElement('a');
          a.href = url;
          a.download = nombreArchivoOriginal;
          document.body.appendChild(a);
          a.click();
          document.body.removeChild(a);
          window.URL.revokeObjectURL(url); // Liberar el objeto Blob
          this.manejarMensajeExito('Archivo descargado correctamente.');
          setTimeout(() => {
            this.actualizarInterfaz();
          }, 7000);
        },
        error: (err) => {
          this.cargandoTraslado = false;
          console.error('Error al realizar la solicitud:', err);

          let errorMessage = 'Error desconocido al realizar la solicitud';

          if (err?.error instanceof Blob) {
            const reader = new FileReader();
            reader.onload = () => {
              errorMessage = reader.result as string;
              console.log('Mensaje de error del servidor:', errorMessage);
              this.manejarMensajeError(errorMessage);
            };

            reader.onerror = () => {
              console.error('Error al leer el blob de error:', reader.error);
              this.manejarMensajeError(errorMessage);
            };

            reader.readAsText(err.error);
          } else if (err?.message) {
            errorMessage = err.message;
            this.manejarMensajeError(errorMessage);
          } else {
            this.manejarMensajeError(errorMessage);
          }

          setTimeout(() => {
            this.actualizarInterfaz();
          }, 7000);
        },
        complete: () => {
          this.cargandoTraslado = false; // Restablecer el estado al finalizar
          this.hojasSeleccionadas = [];
          setTimeout(() => {
            this.actualizarInterfaz();
          }, 7000);
        }
      });
    } else {
      this.cargandoTraslado = false;
      this.mostrarMensajeAdvertencia = true;
      setTimeout(() => {
        this.mostrarMensajeAdvertencia = false;
      }, 7000);
    }
  }


  private actualizarInterfaz(): void {
    console.log('Actualizando la interfaz...');
    
    // Reiniciar variables relacionadas con el proceso
    this.fileSeleccionado = null;
    this.hojas = [];
    this.hojasSeleccionadas = [];
    this.mostrarAreaSubida = true;
    this.cargandoTraslado = false;
    this.cargandoHojas = false;
    window.location.reload();
    // Si es necesario recargar datos o vistas
    this.sharedService.setAccion('vistaModulo'); // Notificar cambio de vista
  }
  
  seleccionarHoja(hoja: string, event: Event): void {
    const checked = (event.target as HTMLInputElement).checked;
    
    if (checked) {
      this.hojasSeleccionadas.push(hoja);  // Añadir la hoja seleccionada
    } else {
      const index = this.hojasSeleccionadas.indexOf(hoja);
      if (index > -1) {
        this.hojasSeleccionadas.splice(index, 1);  // Eliminar la hoja deseleccionada
      }
    }
  
    console.log('Hojas seleccionadas:', this.hojasSeleccionadas);  // Verifica las hojas seleccionadas
  }
  
  //Función para borrar el archivo
  removerFile(): void {
    // Si existe el fileInput, limpiamos el valor
    if (this.fileInput) {
      this.fileInput.nativeElement.value = ''; // Limpiar el input
    }
    this.fileSeleccionado = null;
    this.hojas = [];
    this.mostrarMensajeAdvertencia = false;
    this.hojasSeleccionadas = [];
    this.mostrarAreaSubida = true;
    this.sharedService.setAccion('vistaModulo');

    console.log('Archivo eliminado');
  }

  mostrarModalTraslado(): void {
    console.log("Ejecutando modal para el traslado");
    this.isVisibleModal = true;
  }

  manejarMensajeExito(mensaje: string): void {
    this.mensajeExito = mensaje;
    this.isVisibleExito = true;

    setTimeout(() => {
      this.ocultarExito();
    }, 4000);
  }

  manejarMensajeError(mensaje: string): void {
    this.mensajeAlerta = mensaje;
    this.isVisibleAlerta = true;
    setTimeout(() => {
      this.ocultarAlerta();
    }, 4000);
  }

  ocultarExito(){
    this.isVisibleExito = false;
  }

  ocultarAlerta(){
    this.isVisibleAlerta = false;
  }
}