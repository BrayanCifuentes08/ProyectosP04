import { Component, HostListener } from '@angular/core';

@Component({
  selector: 'app-menu',
  standalone: true,
  imports: [],
  templateUrl: './menu.component.html',
  styleUrl: './menu.component.css'
})
export class MenuComponent {
  menuAbierto = false;
  subMenuAbierto = false;
  isSmallScreen = false;

  @HostListener('window:resize')
  onResize() {
    this.isSmallScreen = window.innerWidth < 1024;
  }

  toggleMenu() {
    this.menuAbierto = !this.menuAbierto;
  }

  toggleSubMenu() {
    this.subMenuAbierto = !this.subMenuAbierto;
  }

  cerrarSesion() {
    console.log('Cerrando sesión...');
  }

  cambiarIdioma() {
    console.log('Cambiando idioma...');
  }

  cambiarURL(url: string) {
    console.log(`Cambiando a URL: ${url}`);
  }

}
