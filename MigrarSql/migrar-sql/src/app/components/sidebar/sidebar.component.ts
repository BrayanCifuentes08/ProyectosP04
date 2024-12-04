import { CommonModule, isPlatformBrowser } from '@angular/common';
import { Component, EventEmitter, Inject, Output, PLATFORM_ID } from '@angular/core';
import { Router } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { LoginService } from '../../services/login.service';
import { TraduccionService } from '../../services/traduccion.service';
import { SharedService } from '../../services/shared.service';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [CommonModule, TranslateModule],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.css'
})
export class SidebarComponent {
  user: string = ''
  horaInicioSesionFormatted: string | null = null;
  fechaVencimientoToken: string | null = null;
  usandoHoraPerma: boolean = false;
  tooltipVisible: boolean = false;
  tiempoRestante: string = '';
  dropdownAbierto = false;
  idiomaDropdownAbierto: boolean = false;
  idiomaSeleccionado: string = 'es';
  @Output() opcionSeleccionadaCatalogo  = new EventEmitter<string | null>();
  opcionSeleccionadaDropdown: string | null = null;
  @Output() sidebarToggle = new EventEmitter<boolean>();
  isSidebarVisible: boolean = false;
  sidebarAbierto: boolean = false;
  esModoOscuro: boolean = false;
  
  constructor(private router: Router, private loginServices: LoginService, 
    private traduccionService: TraduccionService, 
    private sharedService: SharedService,
    @Inject(PLATFORM_ID) private platformId: Object
  ){
    if (isPlatformBrowser(this.platformId)) {
  
    this.idiomaSeleccionado = this.traduccionService.getIdiomaActual();
    this.horaInicioSesionFormatted = localStorage.getItem('horaInicioSesionFormatted');
      // Recuperar valores del localStorage
      this.horaInicioSesionFormatted = localStorage.getItem('horaInicioSesionFormatted');
      
    
      
      // Determinar si se esta usando una sesion permanente o temporal
      const horaInicioSesionLocal = localStorage.getItem('horaInicioSesion');
      this.usandoHoraPerma = !!horaInicioSesionLocal; 
  
      if (this.fechaVencimientoToken) {
        this.iniciarContador();  // Inicia el contador
      }
    }
  }

  ngOnInit(){
    if (isPlatformBrowser(this.platformId)) {
    this.fechaVencimientoToken = localStorage.getItem('fechaVencimientoToken');
    this.user = this.loginServices.getUser();
    this.sharedService.sidebarOpen$.subscribe((open: any) => {
      this.sidebarAbierto = open;
    });
  }

  this.esModoOscuro = this.sharedService.esModoOscuroHabilitado();

  // Suscribirse a cambios en el tema
  this.sharedService.temaCambiado$.subscribe((esOscuro) => {
    this.esModoOscuro = esOscuro;
  });
  }

  logout(): void {
    sessionStorage.clear()
    localStorage.clear()
    this.router.navigate(['/login']); // Redirige al login
  }

  iniciarContador() {
    const partesFecha = this.fechaVencimientoToken!.split(', ');
    const [fecha, hora] = partesFecha;
    const [dia, mes, anio] = fecha.split('/');
    const [horas, minutos, segundos] = hora.split(':');
  
    const fechaVencimiento = new Date(+anio, +mes - 1, +dia, +horas, +minutos, +segundos);
  
    if (isNaN(fechaVencimiento.getTime())) {
      console.error("Fecha de vencimiento no válida: ", this.fechaVencimientoToken);
      this.tiempoRestante = 'Fecha no válida';
      return;
    }
  
    const actualizarContador = () => {
      const ahora = new Date().getTime();
      const diferencia = fechaVencimiento.getTime() - ahora;
  
      if (diferencia <= 0) {
        this.tiempoRestante = '00:00:00';  // Sesión expirada
        clearInterval(intervalo);
      } else {
        const horas = Math.floor(diferencia / (1000 * 60 * 60));
        const minutos = Math.floor((diferencia % (1000 * 60 * 60)) / (1000 * 60));
        const segundos = Math.floor((diferencia % (1000 * 60)) / 1000);
  
        this.tiempoRestante = 
          `${this.pad(horas)}:${this.pad(minutos)}:${this.pad(segundos)}`;
      }
    };
  
    const intervalo = setInterval(actualizarContador, 1000);
    actualizarContador();  // Inicializa el contador de inmediato
  }
  
  // Función pad para formatear números menores a 10 con ceros a la izquierda
  pad(n: number): string {
    return n < 10 ? '0' + n : '' + n;
  }  

  alternarDropdownIdioma() {
    this.idiomaDropdownAbierto = !this.idiomaDropdownAbierto;
  }

  seleccionarIdioma(language: string) {
    this.traduccionService.cambiarIdioma(language); // Cambia el idioma
    this.idiomaSeleccionado = language;
    this.idiomaDropdownAbierto = false; 
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

  cerrarSidebar() {
    this.sidebarAbierto = false;
    this.sharedService.alternarSidebar(false);
  }
  
}
