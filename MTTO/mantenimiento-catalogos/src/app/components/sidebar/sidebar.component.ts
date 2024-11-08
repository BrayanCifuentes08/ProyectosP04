import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Router, RouterLinkActive, RouterModule } from '@angular/router';
import { TraduccionService } from '../../services/traduccion.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { SharedService } from '../../services/shared.service';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [CommonModule, RouterLinkActive,RouterModule,TranslateModule],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.css'
})
export class SidebarComponent {
  dropdownAbierto:            boolean = false;
  idiomaDropdownAbierto:      boolean = false;
  isSidebarVisible:           boolean = false;
  sidebarAbierto:             boolean = false;
  idiomaSeleccionado:         string = 'es';
  opcionSeleccionadaDropdown: string | null = null;
  @Output() opcionSeleccionadaCatalogo  = new EventEmitter<string | null>();
  @Output() sidebarToggle               = new EventEmitter<boolean>();

  constructor(private router: Router, public traduccionService: TraduccionService, private sharedService: SharedService) {
    this.idiomaSeleccionado = this.traduccionService.getIdiomaActual();
  }

  ngOnInit(){
    this.sharedService.sidebarOpen$.subscribe(open => {
      this.sidebarAbierto = open;
    });
  }

  cerrarSidebar() {
    this.sidebarAbierto = false;
    this.sharedService.alternarSidebar(false);
  }
  
  alternarDropdownCatalogos() {
    this.dropdownAbierto = !this.dropdownAbierto;
  }

  seleccionarOpcionCatalogo(option: string) {
    this.opcionSeleccionadaDropdown = option; // Guarda la opción seleccionada del dropdown
    this.sharedService.setCatalogoSeleccionado(option); // Establece la opción al servicio
    this.dropdownAbierto = false;
    this.opcionSeleccionadaCatalogo.emit(option); // Emite la opción seleccionada
    this.sidebarAbierto =false;
  }

  alternarDropdownIdioma() {
    this.idiomaDropdownAbierto = !this.idiomaDropdownAbierto;
  }

  seleccionarIdioma(language: string) {
    this.traduccionService.cambiarIdioma(language); // Cambia el idioma
    console.log('Idioma seleccionado:', language);
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

  logout(): void {
    sessionStorage.clear()
    localStorage.clear()
    this.router.navigate(['/login']); // Redirige al login
  }
}
