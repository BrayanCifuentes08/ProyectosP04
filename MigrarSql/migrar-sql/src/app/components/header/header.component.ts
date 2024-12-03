import { Component, Inject, Input, PLATFORM_ID } from '@angular/core';
import { TraduccionService } from '../../services/traduccion.service';
import { TranslateModule } from '@ngx-translate/core';
import { SharedService } from '../../services/shared.service';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { LoginService } from '../../services/login.service';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [TranslateModule, CommonModule,],
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {
  esModoOscuro: boolean = false;
  usuario: string = ''
  menuColoresVisible: boolean = false; 
  @Input() headerText: string = 'labels.componenteInicio';
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
    this.sharedService.currentHeaderText.subscribe((texto) => {
      this.headerText = texto || 'labels.componenteInicio';
    });
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
