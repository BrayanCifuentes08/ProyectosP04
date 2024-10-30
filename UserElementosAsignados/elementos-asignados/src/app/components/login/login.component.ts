import { CommonModule } from '@angular/common';
import { Component, ElementRef, ViewChild, Inject, PLATFORM_ID } from '@angular/core';
import { Router } from '@angular/router';
import { TraduccionService } from '../../services/traduccion.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../services/api.service';
import { UtilidadService } from '../../services/utilidad.service';
import { PaBscEstacionTrabajo2M, ParametrosEstacionTrabajo } from '../../models/estacion-trabajo';
import { PaBscEmpresa1M, ParametrosEmpresa } from '../../models/empresa';
import { PaBscApplication1M, ParametrosApplication } from '../../models/application';
import { PaBscUserDisplay2M, ParametrosUserDisplay } from '../../models/user-display';
import { isPlatformBrowser } from '@angular/common';
import { SharedService } from '../../services/shared.service';
@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, TranslateModule, FormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css',
})
export default class LoginComponent {
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
  mensajeErrorUrl:            string = '';
  aplicacionSeleccionada:     any;
  seleccionados:              { [key: string]: any } = {};
  validacionErrores:          { [key: string]: string } = {};
  mensajeTipo:                'guardado' | 'noGuardado' | null = null;
  errores:                    { usuario?: string; pass?: string; general?: string } = {};
  estacionTrabajo:        PaBscEstacionTrabajo2M[] = [];
  empresa:                PaBscEmpresa1M[] = [];
  application1:           PaBscApplication1M[] = [];
  userDisplay2:           PaBscUserDisplay2M[] = [];
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
    public traduccionService: TraduccionService,
    private translate: TranslateService,
    private apiService: ApiService,
    private utilidadService: UtilidadService,
    private sharedService:SharedService,
    @Inject(PLATFORM_ID) private platformId: Object
  ) {
    this.urlApi = this.utilidadService.getUrlService();
    //this.esModoOscuro = this.utilidadService.isDarkMode(); // Obtener el estado inicial del modo oscuro
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
    //this.colorSeleccionado = this.utilidadService.getColorSeleccionado();
  }

  toggleModoOscuroElementLogin(): void {
    this.sharedService.alternarTema();
  }

  get esModoOscuro(): boolean {
    return this.sharedService.esModoOscuroHabilitado();
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
      return 'images/us.png';
    } else if (idioma === 'es') {
      return 'images/es.png';
    } else if (idioma === 'fr') {
      return 'images/fr.png';
    } else if (idioma === 'de'){
      return 'images/de.png'
    }
    return 'images/default.png'; // Bandera por defecto si el idioma no es reconocido
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
    //this.onInputChange()
    // Actualiza el servicio con el valor del input
    this.apiService.setUser(this.usuario);
  }

  //TODO: METODOS PARA DATOS DE INICIO DE SESION
  //Metodo para manejar el cambio en la casilla de verificación
  onGuardarDatosSesionChange(event: Event): void {
    const input = event.target as HTMLInputElement;
    this.guardarDatosSesion = input.checked;
    this.mostrarMensajeEstadoDatos();
  }

  guardarDatosEnLocalStorage(): void {
    // Verificar que estamos en un entorno de navegador
    if (isPlatformBrowser(this.platformId)) {
      localStorage.setItem('usuario', this.usuario ?? '');
      localStorage.setItem('pass', this.pass ?? '');
      localStorage.setItem('estacionTrabajo', JSON.stringify(this.seleccionados['estaciones'] ?? {}));
      localStorage.setItem('empresa', JSON.stringify(this.seleccionados['empresas'] ?? {}));
      localStorage.setItem('aplicacion', JSON.stringify(this.seleccionados['aplicaciones'] ?? {}));
      localStorage.setItem('display', JSON.stringify(this.seleccionados['displays'] ?? {}));
      localStorage.setItem('jwtToken', this.token ?? '');
      localStorage.setItem('guardarDatosSesion', 'true');
      const currentTime = new Date().getTime();
      localStorage.setItem('horaInicioSesion', currentTime.toString());
      if (this.userLogo) {
        localStorage.setItem('userLogo', this.userLogo);
      }
    }
  }
  
  guardarDatosEnSessionStorage(): void {
    // Verificar que estamos en un entorno de navegador
    if (isPlatformBrowser(this.platformId)) {
      const tiempoCorriente = new Date().getTime();
      // Validar que currentTime es un número válido
      if (!isNaN(tiempoCorriente)) {
        sessionStorage.setItem('horaInicioSesionTemp', tiempoCorriente.toString());
      } else {
        console.warn("Error al capturar la hora actual");
      }

      sessionStorage.setItem('usuario', this.usuario ?? '');
      sessionStorage.setItem('pass', this.pass ?? '');
      sessionStorage.setItem('estacionTrabajo', JSON.stringify(this.seleccionados['estaciones'] ?? {}));
      sessionStorage.setItem('empresa', JSON.stringify(this.seleccionados['empresas'] ?? {}));
      sessionStorage.setItem('aplicacion', JSON.stringify(this.seleccionados['aplicaciones'] ?? {}));
      sessionStorage.setItem('display', JSON.stringify(this.seleccionados['displays'] ?? {}));
      sessionStorage.setItem('jwtToken', this.token ?? '');
      sessionStorage.setItem('guardarDatosSesion', 'false'); // Marca que no se debe guardar la sesión

      if (this.userLogo) {
        sessionStorage.setItem('userLogo', this.userLogo);
      }
    }
  }
  
  //TODO:Métodos para eliminar los datos y verificar
  eliminarDatosDeLocalStorage(): void {
    if (isPlatformBrowser(this.platformId)) {
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
    }
  }

  eliminarDatosDeSessionStorage(): void {
    if (isPlatformBrowser(this.platformId)) {
      sessionStorage.removeItem('usuario');
      sessionStorage.removeItem('user');
      sessionStorage.removeItem('pass');
      sessionStorage.removeItem('estacionTrabajo');
      sessionStorage.removeItem('estacion');
      sessionStorage.removeItem('empresa');
      sessionStorage.removeItem('aplicacion');
      sessionStorage.removeItem('display');
      sessionStorage.removeItem('jwtToken');
      sessionStorage.removeItem('horaInicioSesionTemp');
    }
  }

  ngOnInit(): void {
    if(isPlatformBrowser(this.platformId)){
      //Recupera y muestra la hora de inicio de sesión y la fecha de ingreso
      const horaInicioSesion = localStorage.getItem('horaInicioSesion');
      const fechaIngreso = localStorage.getItem('fechaIngreso');

      if (horaInicioSesion) {
        console.log(`Hora de inicio de sesión: ${horaInicioSesion}`);
      }

      if (fechaIngreso) {
        console.log(`Fecha de ingreso: ${fechaIngreso}`);
      }
    }
    this.sharedService.inicializacionTema();
    //this.sharedService.showLoading();
    this.verificarSesionActiva();
    this.mostrarInformacionDeSesion();
    this.verificarYLimpiarDatos();
  }
  
  // Funcion para verificar si hay una sesion activa
  verificarSesionActiva(): void {
    if (isPlatformBrowser(this.platformId) &&
        localStorage.getItem('estacionTrabajo') &&
        localStorage.getItem('empresa') &&
        localStorage.getItem('jwtToken')) {
      this.router.navigate(['/dashboard']);
    }
  }
  
  // Funcion para mostrar información de la sesion (hora de inicio, fecha de ingreso)
  mostrarInformacionDeSesion(): void {
    if (isPlatformBrowser(this.platformId)) {
      const horaInicioSesion = localStorage.getItem('horaInicioSesion');
      const fechaIngreso = localStorage.getItem('fechaIngreso');

      if (horaInicioSesion) {
        console.log(`Hora de inicio de sesión: ${horaInicioSesion}`);
      }

      if (fechaIngreso) {
        console.log(`Fecha de ingreso: ${fechaIngreso}`);
      }
    }
  }
  
  // Verifica si debe limpiar los datos de la sesion
  verificarYLimpiarDatos(): void {
    if (isPlatformBrowser(this.platformId)) {
      const guardarSesion = localStorage.getItem('guardarDatosSesion') === 'true';
      if (!guardarSesion) {
        // Si no se guardó la sesión, eliminar todos los datos
        this.eliminarTodosLosDatos();
      }
    }
  }
  
  // Método para limpiar todos los datos del local o session storage
  eliminarTodosLosDatos(): void {
    if (isPlatformBrowser(this.platformId)) {
      localStorage.clear();
      sessionStorage.clear();
    }
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
      // Redirige al layout (ahi se maneja esta ruta)
      this.router.navigate(['/dashboard']);
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

    setTimeout(() => {
      this.mensajeEstadoDatosSesion = null;
      this.mensajeTipo = null;
    }, 3000);
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
          localStorage.setItem('jwtToken', data.token);
          this.token = data.token;
          this.buscarEstacionTrabajo();
          this.buscarEmpresa();
          this.buscarApplication();
          this.abrirModal();
          this.seleccionados = {};
          this.mostrarBotonModal = false;
        } else {
          this.errores.general = data.mensaje || 'Error de autenticación';
        }
        this.cargando = false;
      },
      (error) => {
        console.error('Error al buscar usuario', error);
        this.errores.general = error.error?.mensaje || 'Error al autenticar el usuario';
        this.cargando = false;
      }
    );
  }

  buscarEstacionTrabajo(): void {
    const token = localStorage.getItem('jwtToken');
    if (!token) {
        console.error('Token no disponible');
        return;
    }
    const parametros: ParametrosEstacionTrabajo = {
      pUserName: this.usuario,
    };
  
    this.apiService.buscarEstacionTrabajo(parametros).subscribe(
      (data: PaBscEstacionTrabajo2M[]) => {
        this.estacionTrabajo = data;

      },
      (error) => {
        console.error('Error al buscar estaciones de trabajo', error);
      }
    );
  }

  buscarEmpresa(): void { 
    const parametros: ParametrosEmpresa = {
      pUserName: this.usuario,
    };
  
  
    this.apiService.buscarEmpresa(parametros).subscribe(
      (data: PaBscEmpresa1M[]) => {
        this.empresa = data;
      },
      (error) => {
        console.error('Error al buscar empresas', error);
      }
    );
  }
  
  buscarApplication(): void {
    const parametros: ParametrosApplication = {
      TAccion: 1,
      TOpcion: 1,
      pFiltro_1: this.usuario,
    };
  
    this.apiService.buscarApplication(parametros).subscribe(
      (data: PaBscApplication1M[]) => {
        this.application1 = data;
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
        this.userDisplay2 = data.filter(item => item.display_URL_Alter !== null && item.display_URL_Alter !== undefined);
        console.log('User Display 2 después del filtro:', this.userDisplay2);
        
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
    const hayDisplayValido = this.userDisplay2.some(item => item.display_URL_Alter !== null);
  
    //Si hay displays validos, el usuario debe seleccionar al menos uno, pero si no hay displays, la selección no es obligatoria
    const seleccionDeDisplayValida = hayDisplayValido ? (displaysSeleccionados !== null) : true;
  
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
        this.userDisplay2 = [];
        this.sectionOpen = null; // Opcional: Cerrar el acordeón si es necesario
        break;
      case 'displays':
        this.seleccionados['displays'] = null;
        this.userDisplay2 = [];
        this.sectionOpen = null; // Opcional: Cerrar el acordeón si es necesario
        break;
      default:
        console.warn(`Tipo de selección no reconocido: ${tipo}`);
    }
  }

  // onPassChange(): void {
  //   this.onInputChange();
  // }
  
  // onInputChange(): void {
  //   // Ocultar el botón del modal
  //   this.mostrarBotonModal = false;

  //   // Limpiar los datos de sessionStorage y localStorage
  //   this.eliminarDatosDeLocalStorage();
  //   this.eliminarDatosDeSessionStorage();
  // }    
}
