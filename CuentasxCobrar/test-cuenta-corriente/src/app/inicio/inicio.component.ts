import { CommonModule, isPlatformBrowser } from '@angular/common';
import { Component, ElementRef, Inject, PLATFORM_ID, ViewChild } from '@angular/core';
import { NavigationEnd, Router, RouterLink, RouterOutlet } from '@angular/router';
import { ApiService } from '../services/api.service';
import { TraduccionService } from '../services/traduccion.service';
import { Parametros, ParametrosCliente } from '../models/docPendientes';
import { TranslateModule } from '@ngx-translate/core';
import { TablaComponent } from '../tablaCliente/tablaCliente.component';
import { TablaDocsPendientesComponent } from '../tablaDocsPendientesPago/tablaDocsPendientesPago.component';
import { FormsModule } from '@angular/forms';
import { LoadingScreenComponent } from '../loading-screen/loading-screen.component';
import { UtilidadService } from '../services/utilidad.service';

@Component({
  selector: 'app-inicio',
  standalone: true,
  imports: [
    TranslateModule,
    RouterOutlet, 
    RouterLink,
    CommonModule,
    TablaDocsPendientesComponent,
    FormsModule,
  TablaComponent,
  LoadingScreenComponent],
  templateUrl: './inicio.component.html',
  styleUrl: './inicio.component.css'
})
export class InicioComponent {
  isMenuAbierto:               boolean = true;
  mostrarDocumentosPendientes: boolean = true;
  isUserMenuOpenSidebar:       boolean = false;
  isIdiomaMenuOpen:            boolean = false;
  esModoOscuro:                boolean = false;
  isUserMenuOpen:              boolean = false;
  logoSubido:                  boolean = false;
  mostrarFondos:               boolean = false;
  cargandoFondoPersonalizado:  boolean = false;
  mostrarAvatar:               boolean = false;
  mostrarMensaje:              boolean = false;
  mostrarMensajeSidebar:       boolean = false;
  mostrarMensajeUrl:           boolean = false;
  isSidebarOpen:               boolean = false;
  isIdiomaMenuOpenSidebar:     boolean = false;
  usandoFondoPersonalizado:    boolean = false;
  animateIcon:                 boolean = false;
  mostrarMensajeUrlConfirmacion:  boolean = false;
  mostrarMensajeUrlVerificacion:  boolean = false;
  esError:                    boolean = false;
  esValido:                   boolean = false;
  isVerificando:              boolean = false; 
  receivedData:                any[] = [];
  parametrosArray:             Parametros[] = [];
  parametrosCliente:           ParametrosCliente[] = [];
  menuOpcion:                  string = '';
  colorSeleccionado:           string = '';
  urlApi:                      string = '';
  fondoPersonalizado:          string = '';
  fondoSeleccionado:           string = '';
  mensajeErrorUrl:             string = '';
  userLogo:                    string | null = null; // Inicializa userLogo como null
  nombreUsuario:               string | null = null; 
  fechaVencimientoToken:       string | null = null;
  horaInicioSesionFormatted:   string | null = null;
  horaInicioSesion:            number | null = null;
  fondosPredeterminados = [
    { nombre: 'Fondo 1', url: 'assets/fondos/background1.jpg' },
    { nombre: 'Fondo 2', url: 'assets/fondos/background2.jpg' },
    { nombre: 'Fondo 3', url: 'assets/fondos/background3.jpg' },
    { nombre: 'Fondo 4', url: 'assets/fondos/background4.jpg' },
    { nombre: 'Fondo 5', url: 'assets/fondos/background5.jpeg' }
  ];
  private intervalId: any;
  @ViewChild('logoInput') logoInput: ElementRef<HTMLInputElement> | undefined;

  constructor(
    private router: Router,
    private apiService: ApiService,
    private utilidadService: UtilidadService,
    public traduccionService: TraduccionService
  ) {
    this.esModoOscuro = this.utilidadService.isDarkMode(); // Obtener el estado inicial del modo oscuro
    this.urlApi = this.utilidadService.getUrlService();
    this.actualizarColor();
  
    // Recuperar nombre de usuario y otros datos
    const nombreUsuario = localStorage.getItem('user');
    this.nombreUsuario = nombreUsuario ? nombreUsuario : 'user';
    
    console.log('Nombre de Usuario:', this.nombreUsuario);
  
    // Obtener hora de inicio de sesión de localStorage
    const horaInicioSesionLocal = localStorage.getItem('horaInicioSesion');
  
    // Verificar si los datos están en localStorage
    const usuarioGuardado = localStorage.getItem('user');
    const jwtTokenGuardado = localStorage.getItem('jwtToken');
    const estacionTrabajoGuardada = localStorage.getItem('estacionTrabajo');
    const empresaGuardada = localStorage.getItem('empresa');
  
    // Mostrar avatar solo si los datos están en localStorage
    if (usuarioGuardado && jwtTokenGuardado && estacionTrabajoGuardada && empresaGuardada) {
      // Asegurarse de que horaInicioSesionLocal se convierte a número, o usar 0 como valor por defecto
      this.horaInicioSesion = horaInicioSesionLocal ? Number(horaInicioSesionLocal) : 0;
      this.horaInicioSesionFormatted = this.formatDate(this.horaInicioSesion);
      this.mostrarAvatar = true;
    } else {
      this.horaInicioSesion = null;
      this.horaInicioSesionFormatted = '';
      this.mostrarAvatar = false;
    }
  }

  onOption(opcion: string) {
    console.log('Opción seleccionada FUNCION ONOPTION:', opcion);
    this.menuOpcion = opcion;
    this.isMenuAbierto = false;
  }

  actualizarColor() {
    this.colorSeleccionado = this.utilidadService.getColorSeleccionado();
  }

  toggleModoOscuroElemento() {
    this.animateIcon = true;
    setTimeout(() => this.animateIcon = false, 600);
    this.utilidadService.toggleModoOscuro();
    this.actualizarColor(); 
    this.esModoOscuro = this.utilidadService.isDarkMode(); 
  }

  seleccionarFondo(fondo: any) {
    // Verificar si se está usando un fondo personalizado
    if (this.usandoFondoPersonalizado) {
      this.quitarFondo(); // Quita el fondo personalizado primero
    }

    // Seleccionar el fondo predeterminado
    this.fondoSeleccionado = fondo.url;
    this.usandoFondoPersonalizado = false; // Asegurarse de que no se marque como personalizado
    this.aplicarFondo(fondo.url);
  }

  toggleFondos() {
    this.mostrarFondos = !this.mostrarFondos;
  }

  aplicarFondo(url: string) {
    document.body.style.backgroundImage = `url(${url})`;
    document.body.style.backgroundSize = 'cover'; // Ajustar imagen para cubrir todo el fondo
    document.body.style.backgroundPosition = 'center'; // Centrar la imagen
    document.body.style.backgroundRepeat = 'no-repeat'; // No repetir la imagen
    document.body.style.backgroundAttachment = 'fixed'; // Fijar la imagen en el fondo
  }

  quitarFondo() {
    this.fondoSeleccionado = "";
    this.fondoPersonalizado = "";
    this.usandoFondoPersonalizado = false; // Restablecer el estado del fondo personalizado
    document.body.style.backgroundImage = 'none'; // Elimina la imagen de fondo
  }

  cargarFondoPersonalizado(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.cargandoFondoPersonalizado = true;
      const reader = new FileReader();
      reader.onload = () => {
        this.fondoPersonalizado = reader.result as string;
        this.cargandoFondoPersonalizado = false;
        this.usandoFondoPersonalizado = false; // Permitir aplicar un nuevo fondo personalizado
      };
      reader.readAsDataURL(file);
    }
  }

  aplicarFondoPersonalizado() {
    if (this.fondoPersonalizado) {
      this.aplicarFondo(this.fondoPersonalizado);
      this.fondoSeleccionado = "";
      this.usandoFondoPersonalizado = true; // Marcar que estamos usando un fondo personalizado
      this.mostrarFondos = false;
    }
  }
  
  ngOnInit() {
    setTimeout(() => {
      this.isIdiomaMenuOpen = false;
    }, 0);
    // Calcular la fecha de vencimiento del token
    this.calcularFechaVencimientoToken();

    // Iniciar la verificación de expiración del token
    this.verificarExpiracionToken();

    // Suscribirse a los cambios del logo
    this.utilidadService.logo$.subscribe(logo => {
      this.userLogo = logo;
      this.logoSubido = !!logo; // Si hay logo, logoSubido es true
    });

    // Recuperar el logo del localStorage si no hay uno en el servicio
    const savedLogo = localStorage.getItem('userLogo') || sessionStorage.getItem('userLogo');
    if (savedLogo) {
      this.userLogo = savedLogo;
      this.logoSubido = true;
    } else {
      this.userLogo = null;
      this.logoSubido = false;
    }

    // Suscribirse a los eventos de navegación para actualizar la opción seleccionada
    this.router.events.subscribe((event) => {
      if (event instanceof NavigationEnd) {
        this.menuOpcion = event.urlAfterRedirects.split('/')[2];
        console.log('Opción seleccionada:', this.menuOpcion);
      }
    });

    // Verificar y redirigir en función de los datos de localStorage o sessionStorage
    const estacionTrabajo = JSON.parse(localStorage.getItem('estacionTrabajo') || sessionStorage.getItem('estacionTrabajo') || '{}');
    const empresa = JSON.parse(localStorage.getItem('empresa') || sessionStorage.getItem('empresa') || '{}');
    const aplicacion = JSON.parse(localStorage.getItem('aplicacion') || sessionStorage.getItem('aplicacion') || '{}');
    const display = JSON.parse(localStorage.getItem('display') || sessionStorage.getItem('display') || '{}');

    if (estacionTrabajo && empresa && aplicacion && display) {
      // Datos encontrados, redirigir al inicio
      this.router.navigate(['/inicio']);
    } else {
      // Datos no encontrados, redirigir al login
      this.router.navigate(['/login']);
    }
  }

  // Abre o cierra el menú de idiomas del sidebar
  toggleSidebar() {
    this.isSidebarOpen = !this.isSidebarOpen;
  }
  
  toggleUserMenuSidebar(): void {
    this.isUserMenuOpenSidebar = !this.isUserMenuOpenSidebar;
  }

  toggleIdiomaMenuSidebar(): void {
    this.isIdiomaMenuOpenSidebar = !this.isIdiomaMenuOpenSidebar;
  }

  // Abre o cierra el menú de idiomas del navbar
  toggleUserMenu() {
    this.isUserMenuOpen = !this.isUserMenuOpen;
    if (this.isIdiomaMenuOpen) {
      this.isIdiomaMenuOpen = false;
    }
  }

  toggleIdiomaMenu() {
    this.isIdiomaMenuOpen = !this.isIdiomaMenuOpen;
    if (this.isUserMenuOpen) {
      this.isUserMenuOpen = false;
    }
  }
  
  //Funcion para cerrar o abrir sidebar o navbar
  alternarMensaje(tipo: 'navbar' | 'sidebar') {
    if (tipo === 'navbar') {
      this.mostrarMensaje = !this.mostrarMensaje;
    } else if (tipo === 'sidebar') {
      this.mostrarMensajeSidebar = !this.mostrarMensajeSidebar;
    }
  }

  onCambioIdioma(idioma: string) {
    console.log(`Cambiando idioma a: ${idioma}`);
    this.traduccionService.cambiarIdioma(idioma);
    this.isIdiomaMenuOpen = false;
    this.isIdiomaMenuOpenSidebar = false;
  }
  
  getFlagUrl(idioma: string): string {
    if (idioma === 'en') {
      return 'assets/us.png';
    } else if (idioma === 'es') {
      return 'assets/es.png';
    } else if (idioma === 'fr') {
      return 'assets/fr.png';
    } else if (idioma === 'de') {
      return 'assets/de.png'
    }
    
    return 'assets/default.png'; // Bandera por defecto si el idioma no es reconocido
  }

  ocultarDocumentos() {
    this.mostrarDocumentosPendientes = false;
    this.receivedData = [];
  }

  receiveDataFromChild(data: any[]) {
    this.receivedData = data;
    //console.log("Datos recibidos: ", this.receivedData);
    const currentUser = this.apiService.getUser();
    // Mapear los datos recibidos al modelo Parametros
    this.parametrosArray = this.receivedData.map((item) => {
      return {
        pCuenta_Correntista: item.cuenta_Correntista, //ESTE
        pCuenta_Cta: item.cuenta_Cta, //ESTE
        pCCDireccion: item.ccDireccion,
        pFacturaDireccion: item.factura_Direccion,
        pFacturaNit: item.factura_Nit,
        pFacturaNom: item.factura_Nombre,
        pTelefono: item.telefono,
        pEmpresa: 1,
        pCobrar_Pagar: 1,
        pOpcion_Orden: 1,
        pSaldo: true,
        pUserName: currentUser,
        pFil_Documento_Relacion: '',
        pSQL_str: '',
      };
    });
  
  }

  logout(): void {
    const currentTime = new Date().toISOString();
    sessionStorage.setItem('horaCierreSesion', currentTime);

    // Limpiar datos de localStorage y sessionStorage
    this.eliminarDatos(['usuario', 'user', 'pass', 'estacion', 'estacionTrabajo', 'empresa', 'aplicacion', 'display', 'jwtToken', 'horaInicioSesion', 'horaInicioSesionTemp', '_grecaptcha']);

    // Actualizar el estado del logo en el servicio
    this.utilidadService.setLogo(null);

    // Redirigir al usuario a la página de login
    this.router.navigate(['/login']);

    // Opcional: Cerrar el menú del usuario
    this.isUserMenuOpen = false;
  }

  eliminarDatos(claves: string[]): void {
      claves.forEach((clave) => {
          localStorage.removeItem(clave);
          sessionStorage.removeItem(clave);
      });
  }

  confirmarUrl() {
    this.utilidadService.setUrlService(this.urlApi); // El servicio para actualizar la URL
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

  manejarCargaLogo(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file = input.files[0];
      const reader = new FileReader();
  
      reader.onload = (e: ProgressEvent<FileReader>) => {
        this.userLogo = e.target?.result as string;
        this.logoSubido = true;
        this.utilidadService.setLogo(this.userLogo); // Actualiza el logo en el servicio
        
        // Guardar el logo en localStorage
        localStorage.setItem('userLogo', this.userLogo);
      };
  
      reader.readAsDataURL(file);
    }
  }
  
  calcularFechaVencimientoToken() {
    if (this.horaInicioSesion !== null) {
      const horaInicioSesionDate = new Date(this.horaInicioSesion);
      const vencimiento = new Date(horaInicioSesionDate.getTime() + 24 * 60 * 60 * 1000); // Suma 24 horas
      this.fechaVencimientoToken = vencimiento.toLocaleString(); // Ajusta el formato según tus necesidades
    }
  }

  verificarExpiracionToken() {
    this.intervalId = setInterval(() => {
      if (this.horaInicioSesion !== null) { // Verificar que no sea null
        const currentTime = new Date().getTime();
        const tokenExpiryTime = new Date(this.horaInicioSesion).getTime() + 24 * 60 * 60 * 1000; // Tiempo de expiración del token en 1 día (24 horas)
  
        if (currentTime >= tokenExpiryTime) {
          console.log('Token expirado. Cerrar sesión.');
          this.logout();
          clearInterval(this.intervalId); // Detener el intervalo después de cerrar la sesión
        }
      } else {
        console.warn('No hay una hora de inicio de sesión registrada.');
        clearInterval(this.intervalId); // Detener el intervalo si no hay hora de inicio
      }
    }, 1000); // Verificar cada segundo
  }

  formatDate(timestamp: number): string {
    const date = new Date(timestamp);
    return date.toLocaleString(); // Ajusta el formato según tus necesidades
  }
}
