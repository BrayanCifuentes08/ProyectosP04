import { CommonModule } from '@angular/common';
import { Component, HostListener } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { UtilidadService } from '../../services/utilidad.service';
import { TraduccionService } from '../../services/traduccion.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-menu',
  standalone: true,
  imports: [CommonModule],
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
  
  constructor(private utilidadService: UtilidadService, public traduccionService: TraduccionService, private router: Router){
    //Inicializar tema oscuro
    this.utilidadService.inicializacionTema();
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

}
