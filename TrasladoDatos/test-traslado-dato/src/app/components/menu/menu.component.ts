import { CommonModule } from '@angular/common';
import { Component, HostListener } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { UtilidadService } from '../../services/utilidad.service';

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

  
  constructor(private utilidadService: UtilidadService){
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
}
