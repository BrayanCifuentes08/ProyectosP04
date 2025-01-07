import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { LayoutComponent } from './components/layout/layout.component';

const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent }, // Ruta para el login
  {
    path: '',
    component: LayoutComponent, // Contenedor principal
    children: [
      { path: 'dashboard', component: DashboardComponent }, // Ruta para el dashboard
    ],
  },
  { path: '**', redirectTo: 'login' }, // Redirigir al login si la ruta no existe
];
@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
