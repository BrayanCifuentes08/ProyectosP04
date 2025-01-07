import { Component } from '@angular/core';
import { SharedService } from '../../services/shared.service';
import { LoginService } from '../../services/login.service';

@Component({
  selector: 'app-footer',
  templateUrl: './footer.component.html',
  styleUrl: './footer.component.css'
})
export class FooterComponent {
  catalogoSeleccionado: string | null = null;
  accionActual:         string = '';
  usuario:              string = ''
  estacionTrabajo:      string = ''
  empresa:              string = ''
  constructor(private sharedService: SharedService, private loginService: LoginService) {}

  ngOnInit() {
    this.usuario = this.loginService.getUser();
    
    const estacionTrabajo = this.loginService.getEstacion()
    this.estacionTrabajo = estacionTrabajo?.descripcion || '';

    const empresa = this.loginService.getEmpresa();
    this.empresa = empresa?.empresa_Nombre || '';

    // Suscribirse a los cambios de catalogoSeleccionado en el servicio
    this.sharedService.catalogoSeleccionado$.subscribe(option => {
      this.catalogoSeleccionado = option; 
    });

    
    this.sharedService.accion$.subscribe(accion => {
      this.accionActual = accion; 
    });
    console.log("Usuario cargado en footer al entrar a mantenimiento: ", this.usuario)
  }
}