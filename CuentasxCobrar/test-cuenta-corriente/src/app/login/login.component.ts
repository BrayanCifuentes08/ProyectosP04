import { CommonModule } from '@angular/common';
import { Component, ElementRef, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { TraduccionService } from '../services/traduccion.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../services/api.service';
import { PaBscUser2M, ParametrosLogin } from '../models/login';
import {
  PaBscEstacionTrabajo2M,
  ParametrosEstacionTrabajo,
} from '../models/estacion-trabajo';
import { PaBscEmpresa1M, ParametrosEmpresa } from '../models/empresa';
import {
  PaBscApplication1M,
  ParametrosApplication,
} from '../models/application';
import {
  PaBscUserDisplay2M,
  ParametrosUserDisplay,
} from '../models/user-display';
import { UtilidadService } from '../services/utilidad.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, TranslateModule, FormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css',
})
export class LoginComponent {
  mostrarMensaje:             boolean = false;
  isIdiomaMenuOpen:           boolean = false;
  mostrarMensajeUrl:          boolean = false;
  mostrarMensajeUrlConfirmacion:  boolean = false;
  mostrarMensajeUrlVerificacion:  boolean = false;
  cargando:                   boolean = false;
  mostrarModal:               boolean = false;
  mostrarBotonModal:          boolean = false;  
  isColorSeleccinadoAbierto:  boolean = false;
  isExiting:                  boolean = false;
  esModoOscuro:               boolean = false;
  guardarDatosSesion:         boolean = false;  
  isVerificando:              boolean = false; 
  esError:                    boolean = false;
  esValido:                   boolean = false;
  userLogo:                   string | null = null;
  token:                      string | null = null; 
  mensajeEstadoDatosSesion:   string | null = null;
  sectionOpen:                string | null = null;
  urlApi:                     string = '';
  usuario:                    string = '';
  pass:                       string = '';
  mensajeErrorUrl: string = '';
  aplicacionSeleccionada:     any;
  seleccionados:              { [key: string]: any } = {};
  validacionErrores:          { [key: string]: string } = {};
  mensajeTipo:                'guardado' | 'noGuardado' | null = null;
  errores:                    { usuario?: string; pass?: string; general?: string } = {};
  estacionTrabajo:        PaBscEstacionTrabajo2M[] = [];
  empresa:                PaBscEmpresa1M[] = [];
  application1:           PaBscApplication1M[] = [];
  userDisplay2:           PaBscUserDisplay2M[] = [];
  userDisplaysPadres: any[] = [];
  userDisplaysHijos: any[] = [];
  @ViewChild('usuarioInput') usuarioInput!: ElementRef<HTMLInputElement>;
  @ViewChild('passInput')    passInput!:    ElementRef<HTMLInputElement>;
  colorSeleccionado:  string = 'linear-gradient(to bottom, #1e3a8a, #f97316)';
  coloresDisponibles = [
    { name: 'Azul a Naranja',     value: 'linear-gradient(to bottom, #1e3a8a, #f97316)' },
    { name: 'Amarillo a Rojo',    value: 'linear-gradient(to bottom, #eab308, #dc2626)' },
    { name: 'Morado a Turquesa',  value: 'linear-gradient(to bottom, #6a0dad, #0d9488)' },
    { name: 'Azul a Gris',        value: 'linear-gradient(to bottom, #09203f, #537895)' },
  ];  
  
  
  constructor(
    private router: Router,
    public traduccionService: TraduccionService,private translate: TranslateService,
    private apiService: ApiService,
    private utilidadService: UtilidadService
  ) {
    this.urlApi = this.utilidadService.getUrlService();
    this.esModoOscuro = this.utilidadService.isDarkMode(); // Obtener el estado inicial del modo oscuro
    this.updateColor();
  }
  
  onKeyDown(event: KeyboardEvent, inputType: 'usuario' | 'pass') {
    if (event.key === 'ArrowDown') {
      event.preventDefault(); // Previene el comportamiento por defecto de la tecla
      if (inputType === 'usuario') {
        this.passInput.nativeElement.focus(); // Enfoca el siguiente input
      }
    } else if (event.key === 'ArrowUp') {
      event.preventDefault(); // Previene el comportamiento por defecto de la tecla
      if (inputType === 'pass') {
        this.usuarioInput.nativeElement.focus(); // Enfoca el input anterior
      }
    }
  }

  updateColor() {
    this.colorSeleccionado = this.utilidadService.getColorSeleccionado();
  }

  toggleModoOscuroElementLogin() {
    this.utilidadService.toggleModoOscuro();
    this.updateColor(); 
    this.esModoOscuro = this.utilidadService.isDarkMode(); // Actualizar el estado del modo oscuro
  }

  onCambioColor(colorValue: string): void {
    this.colorSeleccionado = colorValue;
    this.isColorSeleccinadoAbierto = false;
  }

  toggleColorSelector(): void {
    this.isColorSeleccinadoAbierto = !this.isColorSeleccinadoAbierto;
  }

  alternarMensaje() {
    this.mostrarMensaje = !this.mostrarMensaje;
  }

  toggleIdiomaMenu() {
    this.isIdiomaMenuOpen = !this.isIdiomaMenuOpen;
  }

  onCambioIdioma(idioma: string) {
    this.traduccionService.cambiarIdioma(idioma);
    this.isIdiomaMenuOpen = false;
  }
  
  getFlagUrl(idioma: string): string {
    if (idioma === 'en') {
      return 'assets/us.png';
    } else if (idioma === 'es') {
      return 'assets/es.png';
    } else if (idioma === 'fr') {
      return 'assets/fr.png';
    } else if (idioma === 'de'){
      return 'assets/de.png'
    }
    return 'assets/default.png'; // Bandera por defecto si el idioma no es reconocido
  }
  
  confirmarUrl() {
    this.utilidadService.setUrlService(this.urlApi); //Servicio para actualizar la URL
    console.log(`URL API actualizada a: ${this.urlApi}`);
    this.mostrarMensaje = false;
    this.mostrarMensajeUrlConfirmacion = false;
  }

  verificarUrl(urlApi: string) {
    this.mostrarMensajeUrlConfirmacion = false;
    this.isVerificando = true;
  
    this.apiService.verificarBaseUrl(urlApi).subscribe(
      (isValid: boolean) => {
        this.isVerificando = false;
  
        if (isValid) {
          this.mostrarMensajeUrlVerificacion = true;
          this.esValido = true;
          this.esError = false;
          this.mensajeErrorUrl = 'labels.URLValida'; // Asigna la clave
        } else {
          this.mostrarMensajeUrlVerificacion = true;
          this.esValido = false;
          this.esError = true;
          this.mensajeErrorUrl = 'labels.URLInvalida';
        }
      },
      (error) => {
        this.isVerificando = false;
        this.mostrarMensajeUrlVerificacion = true;
        this.esValido = false;
        this.esError = true;
        this.mensajeErrorUrl = 'labels.ErrorValidarURL'; 
      }
    );
  }
  

  onUsuarioChange(): void {
    this.onInputChange()
    // Actualiza el servicio con el valor del input
    this.apiService.setUser(this.usuario);
  }

  buscarUsuario(): void {
    this.cargando = true;
    const parametros = {
      pOpcion: 1,
      pUserName: this.usuario,
      pPass: this.pass,
    };

    this.apiService.buscarUser2(parametros).subscribe(
      (data: any) => {
        if (data && data.token && data.continuar) {
          console.log('Bienvenido a la aplicación');
          localStorage.setItem('jwtToken', data.token); // Guardar el token en localStorage
          this.token = data.token; // Asignar el token a la variable `this.token`
          this.buscarEstacionTrabajo();
          this.buscarEmpresa();
          this.buscarApplication();
          this.abrirModal();
          this.seleccionados = {};
          this.mostrarBotonModal = false;
        } else {
          // Si `continuar` es falso o no hay token, muestra el mensaje de error
          this.errores.general = data.mensaje || 'Error de autenticación';
        }
        this.cargando = false;
      },
      (error) => {
        console.error('Error al buscar usuario', error);
        // Capturar el error de la petición HTTP y mostrar un mensaje de error
        this.errores.general = error.error?.mensaje || 'Error al autenticar el usuario';
        this.cargando = false;
      }
    );
  }

  //TODO: METODOS PARA DATOS DE INICIO DE SESION
  //Metodo para manejar el cambio en la casilla de verificación
  onGuardarDatosSesionChange(event: Event): void {
    const input = event.target as HTMLInputElement;
    this.guardarDatosSesion = input.checked;
    this.mostrarMensajeEstadoDatos();
  }

  guardarDatosEnLocalStorage(): void {
    localStorage.setItem('user', this.usuario ?? '');
    localStorage.setItem('pass', this.pass ?? '');
    localStorage.setItem('estacionTrabajo', JSON.stringify(this.seleccionados['estaciones'] ?? {}));
    localStorage.setItem('empresa', JSON.stringify(this.seleccionados['empresas'] ?? {}));
    localStorage.setItem('aplicacion', JSON.stringify(this.seleccionados['aplicaciones'] ?? {}));
    localStorage.setItem('display', JSON.stringify(this.seleccionados['displays'] ?? {}));
    localStorage.setItem('jwtToken', this.token ?? '');
    localStorage.setItem('guardarDatosSesion', 'true'); // Marca que se debe guardar la sesión
    const currentTime = new Date().getTime();
    localStorage.setItem('horaInicioSesion', currentTime.toString());
    if (this.userLogo) {
      localStorage.setItem('userLogo', this.userLogo);
    }
  }
  
  guardarDatosEnSessionStorage(): void {
    sessionStorage.setItem('user', this.usuario ?? '');
    sessionStorage.setItem('pass', this.pass ?? '');
    sessionStorage.setItem('estacionTrabajo', JSON.stringify(this.seleccionados['estaciones'] ?? {}));
    sessionStorage.setItem('empresa', JSON.stringify(this.seleccionados['empresas'] ?? {}));
    sessionStorage.setItem('aplicacion', JSON.stringify(this.seleccionados['aplicaciones'] ?? {}));
    sessionStorage.setItem('display', JSON.stringify(this.seleccionados['displays'] ?? {}));
    sessionStorage.setItem('jwtToken', this.token ?? '');
    sessionStorage.setItem('guardarDatosSesion', 'false'); // Marca que no se debe guardar la sesión
    const currentTime = new Date().getTime(); 
    sessionStorage.setItem('horaInicioSesionTemp', currentTime.toString());
    if (this.userLogo) {
      sessionStorage.setItem('userLogo', this.userLogo);
    }
  }
  
  // Métodos para eliminar los datos
  eliminarDatosDeLocalStorage(): void {
      localStorage.removeItem('usuario');
      localStorage.removeItem('userLogo');
      localStorage.removeItem('user');
      localStorage.removeItem('pass');
      localStorage.removeItem('estacionTrabajo');
      localStorage.removeItem('estacion');
      localStorage.removeItem('empresa');
      localStorage.removeItem('aplicacion');
      localStorage.removeItem('display');
      localStorage.removeItem('jwtToken');
      localStorage.removeItem('horaInicioSesion');
      localStorage.removeItem('urlApi');
  }

  eliminarDatosDeSessionStorage(): void {
      sessionStorage.removeItem('usuario');
      sessionStorage.removeItem('user');
      localStorage.removeItem('userLogo');
      sessionStorage.removeItem('pass');
      sessionStorage.removeItem('estacionTrabajo');
      sessionStorage.removeItem('estacion');
      sessionStorage.removeItem('empresa');
      sessionStorage.removeItem('aplicacion');
      sessionStorage.removeItem('display');
      sessionStorage.removeItem('jwtToken');
      sessionStorage.removeItem('horaInicioSesionTemp');
      sessionStorage.removeItem('urlApi');
  }
  
  ngOnInit(): void {
    if (localStorage.getItem('estacionTrabajo') && localStorage.getItem('empresa') && localStorage.getItem('jwtToken')) {
      this.router.navigate(['/inicio']);
    }

    //Recupera y muestra la hora de inicio de sesión y la fecha de ingreso
    const horaInicioSesion = localStorage.getItem('horaInicioSesion');
    const fechaIngreso = localStorage.getItem('fechaIngreso');

    if (horaInicioSesion) {
      console.log(`Hora de inicio de sesión: ${horaInicioSesion}`);
    }

    if (fechaIngreso) {
      console.log(`Fecha de ingreso: ${fechaIngreso}`);
    }

    this.verificarYLimpiarDatos();
  }

  verificarYLimpiarDatos(): void {
    const guardarSesion = localStorage.getItem('guardarDatosSesion') === 'true';
    
    if (guardarSesion) {
      // Si se guardó la sesión, no hacemos nada
      return;
    } else {
      // Si no se guardó la sesión, eliminar todos los datos
      this.eliminarTodosLosDatos();
    }
  }

  eliminarTodosLosDatos(): void {
    localStorage.clear();
    sessionStorage.clear();
  }
  
  guardarCambios(): void {
    if (this.validarSeleccion()) {
        if (this.guardarDatosSesion) {
            // Guardar en localStorage y limpiar sessionStorage
            this.guardarDatosEnLocalStorage();
            this.eliminarDatosDeSessionStorage();
        } else {
            // Guardar en sessionStorage y limpiar localStorage
            this.guardarDatosEnSessionStorage();
            this.eliminarDatosDeLocalStorage();
        }
        this.router.navigate(['/inicio']);
    } else {
        console.log('Faltan selecciones. Verifique todos los campos.');
    }
  }
 
  mostrarMensajeEstadoDatos(): void {
    if (this.guardarDatosSesion) {
      this.mensajeEstadoDatosSesion = "messages.datosGuardadosSesion";
      this.mensajeTipo = 'guardado';
    } else {
      this.mensajeEstadoDatosSesion = "messages.datosNoGuardadosSesion";
      this.mensajeTipo = 'noGuardado';
    }

    // Hacer que el mensaje desaparezca después de 3 segundos
    setTimeout(() => {
      this.mensajeEstadoDatosSesion = null;
      this.mensajeTipo = null;
    }, 3000);
  }

  buscarEstacionTrabajo(): void {
    this.token = localStorage.getItem('jwtToken'); // Recuperar el token del localStorage
    if (!this.token) {
      console.error('Token no disponible');
      return;
    }
  
    const parametros: ParametrosEstacionTrabajo = {
      pUserName: this.usuario,
    };
  
    //console.log('Parámetros estación de trabajo:', parametros);
  
    this.apiService.buscarEstacionTrabajo(parametros).subscribe(
      (data: PaBscEstacionTrabajo2M[]) => {
        this.estacionTrabajo = data;
        //console.log('Estaciones de Trabajo:', data);
      },
      (error) => {
        console.error('Error al buscar estaciones de trabajo', error);
      }
    );
  }

  buscarEmpresa(): void {
    if (!this.token) {
      console.error('Token no disponible');
      return;
    }
  
    const parametros: ParametrosEmpresa = {
      pUserName: this.usuario,
    };
  
    //console.log('Parámetros empresa:', parametros);
  
    this.apiService.buscarEmpresa(parametros).subscribe(
      (data: PaBscEmpresa1M[]) => {
        this.empresa = data;
        //console.log('Empresas:', data);
      },
      (error) => {
        console.error('Error al buscar empresas', error);
      }
    );
  }
  
  buscarApplication(): void {
    if (!this.token) {
      console.error('Token no disponible');
      return;
    }
  
    const parametros: ParametrosApplication = {
      TAccion: 1,
      TOpcion: 1,
      pFiltro_1: this.usuario,
    };
  
    // console.log('Parámetros aplicación:', parametros);
  
    this.apiService.buscarApplication(parametros).subscribe(
      (data: PaBscApplication1M[]) => {
        this.application1 = data;
        //console.log('Aplicaciones:', data);
      },
      (error) => {
        console.error('Error al buscar aplicaciones', error);
      }
    );
  }
  
  buscarUserDisplay2(aplicacionSeleccionada: number): void {
    this.token = localStorage.getItem('jwtToken');
    if (!this.token) {
      console.error('Token no disponible');
      return;
    }

    this.cargando = true;

    const parametros: ParametrosUserDisplay = {
      UserName: this.usuario,
      Application: aplicacionSeleccionada,
    };

    this.apiService.buscarUserDisplay2(parametros).subscribe(
      (data: PaBscUserDisplay2M[]) => {
        console.log('Datos recibidos:', data);

        this.userDisplaysPadres = [];
        this.userDisplaysHijos = [];

        //Separacion de padres e hijos
        data.forEach(item => {
          //Es padre si user_Display_Father es null o 0
          if (item.user_Display_Father === null || item.user_Display_Father === 0) {
            console.log('Este es un padre:', item);
            this.userDisplaysPadres.push(item);
          } else {
            //Aca es un hijo, solo si tiene display_URL_Alter valido
            if (item.display_URL_Alter !== null && item.display_URL_Alter !== undefined) {
              console.log('Este es un hijo válido con display_URL_Alter:', item);
              this.userDisplaysHijos.push(item);
            } else {
              console.log('Este hijo no tiene display_URL_Alter, no se procesará:', item);
            }
          }
        });

        console.log('Padres encontrados:', this.userDisplaysPadres);
        console.log('Hijos encontrados:', this.userDisplaysHijos);

        //Se relaciona o asocia cada hijo con su padre
        this.userDisplaysHijos.forEach((hijo: any) => {
          console.log("Procesando hijo:", hijo);

          //se verifica si el valor de user_Display_Father esta presente y es valido
          if (hijo.user_Display_Father === undefined || hijo.user_Display_Father === null) {
            console.log("El hijo no tiene un user_Display_Father válido");
            return; 
          }

          const padre = this.userDisplaysPadres.find((p: any) => {
            const padreDisplay = p.user_Display;
            const hijoDisplayFather = hijo.user_Display_Father;
            
            //Verifica la comparación entre el padre y el hijo
            return padreDisplay === hijoDisplayFather;
          });

          if (padre) {
            console.log('Hijo encontrado con su padre:', padre, hijo);
            hijo.padre = padre;
          } else {
            console.log('No se encontró el padre para el hijo:', hijo);
          }
        });

        this.userDisplaysPadres = data
          .filter(item => item.user_Display_Father === null || item.user_Display_Father === 0) //Solo dislplays padres
          .map(padre => {
            //Filtra los hijos validos (con el display_URL_Alter no nulo)
            const hijosValidos = data.filter(hijo =>
              hijo.user_Display_Father === padre.user_Display && hijo.display_URL_Alter !== null
            );

            //Solo se agrega los padres con al menos un hijo válido
            if (hijosValidos.length > 0) {
              return {
                ...padre,
                hijos: hijosValidos
              };
            } else {
              return null;
            }
          })
          .filter(padre => padre !== null)
        this.cargando = false;
      },
      (error) => {
        console.error('Error al buscar user display 2', error);
        this.cargando = false;
      }
    );
  }

  onAplicacionSeleccionada(application: any): void {
    if (this.aplicacionSeleccionada !== application) {
      this.seleccionados['displays'] = null;
    }
    this.aplicacionSeleccionada = application;
    this.seleccionados['aplicaciones'] = application;
    this.sectionOpen = null;
    this.buscarUserDisplay2(application.application);
  }

  validarSeleccion(): boolean {
    this.validacionErrores = {}; //Resetear errores
  
    //Verificar si todas las selecciones están completas
    const estacionesSeleccionadas = this.seleccionados['estaciones'];
    const empresasSeleccionadas = this.seleccionados['empresas'];
    const aplicacionesSeleccionadas = this.seleccionados['aplicaciones'];
    const displaysSeleccionados = this.seleccionados['displays'];
  
    //Verificar si todos los campos requeridos están seleccionados
    const validaciones = [
      estacionesSeleccionadas,
      empresasSeleccionadas,
      aplicacionesSeleccionadas
    ].every(valor => valor !== null && valor !== undefined);
  
    //Verificar si hay al menos un display valido
    const hayDisplayValido = this.userDisplaysPadres.some(item => item.hijos && item.hijos.some((hijo: any) => hijo.display_URL_Alter !== null));
  
     //Validar si el padre tiene al menos un hijo seleccionado
    const seleccionDeDisplayValida = hayDisplayValido ? (displaysSeleccionados !== null && this.userDisplaysPadres.some(padre => padre.hijos.some((hijo: any) => hijo === displaysSeleccionados))) : true;
  
    //Validar si todos los campos requeridos están completos y la selección de display es válida
    return validaciones && seleccionDeDisplayValida;
  }
  
  seleccionarItem(section: string, item: any) {
    this.seleccionados[section] = item;
    this.sectionOpen = null;
  
    if (section === 'estaciones') {
      this.apiService.setEstacion(item);
    } else if (section === 'empresas') {
      this.apiService.setEmpresa(item);
    }
  }
  
  verificarCampos(): void {
    this.errores = {};
  
    if (!this.usuario) {
      this.errores.usuario = this.traduccionService.traducirDatosImpresion('errores.usuario');
    }
  
    if (!this.pass) {
      this.errores.pass = this.traduccionService.traducirDatosImpresion('errores.pass');
    }
  
    if (!this.errores.usuario && !this.errores.pass) {
      this.buscarUsuario();
    }
  }
  

  copiarAPortapapeles() {
    navigator.clipboard
      .writeText(this.urlApi)
      .then(() => {
        console.log('URL copiada al portapapeles');
      })
      .catch((err) => {
        console.error('Error al copiar la URL: ', err);
      });
  }
  
  cerrarModal() {
    this.isExiting = true; // Activamos la clase de salida
    this.mostrarBotonModal = true;
    
    setTimeout(() => {
      this.mostrarModal = false;  // Ocultamos el modal después de la animación
      this.isExiting = false;     // Reseteamos la variable de estado
    }, 300); // Duración debe coincidir con la animación de salida
  }
  

  abrirModal() {
    this.mostrarModal = true;
    this.mostrarBotonModal = true; 
    this.isExiting = false;
  }

  manejarCargaLogo(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file = input.files[0];
      const reader = new FileReader();
  
      reader.onload = (e: ProgressEvent<FileReader>) => {
        this.userLogo = e.target?.result as string;
        this.utilidadService.setLogo(this.userLogo); // Actualiza el logo en el servicio
        
        // Guardar el logo en localStorage
        localStorage.setItem('userLogo', this.userLogo);
      };
  
      reader.readAsDataURL(file);
    }
  }
  

  limpiarSeleccion(tipo: 'estaciones' | 'empresas' | 'aplicaciones' | 'displays'): void {
    switch (tipo) {
      case 'estaciones':
        this.seleccionados['estaciones'] = null;
        break;
      case 'empresas':
        this.seleccionados['empresas'] = null;
        break;
      case 'aplicaciones':
        this.aplicacionSeleccionada = null;
        this.seleccionados['aplicaciones'] = null;
        this.seleccionados['displays'] = null;
        this.userDisplaysHijos = [];
        this.userDisplaysPadres = [];
        this.sectionOpen = null; // Opcional: Cerrar el acordeón si es necesario
        break;
      case 'displays':
        this.seleccionados['displays'] = null;
        this.sectionOpen = null; // Opcional: Cerrar el acordeón si es necesario
        break;
      default:
        console.warn(`Tipo de selección no reconocido: ${tipo}`);
    }
  }

  onPassChange(): void {
    this.onInputChange();
  }
  
  onInputChange(): void {
    // Ocultar el botón del modal
    this.mostrarBotonModal = false;

    // Limpiar los datos de sessionStorage y localStorage
    this.eliminarDatosDeLocalStorage();
    this.eliminarDatosDeSessionStorage();
  }

    
}
