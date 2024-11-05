import { Component } from '@angular/core';
import { TranslateModule } from '@ngx-translate/core';
import { SharedService } from '../../services/shared.service';
import { ApiService } from '../../services/api.service';

@Component({
  selector: 'app-footer',
  standalone: true,
  imports: [TranslateModule],
  templateUrl: './footer.component.html',
  styleUrl: './footer.component.css'
})
export class FooterComponent {
  catalogoSeleccionado: string | null = null;
  accionActual: string = '';
  usuario: string = ''
  estacionTrabajo: string = ''

  constructor(private sharedService: SharedService, private apiService: ApiService) {}
  ngOnInit() {
    this.usuario = this.apiService.getUser();
    const estacionTrabajo = this.apiService.getEstacion()
    this.estacionTrabajo = estacionTrabajo?.descripcion || '';
    // Suscribirse a los cambios de catalogoSeleccionado en el servicio
    this.sharedService.catalogoSeleccionado$.subscribe(option => {
      this.catalogoSeleccionado = option; 
    });
    
    this.sharedService.accion$.subscribe(accion => {
      this.accionActual = accion; 
    });
  }
  
}
