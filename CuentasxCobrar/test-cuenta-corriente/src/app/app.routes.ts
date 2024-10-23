import { RouterModule, Routes } from '@angular/router';
import { TablaComponent } from './tablaCliente/tablaCliente.component';
import { TablaDocsPendientesComponent } from './tablaDocsPendientesPago/tablaDocsPendientesPago.component';
import { LoginComponent } from './login/login.component';
import { LoadingScreenComponent } from './loading-screen/loading-screen.component';
import { InicioComponent } from './inicio/inicio.component';

export const routes: Routes = [
  { path: 'login', component: LoginComponent },
  {
    path: 'inicio',
    component: InicioComponent,
    children: [
      { path: 'tabla', component: TablaComponent },
      { path: 'documentospendientes', component: TablaDocsPendientesComponent },
      { path: '', redirectTo: '', pathMatch: 'full' }
    ]
  },
  { path: 'loading', component: LoadingScreenComponent },
  { path: '', redirectTo: '/loading', pathMatch: 'full' } // Ruta inicial
];
