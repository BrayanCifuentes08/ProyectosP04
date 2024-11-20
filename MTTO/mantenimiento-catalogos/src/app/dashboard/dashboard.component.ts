import { CommonModule } from '@angular/common';
import { Component, Input, OnInit } from '@angular/core';
import { SharedService } from '../services/shared.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { ApiService } from '../services/api.service';
import { estadoInputsTipoCanalDistribucionInsert, estadoInputsTipoCanalDistribucionUpdate, ParamsTipoCanalDistribucion, tipoCanalDistribucion } from '../models/tipo-canal-distribucion';
import { MessagesComponent } from "../components/messages/messages.component";
import { FormsModule } from '@angular/forms';
import { estadoInputsCanalDistribucionInsert, estadoInputsCanalDistribucionUpdate } from '../models/canal-distribucion';
import { estadoInputsElementoAsignadoInsert, estadoInputsElementoAsignadoUpdate } from '../models/elemento-asignado';
import { estadoInputsUserInsert, estadoInputsUserUpdate } from '../models/user';

enum Accion {
  Eliminar = 'eliminar',
  Actualizar = 'actualizar',
  Agregar = 'agregar'
}
@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, TranslateModule, MessagesComponent, FormsModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css',
})

export default class DashboardComponent implements OnInit {
  isVisibleContenedor1:     boolean = false;
  isVisibleContenedor2:     boolean = false;
  isVisibleAlerta:          boolean = false; 
  isVisibleModal:           boolean = false;  
  isVisibleExito:           boolean = false;
  cargando:                 boolean = false; 
  mostrarBtnAgregar:        boolean = true;
  mostrarBtnActualizar:     boolean = false;
  mostrarBtnBorrar:         boolean = false;
  inputsHabilitados:        boolean = false;
  mostrarBtnGuardar:        boolean = false;
  isVisualizandoCatalogo:   boolean = false;
  isVisualizandoRegistro:   boolean = false;
  isAgregandoRegistro:      boolean = false;
  mensajeAlerta:            string = ''; 
  mensajeModal:             string =  '';  
  mensajeExito:             string =  '';
  catalogoSeleccionado:     string | null = null; // Almacena el catalogo seleccionado
  errorMessage:             string | null = null; 
  opcionSeleccionada:       string | null = null; 
  descripciones:            string[] = []; // Para almacenar las descripciones
  descripcionesTipoCanalDistribucion: string[] = [];
  descripcionesCanalDistribucion:     string[] = [];
  descripcionesElementoAsignado:      string[] = [];
  descripcionesUser:                  string[] = [];
  tiposCanalDistribucionData:         any[] = [];
  canalDistribucionData:              any[] = [];
  elementoAsignadoData:               any[] = [];
  userData:                           any[] = [];
  registros:                          any[] = [];
  campoEstado:  number = 0;
  accionConfirmar:                    { catalogo: string, accion: Accion } | null = null;

  constructor(private sharedService: SharedService, private apiService: ApiService){}

  ngOnInit() {
    console.log("Aplicacion de login: ", this.apiService.getAplicacion())
    this.sharedService.catalogoSeleccionado$.subscribe((catalogo) => {
      this.catalogoSeleccionado = catalogo;
        //this.descripciones = this.obtenerDescripciones();
        this.generarRegistros(catalogo ?? '');
        this.reiniciarEstado()
        this.isVisualizandoCatalogo = true;
        this.sharedService.setAccion('visualizandoCatalogo');
    });
    setTimeout(() => {
      this.isVisibleContenedor1 = true;
      this.isVisibleContenedor2 = true;
    }, 150);
  }

  reiniciarEstado() {
    this.isVisualizandoRegistro = false;
    this.isAgregandoRegistro = false;
    this.sharedService.setAccion('');
  }

  generarRegistros(catalogo: string) {
    this.registros = [];
    this.descripciones = [];
    this.mostrarBtnBorrar = false;
    this.mostrarBtnActualizar = false;
    this.opcionSeleccionada = null;
    this.limpiarInputs();

    console.log(`Catálogo seleccionado: ${catalogo}`);
  
    switch (catalogo) {
        case 'Tipo Canal Distribucion':
        this.obtenerTipoCanalDistribucion(1);
        return;

        case 'Canal Distribucion':
          this.obtenerCanalDistribucion(1);  
        return;
      
        case 'Elemento Asignado':
          this.obtenerElementoAsignado(1);  
        return;

        case 'User':
          this.obtenerUser(1);  
        return;

      default:
        this.descripciones.push('Catálogo no definido');
        break;
        
    }

  }

  onDescripcionSeleccionada(descripcion: string) {
    console.log(`Descripción seleccionada: ${descripcion}`); 
    this.isVisualizandoRegistro = true;
    this.sharedService.setAccion('visualizandoRegistro');
    const registroSeleccionado = this.registros.find(registro => 
      registro.descripcion === descripcion || registro.name === descripcion
    );
  
    if (registroSeleccionado) {
      console.log('Registro seleccionado:', registroSeleccionado);
      this.mostrarInputs(registroSeleccionado);
      this.mostrarBtnActualizar = true;
      this.mostrarBtnBorrar = true;
      this.mostrarBtnAgregar = false;
      this.mostrarBtnGuardar = false;
    } else {
      console.log('No se encontró coincidencia, limpiando inputs'); 
      this.limpiarInputs(); 
      this.mostrarBtnActualizar = false;
      this.mostrarBtnBorrar = false;
      this.mostrarBtnAgregar = true; 
    }
  }

  getAccion(catalogo: string, accion: Accion): string | null {
    return `${accion}${catalogo.replace(/\s/g, '')}`; 
  }

  //*FUNCIONES QUE CONTROLAN LAS ACCIONES DEL CRUD PARA LOS CATALOGOS
  eliminarRegistros() {
    if (!this.catalogoSeleccionado) {
      this.mostrarMensajeAlerta('No se ha seleccionado ningún catálogo.');
      return;
    }

    this.mostrarMensajeModal(Accion.Eliminar);
    this.isVisibleModal = true;
    this.isVisibleAlerta = false;
    
    // Aquí se establece la acción confirmada
    this.accionConfirmar = { catalogo: this.catalogoSeleccionado, accion: Accion.Eliminar };
  }

  actualizarRegistro() {
    if (!this.catalogoSeleccionado) {
      this.mostrarMensajeAlerta('No se ha seleccionado ningún catálogo.');
      return;
    }

    this.mostrarMensajeModal(Accion.Actualizar);
    this.isVisibleModal = true;
    this.isVisibleAlerta = false;
    this.accionConfirmar = { catalogo: this.catalogoSeleccionado, accion: Accion.Actualizar };
  }

  agregarRegistros() {
    const inputsVacios = this.validarInputs(); // Valida los inputs
    
    if (inputsVacios.length > 0) {
      const mensajeVacios = `Los siguientes campos están vacíos: ${inputsVacios.join(', ')}`;
      this.mostrarMensajeAlerta(mensajeVacios);
      return;
    }

    if (!this.catalogoSeleccionado) {
      this.mostrarMensajeAlerta('No se ha seleccionado ningún catálogo.');
      return;
    }

    this.mostrarMensajeModal(Accion.Agregar);
    this.isVisibleModal = true;
    this.isVisibleAlerta = false;
    this.accionConfirmar = { catalogo: this.catalogoSeleccionado, accion: Accion.Agregar };
    this.mostrarInputs(); 
  }
  
  confirmarAccion() {
    this.isVisibleModal = false; 
    if (!this.accionConfirmar) return;

    const { catalogo, accion } = this.accionConfirmar;

    switch (accion) {
      case Accion.Eliminar:
        if (catalogo === 'Tipo Canal Distribucion') {
          this.obtenerTipoCanalDistribucion(4);
        } else if (catalogo === 'Canal Distribucion') {
          this.obtenerCanalDistribucion(4); 
        } else if ((catalogo === 'Elemento Asignado')){
          this.obtenerElementoAsignado(4);
        } else if ((catalogo === 'User')){
          this.obtenerUser(4);
        }
        this.mostrarMensajeExito('Registro eliminado con éxito.');
        break;
      case Accion.Actualizar:
        if (catalogo === 'Tipo Canal Distribucion') {
          this.obtenerTipoCanalDistribucion(3); 
        } else if (catalogo === 'Canal Distribucion') {
          this.obtenerCanalDistribucion(3); 
        } else if ((catalogo === 'Elemento Asignado')){
          this.obtenerElementoAsignado(3);
        } else if ((catalogo === 'User')){
          this.obtenerUser(3);
        }
        this.mostrarMensajeExito('Registro actualizado con éxito.');
        break;
      case Accion.Agregar:
        if (catalogo === 'Tipo Canal Distribucion') {
          this.obtenerTipoCanalDistribucion(2);
        } else if (catalogo === 'Canal Distribucion') {
          this.obtenerCanalDistribucion(2);
        } else if ((catalogo === 'Elemento Asignado')){
          this.obtenerElementoAsignado(2);
        } else if ((catalogo === 'User')){
          this.obtenerUser(2);
        }
        this.mostrarMensajeExito('Registro agregado con éxito.');
        break;
      default:
        break;
    }

    this.actualizarLista(); 
    this.limpiarInputs();
    this.mostrarBtnActualizar = false;
    this.mostrarBtnBorrar = false;
    this.mostrarBtnAgregar = true;
    this.accionConfirmar = null; // Reinicia la acción
  }

  cancelarAccion() {
    this.isVisibleModal = false; // Oculta el modal
    this.accionConfirmar = null; // Reinicia la acción
  }

  actualizarLista() {
    if (!this.catalogoSeleccionado) {
      this.mostrarMensajeAlerta('No se ha seleccionado ningún catálogo.');
      return;
    }
    this.opcionSeleccionada = null;
    this.generarRegistros(this.catalogoSeleccionado); // Reutiliza la lógica de generación de registros
  }

  //*FUNCIONES QUE OBTIENEN LOS DATOS DE LOS CATALOGOS
  obtenerCanalDistribucion(accion: number) {
    const user = this.apiService.getUser();
    const empresa = this.apiService.getEmpresa();
    const model: any = {
        accion: accion,
        pCriterioBusqueda: '',
        pBodega: 0,
        pTipoCanalDistribucion: 0,
        pDescripcion: '',
        pEstado: 0,
        pFecha_Hora: '',
        pUserName: user
    };

    // Captura los valores de los inputs
    const inputs: HTMLCollectionOf<HTMLInputElement> = document.getElementsByTagName('input');

    for (let input of Array.from(inputs)) {
        switch (input.name) {
            case 'descripcion':
                model.pDescripcion = input.value;
                break;
            case 'criterioBusqueda':
                model.pCriterioBusqueda = input.value;
                break;
            case 'tipoCanalDistribucion':
                model.pTipoCanalDistribucion = Number(input.value);
                break;
            case 'estado':
              model.pEstado = this.campoEstado  ;
                break;
            case 'bodega':
                model.pBodega = Number(input.value);
                break;
            case 'userName':
                model.pUserName = input.value || user;
                break;
            case 'fecha_Hora':
                if (input.value) {
                    const fechaInput = new Date(input.value);
                    if (!isNaN(fechaInput.getTime())) {
                        model.pFecha_Hora = fechaInput.toISOString(); // Solo convertir si es una fecha válida
                    } else {
                        console.warn('Valor de fecha inválido:', input.value);
                        model.pFecha_Hora = ''; // O asigna un valor predeterminado si lo prefieres
                    }
                } else {
                    model.pFecha_Hora = ''; // Si está vacío, asigna una cadena vacía o un valor predeterminado
                }
                break; 
            default:
                break;
        }
    }

    this.cargando = true;
    this.errorMessage = null;
    // Llama a la API con los datos capturados
    this.apiService.getCanalDistribucion(model).subscribe({
        next: (data: any) => {
            console.log('Datos recibidos:', data);
            
            if (data && data.resultado === false) {
              // Si hay un error de la base de datos (resultado: false)
              this.mostrarMensajeAlerta(data.mensaje);
            } else if (data && data.length > 0) {
              this.canalDistribucionData = data;
              this.registros = this.canalDistribucionData; 
              this.descripcionesCanalDistribucion = this.canalDistribucionData.map(
                (registro) => registro.descripcion || ''
              );
                
              this.mostrarBtnGuardar = false;
            } else {
              console.warn('No se encontraron registros.');
              this.limpiarInputs();
            }
            this.cargando = false;
        },
        error: (error) => {
            this.cargando = false;
            console.error('Error al obtener el canal distribución:', error);
            this.mostrarMensajeAlerta('Hubo un error al obtener los registros. Inténtalo de nuevo.');
        }
    });
  }

  obtenerTipoCanalDistribucion(accion: number) {
    const user = this.apiService.getUser();
    const empresa = this.apiService.getEmpresa();
    const model: any = {
      accion: accion,
      pDescripcion: '',
      pCriterioBusqueda: '',
      pTipoCanalDistribucion: 0,
      pEstado: 0,
      pFecha_Hora: '',
      pUserName: user
    };
    // Captura los valores de los inputs
    const inputs: HTMLCollectionOf<HTMLInputElement> = document.getElementsByTagName('input');

    for (let input of Array.from(inputs)) {
        switch (input.name) {
            case 'descripcion':
                model.pDescripcion = input.value;
                break;
            case 'criterioBusqueda':
                model.pCriterioBusqueda = input.value;
                break;
            case 'tipoCanalDistribucion':
                model.pTipoCanalDistribucion = Number(input.value);
                break;
            case 'estado':
                model.pEstado = this.campoEstado;
                break;
                case 'userName':
                model.pUserName = input.value || user;
                break;
            case 'fecha_Hora':
                if (input.value) {
                    const fechaInput = new Date(input.value);
                    if (!isNaN(fechaInput.getTime())) {
                        model.pFecha_Hora = fechaInput.toISOString(); // Solo convertir si es una fecha válida
                    } else {
                        console.warn('Valor de fecha inválido:', input.value);
                        model.pFecha_Hora = ''; // O asigna un valor predeterminado si lo prefieres
                    }
                } else {
                    model.pFecha_Hora = ''; // Si está vacío, asigna una cadena vacía o un valor predeterminado
                }
                break;          
            default:
                break;
        }
    }

    this.cargando = true;
    this.errorMessage = null;
    this.apiService.getTipoCanalDistribucion(model).subscribe({
      
        next: (data: any) => {
            console.log('Datos recibidos:', data);
            
            if (data && data.resultado === false) {
              this.mostrarMensajeAlerta(data.mensaje);
            } else if (data && data.length > 0) {
                this.tiposCanalDistribucionData = data;
                this.registros = this.tiposCanalDistribucionData; 
                this.descripcionesTipoCanalDistribucion = this.tiposCanalDistribucionData.map(
                  (registro) => registro.descripcion || ''
                );
                
                this.mostrarBtnGuardar = false;
              } else {
                console.warn('No se encontraron registros.');
                this.limpiarInputs();
              }
              this.cargando = false;
        },
        error: (error) => {
            this.cargando = false;
            console.error('Error al obtener el tipo canal distribución:', error);
            this.mostrarMensajeAlerta('Hubo un error al obtener los registros. Inténtalo de nuevo.');
        }
    });
  }

  obtenerElementoAsignado(accion: number) {
    const user = this.apiService.getUser();
    const empresa = this.apiService.getEmpresa();
    const model: any = {
        accion: accion,
        pCriterioBusqueda: '',
        pElementoAsignado: 0,
        pElementoId: 0,
        pUserName: user,
        pEmpresa: empresa,
        pDescripcion: '',
        pEstado: 0,
        pFecha_Hora: '',
    };

    // Captura los valores de los inputs
    const inputs: HTMLCollectionOf<HTMLInputElement> = document.getElementsByTagName('input');

    for (let input of Array.from(inputs)) {
        switch (input.name) {
            case 'descripcion':
                model.pDescripcion = input.value;
                break;
            case 'criterioBusqueda':
                model.pCriterioBusqueda = input.value;
                break;
            case 'elemento_Asignado':
                model.pElementoAsignado = Number(input.value);
                break;
            case 'estado':
              model.pEstado = this.campoEstado;
                break;
            case 'elemento_Id':
                model.pElementoId = Number(input.value);
                break;
            case 'empresa':
                model.pEmpresa = Number(input.value);
                break;
            case 'userName':
                model.pUserName = input.value || user;
                break;
            case 'fecha_Hora':
                if (input.value) {
                    const fechaInput = new Date(input.value);
                    if (!isNaN(fechaInput.getTime())) {
                        model.pFecha_Hora = fechaInput.toISOString(); // Solo convertir si es una fecha válida
                    } else {
                        console.warn('Valor de fecha inválido:', input.value);
                        model.pFecha_Hora = ''; // O asigna un valor predeterminado si lo prefieres
                    }
                } else {
                    model.pFecha_Hora = ''; // Si está vacío, asigna una cadena vacía o un valor predeterminado
                }
                break; 
            default:
                break;
        }
    }

    this.cargando = true;
    this.errorMessage = null;
    // Llama a la API con los datos capturados
    this.apiService.getElementosAsignados(model).subscribe({
        next: (data: any) => {
            console.log('Datos recibidos:', data);
            
            if (data && data.resultado === false) {
              // Si hay un error de la base de datos (resultado: false)
              this.mostrarMensajeAlerta(data.mensaje);
            } else if (data && data.length > 0) {
              this.elementoAsignadoData = data;
              this.registros = this.elementoAsignadoData; 
              this.descripcionesElementoAsignado = this.elementoAsignadoData.map(
                  (registro) => registro.descripcion || ''
                );
                
                this.mostrarBtnGuardar = false;
            } else {
              console.warn('No se encontraron registros.');
              this.limpiarInputs();
            }
            this.cargando = false;
          },
        error: (error) => {
            this.cargando = false;
            console.error('Error al obtener el elemento asignado:', error);
            this.mostrarMensajeAlerta('Hubo un error al obtener los registros. Inténtalo de nuevo.');
        }
    });
  }

  obtenerUser(accion: number) {
    const user = this.apiService.getUser();
    const empresa = this.apiService.getEmpresa();
    const estacionTrabajo = this.apiService.getEstacion();
    const application = this.apiService.getAplicacion();
    const model: any = {
        pUserName: '',
        accion: accion,
        pCriterioBusqueda: '',
        pName: '',
        pCelular: '',
        pEMail: '',
        pFecha_Hora: '',
        //Nuevos parametros
        pEmpresa: empresa,
        pEstacion_Trabajo: estacionTrabajo.id,
        pApplication: application,
        pPass: '',
        pDisable: false,
    };

    // Captura los valores de los inputs
    const inputs: HTMLCollectionOf<HTMLInputElement> = document.getElementsByTagName('input');

    for (let input of Array.from(inputs)) {
        switch (input.name) {
            case 'descripcion':
                model.pDescripcion = input.value;
                break;
                case 'userName':
                  model.pUserName = input.value;
                  break;
            case 'criterioBusqueda':
                model.pCriterioBusqueda = input.value;
                break;
            case 'name':
                model.pName = input.value;
                break;
            case 'celular':
                model.pCelular = Number(input.value);
                break;
            case 'eMail':
                model.pEMail = input.value;
                break;
            case 'Empresa':
                model.pEmpresa = input.value || empresa;
                break;
            case 'Estacion_Trabajo':
                model.pEstacion_Trabajo = input.value || estacionTrabajo;
                break;
            case 'Application':
                model.pApplication = input.value || application;
                break;
            case 'pass_Key':
              model.pPass = input.value.trim();  // Quitar espacios en blanco al inicio y al final
              if (!model.pPass) {
                  model.pPass = null;  // O asigna un valor predeterminado, como un valor de hash si es necesario
              }
                break;
            case 'disable':
                  model.pDisable = this.campoEstado == 1 ? true : false;
                  break;
            case 'fecha_Hora':
                if (input.value) {
                    const fechaInput = new Date(input.value);
                    if (!isNaN(fechaInput.getTime())) {
                        model.pFecha_Hora = fechaInput.toISOString(); // Solo convertir si es una fecha válida
                    } else {
                        console.warn('Valor de fecha inválido:', input.value);
                        model.pFecha_Hora = ''; // O asigna un valor predeterminado si lo prefieres
                    }
                } else {
                    model.pFecha_Hora = ''; // Si está vacío, asigna una cadena vacía o un valor predeterminado
                }
                break; 
            default:
                break;
        }
    }

    this.cargando = true;
    this.errorMessage = null;
    // Llama a la API con los datos capturados
    this.apiService.getCatalogoUser(model).subscribe({
        next: (data: any) => {
            console.log('Datos recibidos:', data);
            
            if (data && data.resultado === false) {
              // Si hay un error de la base de datos (resultado: false)
              this.mostrarMensajeAlerta(data.mensaje);
            } else if (data && data.length > 0) {
              this.userData = data;
              this.registros = this.userData; 
              this.descripcionesUser = this.userData.map(
                (registro) => registro.name || ''
              );
              this.mostrarBtnGuardar = false;
            } else {
              console.warn('No se encontraron registros.');
              this.limpiarInputs();
            }
            this.cargando = false;
        },
        error: (error) => {
            this.cargando = false;
            console.error('Error al obtener el user:', error);
            this.mostrarMensajeAlerta('Hubo un error al obtener los registros. Inténtalo de nuevo.');
        }
    });
  }
  
  getDescripciones(): string[] {
    if (this.catalogoSeleccionado === 'Canal Distribucion') {
      return this.descripcionesCanalDistribucion;
    } else if (this.catalogoSeleccionado === 'Tipo Canal Distribucion') {
      return this.descripcionesTipoCanalDistribucion;
    } else if (this.catalogoSeleccionado === 'Elemento Asignado') {
      return this.descripcionesElementoAsignado;
    } else if (this.catalogoSeleccionado === 'User') {
      return this.descripcionesUser;
    } else {
      return [];
    }
  }
  
  //*FUNCIONES PARA MANEJAR LOS INPUT DINAMICOS EN LA INTERFAZ
  mostrarInputs(registro: any = null) {
    const inputContainer = document.getElementById('inputContainer');

    if (!inputContainer) {
      console.error('El contenedor de inputs no se encontró.');
      return;
    }

    if (registro === null && inputContainer.innerHTML.trim() !== '') {
      return; // Si ya hay inputs, no limpiarlos
    }

    inputContainer.innerHTML = '';
    
    const camposExcluidos = ['mensaje', 'resultado'];
    const plantillaRegistro = this.registros[0] || {};

    for (const key in plantillaRegistro) {
      if (plantillaRegistro.hasOwnProperty(key) && !camposExcluidos.includes(key)) {
        const valor = registro && registro[key] !== undefined ? registro[key] : '';
        const tipo = typeof valor;

        const div = document.createElement('div');
        div.className = 'flex flex-col mb-4';

        const label = document.createElement('label');
        label.className = 'mb-1 text-sm font-semibold text-gray-600 dark:text-gray-300';
        label.textContent = `${key.charAt(0).toUpperCase() + key.slice(1)}:`;
        div.appendChild(label);

        let input: HTMLInputElement;

        if (key === 'estado' || key == 'disable') {
          // Crear un checkbox para 'estado'
          input = document.createElement('input');
          input.type = 'checkbox';
          input.className = 'toggle-switch';
          input.checked = registro ? Boolean(valor) : true; // Establecer el valor booleano correctamente
          input.name = key; // Asegúrate de que esto esté configurado

          // Actualizar el valor de pEstado cuando el checkbox cambie
          input.addEventListener('change', () => {
            registro[key] = input.checked ? 1 : 0; // Asignamos el valor '1' o '0' según el estado del checkbox
            this.campoEstado = input.checked ? 1 : 0;
            console.log(`Nuevo valor de ${key}:`, registro[key]); // Verificación en consola
          });
        } else {
          input = document.createElement('input');
          input.id = key;
          input.name = key;
          input.placeholder = `Ingresar ${key}`;
          input.className =
            'bg-transparent p-1 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400 dark:border-gray-600';

          if (tipo === 'string') {
            input.type = 'text';
            input.value = valor;
          } else if (tipo === 'number') {
            input.type = 'number';
            input.value = valor.toString();
          } else if (valor instanceof Date) {
            input.type = 'date';
            input.value = valor ? valor.toISOString().split('T')[0] : '';
          }
        }

        // Verificar si todos los inputs están vacíos
        const allInputsEmpty = () => {
          for (const key in this.registros[0]) {
            if (
              this.registros[0].hasOwnProperty(key) &&
              !['mensaje', 'resultado'].includes(key) &&
              registro &&
              registro[key] !== undefined &&
              registro[key] !== ''
            ) {
              return false;
            }
          }
          return true;
        };


         // Cambiar lógica para bloquear los inputs necesarios para cada catálogo
         const allEmpty = allInputsEmpty();

         // Aplicar el modelo de estado correspondiente según si el registro está vacío o no
         const estadoInputsElementoAsignado = allEmpty
           ? estadoInputsElementoAsignadoInsert
           : estadoInputsElementoAsignadoUpdate;
 
         const estadoInputsTipoCanal = allEmpty
           ? estadoInputsTipoCanalDistribucionInsert
           : estadoInputsTipoCanalDistribucionUpdate;
 
         const estadoInputsCanalDistribucion = allEmpty
           ? estadoInputsCanalDistribucionInsert
           : estadoInputsCanalDistribucionUpdate;

          const estadoInputsUser = allEmpty 
          ? estadoInputsUserInsert 
          : estadoInputsUserUpdate
 
         // Determinar cuál estado de inputs aplicar
         let estadoInputs = estadoInputsElementoAsignado; // Predeterminado
         if (key in estadoInputsTipoCanal) {
           estadoInputs = estadoInputsTipoCanal;
         } else if (key in estadoInputsCanalDistribucion) {
           estadoInputs = estadoInputsCanalDistribucion;
         }  else if (key in estadoInputsUser) {
          estadoInputs = estadoInputsUser;
        }
 
         // Deshabilitar si corresponde
         if (estadoInputs[key]) {
           input.disabled = true;
           input.style.backgroundColor = '#E5E7EB'; 
           input.style.cursor = 'not-allowed';
           input.style.color = '#4B5563'; 
         }
 
         div.appendChild(input);
         inputContainer.appendChild(div);
       }
    }
  }

  validarInputs(): string[] {
    const inputs: NodeListOf<HTMLInputElement> = document.querySelectorAll('#inputContainer input');
    const inputsVacios: string[] = [];
  
    inputs.forEach(input => {
      if (input.disabled) {
        return;
      }
      
      if (!input.value.trim()) {  // Verifica si el input está vacío o solo tiene espacios
        inputsVacios.push(input.name); 
      }
    });
  
    return inputsVacios; 
  }

  habilitarInputsVacios() {
    //this.mostrarBtnAgregar = false;
    this.isAgregandoRegistro = true;
    this.sharedService.setAccion('agregandoRegistro');
    this.mostrarInputs(); // Llamar a mostrarInputs sin pasar un registro (para mostrar inputs vacíos)
    
    this.mostrarBtnGuardar = true; 
  }

  limpiarSeleccion() {
    this.mostrarBtnActualizar = false; 
    this.mostrarBtnBorrar = false; 
    this.errorMessage = ''; 
    this.limpiarInputs();
    this.opcionSeleccionada = null;
    this.mostrarBtnAgregar = true; 
    this.mostrarBtnGuardar = false;
    this.sharedService.setAccion('visualizandoCatalogo');
    this.actualizarLista()
  }

  private limpiarInputs() {
    const inputContainer = document.getElementById('inputContainer');
    if (inputContainer) {
      while (inputContainer.firstChild) {
          inputContainer.removeChild(inputContainer.firstChild); // Eliminar cada input de forma individual
      }
      console.log('Inputs limpiados');
  }
  }

  //*FUNCIONES PARA MANEJAR MENSAJES Y COMPONENTES DE MENSAJES
  mostrarMensajeAlerta(mensajeAlerta: string) {
    this.isVisibleExito = false
    this.mensajeAlerta = mensajeAlerta;
    this.isVisibleAlerta = true; 
    console.log('Mensaje mostrado:', this.mensajeAlerta);

    setTimeout(() => {
      this.ocultarMensaje();
    }, 5000); 
  }

  mostrarMensajeExito(mensajeExito: string) {
    this.isVisibleAlerta = false;
    this.mensajeExito = mensajeExito;
    this.isVisibleExito = true;
    console.log('Mensaje de éxito mostrado:', this.mensajeExito);
  
    setTimeout(() => {
      this.ocultarMensaje();
    }, 5000); 
  }

  mostrarMensajeModal(accion: Accion) {
    if (!this.catalogoSeleccionado) {
      this.mensajeModal = 'No se ha seleccionado ningún catálogo.';
      return;
    }
  
    const mensajes = {
      [Accion.Eliminar]: '¿Desea eliminar este registro?',
      [Accion.Actualizar]: '¿Desea actualizar este registro?',
      [Accion.Agregar]: '¿Desea agregar este registro?'
    };
  
    this.mensajeModal = mensajes[accion] || 'Acción no reconocida.';
  }
  
  ocultarMensaje() {
    this.isVisibleAlerta = false;
    this.isVisibleExito = false;
  }

  limpiarBusqueda(inputElement: HTMLInputElement): void {
    inputElement.value = ''; // Limpiar el valor del input
    this.mostrarBtnAgregar = true;
    this.generarRegistros(this.catalogoSeleccionado ?? '') 
  }
}
