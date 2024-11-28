import { Routes } from '@angular/router';
import { AuthGuard } from './guards/auth.guard';

export const routes: Routes = [
    {
        path: 'login', // Ruta para el login
        loadComponent: () => import('./components/login/login.component'),
      },
      {
        path: '', // Ruta para el layout principal
        loadComponent: () => import('./components/layout/layout.component'),
        canActivate: [AuthGuard], // Protegida por el guard
        children: [
          {
            path: 'trasladoDatos',
            loadComponent: () => import('./components/traslado/traslado.component'),
          },
        ],
      },
      {
        path: '**',
        redirectTo: 'login', // Redirige al login por defecto si la ruta no existe
      },
];
