import { CommonModule } from '@angular/common';
import { Component, HostListener } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { UtilidadService } from '../../services/utilidad.service';
import { TraduccionService } from '../../services/traduccion.service';
import { Router } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { ApiService } from '../../services/api.service';

@Component({
  selector: 'app-menu',
  standalone: true,
  imports: [CommonModule, TranslateModule, FormsModule],
  templateUrl: './menu.component.html',
  styleUrl: './menu.component.css'
})
export class MenuComponent {
  menuAbierto = false;
  subMenuAbierto = false;
  isSmallScreen = false;
  isMenuOpen = false;
  isLanguageMenuOpen = false;
  esModoOscuro = false;
  isIdiomaMenuOpen = false;
  isUserMenuOpen = false;
  nombreUsuario: string = '';
  empresaUsuario: string = '';
  isSectionVisible = false;
  mostrarMensajeUrlConfirmacion: boolean= false ;
  isVerificando: boolean = false;
  esValido: boolean = false;
  esError: boolean = false;
  mensajeErrorUrl: string = '';
  mostrarMensajeUrlVerificacion: boolean = false;
  urlApi: string = '';
  isServerConfigOpen = false; // Estado de visibilidad del modal
  database = ''; // Modelo para el input de la base de datos
  server = ''; // Modelo para el input del servidor
  cargandoConexion: boolean = false;
  isSuccess: boolean = false; // Controlar visibilidad del mensaje de éxito
  isError: boolean = false;   // Controlar visibilidad del mensaje de error
  successMessage: string = ''; // Mensaje de éxito
  errorMessage: string = '';   // Mensaje de error


  constructor(private utilidadService: UtilidadService, public traduccionService: TraduccionService, private apiService: ApiService, private router: Router){
    this.utilidadService.inicializacionTema();
    this.urlApi = apiService.getBaseUrl()
    // Inicializar datos del usuario
    this.nombreUsuario = this.apiService.getUser();
    const empresaData = this.apiService.getEstacion();
    this.empresaUsuario = empresaData.descripcion || 'No disponible';
  }

  toggleMenu() {
    this.isMenuOpen = !this.isMenuOpen;
  }

  toggleLanguageMenu() {
    this.isLanguageMenuOpen = !this.isLanguageMenuOpen;
  }

  //*Seccion de funciones para el modo de la interfaz
  toggleTheme(): void {
    this.utilidadService.alternarTema();
  }

  get isDarkMode(): boolean {
    return this.utilidadService.esModoOscuroHabilitado();
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

  logout(): void {
    sessionStorage.clear()
    localStorage.clear()
    this.router.navigate(['/login']); // Redirige al login
  }


  toggleUserMenu(): void {
    this.isUserMenuOpen = !this.isUserMenuOpen;
  }

  toggleSection(): void {
    this.isSectionVisible = !this.isSectionVisible;
  }


  confirmarUrl() {
    this.utilidadService.setUrlService(this.urlApi); // El servicio para actualizar la URL
    console.log(`URL API actualizada a: ${this.urlApi}`);
    this.isSectionVisible = false;
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

  openServerConfigDialog(): void {
    this.isServerConfigOpen = true;
  }

  closeServerConfigDialog(): void {
    this.isServerConfigOpen = false;
  }

  conectarBaseDeDatos(): void {
    const user = this.apiService.getUser();
    const empresa = this.apiService.getEmpresa();
    this.cargandoConexion = true;
    this.isSuccess = false;  
    this.isError = false;    
    this.successMessage = '';
    this.errorMessage = '';   
    const model = {
      serverName: this.server,
      databaseName: this.database
    };
  
    this.cargandoConexion = true;
    // Llamada a la API para conectar a la base de datos
    this.apiService.conectarBaseDeDatos(model).subscribe({
      next: (data) => {
        console.log('Conexión exitosa:', data);
        this.cargandoConexion = false;
        //this.manejarMensajeExito('Conexión establecida correctamente.');
        this.cargandoConexion = false;
        this.isSuccess = true;
        this.successMessage = 'Conexión establecida correctamente.';

        setTimeout(() => {
          this.closeServerConfigDialog()
        }, 4000);
      },
      error: (err) => {
        this.cargandoConexion = false;
        console.error('Error al conectar:', err);
        this.isError = true;
        this.errorMessage = 'Error al intentar conectar a la base de datos.';

        //this.manejarMensajeError('Error al intentar conectar a la base de datos.');
      }
    });
  }
  
}
