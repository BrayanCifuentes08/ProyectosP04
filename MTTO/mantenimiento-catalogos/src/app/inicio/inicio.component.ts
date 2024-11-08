import { Component , PLATFORM_ID , Inject} from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { TranslateModule } from '@ngx-translate/core';
import { NavigationEnd, Router, RouterLink, RouterOutlet } from '@angular/router';
import { SharedService } from '../services/shared.service';
import { ApiService } from '../services/api.service';
@Component({
  selector: 'app-inicio',
  standalone: true,
  imports: [TranslateModule, CommonModule],
  templateUrl: './inicio.component.html',
  styleUrl: './inicio.component.css'
})
export default class InicioComponent {
  usuario:                   string =''
  horaInicioSesionFormatted: string | null = null;
  fechaVencimientoToken:     string | null = null;
  usandoHoraPerma:           boolean = false;
  tooltipVisible:            boolean = false;
  tiempoRestante:            string = '';

  constructor(
    private router: Router,
    private sharedService: SharedService,
    private apiService: ApiService,
    @Inject(PLATFORM_ID) private platformId: Object
  ) {}

  ngOnInit() {
    if (isPlatformBrowser(this.platformId)) {
      // Recuperar valores del localStorage
      this.horaInicioSesionFormatted = localStorage.getItem('horaInicioSesionFormatted');
      this.fechaVencimientoToken = localStorage.getItem('fechaVencimientoToken');
      this.usuario = this.apiService.getUser();
      
      // Determinar si se esta usando una sesion permanente o temporal
      const horaInicioSesionLocal = localStorage.getItem('horaInicioSesion');
      this.usandoHoraPerma = !!horaInicioSesionLocal; 
  
      if (this.fechaVencimientoToken) {
        this.iniciarContador();  // Inicia el contador
      }
      // Obtener los datos de localStorage y sessionStorage
      const estacionTrabajo = JSON.parse(localStorage.getItem('estacionTrabajo') || '{}');
      const empresa = JSON.parse(localStorage.getItem('empresa') || '{}');
      const aplicacion = JSON.parse(localStorage.getItem('aplicacion') || '{}');
      const display = JSON.parse(localStorage.getItem('display') || '{}');
  
      // Verificar si los datos estan en localStorage
      const datosEnLocalStorage = estacionTrabajo && empresa && aplicacion && display;
  
      // Si los datos no estan en localStorage
      if (!datosEnLocalStorage) {
        const datosEnSessionStorage = sessionStorage.getItem('estacionTrabajo') ||
                                      sessionStorage.getItem('empresa') ||
                                      sessionStorage.getItem('aplicacion') ||
                                      sessionStorage.getItem('display');
  
        if (datosEnSessionStorage) {
          // Si hay datos en sessionStorage, redirigir al login
          this.limpiarSessionStorageYRedirigir();
        } else {
          // Si no hay datos en ninguno, redirigir al login
          this.router.navigate(['/login']);
        }
      } else {
        this.router.navigate(['/inicio']);
      }
    }
  }
  
  limpiarSessionStorageYRedirigir(): void {
    sessionStorage.clear(); 
    console.log('sessionStorage limpiado');
    this.router.navigate(['/login']); 
  }

  logout(): void {
    sessionStorage.clear()
    localStorage.clear()
    this.router.navigate(['/login']); // Redirige al login
  }

  eliminarDatos(claves: string[]): void {
      claves.forEach((clave) => {
          localStorage.removeItem(clave);
          sessionStorage.removeItem(clave);
      });
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
}