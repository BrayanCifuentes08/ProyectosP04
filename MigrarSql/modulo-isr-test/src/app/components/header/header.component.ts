import { Component, Inject, PLATFORM_ID } from '@angular/core';
import { TraduccionService } from '../../services/traduccion.service';
import { SharedService } from '../../services/shared.service';
import { LoginService } from '../../services/login.service';
import { isPlatformBrowser } from '@angular/common';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {
  esModoOscuro: boolean = false;
  usuario: string = ''
  menuColoresVisible: boolean = false; 
  constructor(
    public traduccionService: TraduccionService, 
    private sharedService: SharedService, 
    private loginService:LoginService,    
    @Inject(PLATFORM_ID) private platformId: Object
  )
  {}

  ngOnInit(){
    if (isPlatformBrowser(this.platformId)) {
    this.usuario = this.loginService.getUser();
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
