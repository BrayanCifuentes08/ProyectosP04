import { Component, Inject, PLATFORM_ID } from '@angular/core';
import { TraduccionService } from '../../services/traduccion.service';
import { TranslateModule } from '@ngx-translate/core';
import { SharedService } from '../../services/shared.service';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { ApiService } from '../../services/api.service';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [TranslateModule, CommonModule],
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {
  esModoOscuro: boolean = false;
  usuario: string = ''
  constructor(
    public traduccionService: TraduccionService, 
    private sharedService: SharedService, 
    private apiService:ApiService,    
    @Inject(PLATFORM_ID) private platformId: Object
  )
    {}

  ngOnInit(){
    if (isPlatformBrowser(this.platformId)) {
    this.usuario = this.apiService.getUser();
    }
    //Inicializar tema oscuro
    this.sharedService.inicializacionTema();
  }

  //*Seccion de funciones para el modo de la interfaz
  toggleTheme(): void {
    this.sharedService.alternarTema();
  }

  get isDarkMode(): boolean {
    return this.sharedService.esModoOscuroHabilitado();
  }
  
  //Funcion para abirir el sidebar
  abrirSidebar() {
    this.sharedService.alternarSidebar(true);
  }

}
