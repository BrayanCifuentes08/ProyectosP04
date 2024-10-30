import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [CommonModule],
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
  constructor(private router: Router, private apiService: ApiService){
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

  ngOnInit(){
    this.fechaVencimientoToken = localStorage.getItem('fechaVencimientoToken');
    this.user = this.apiService.getUser();
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
}
