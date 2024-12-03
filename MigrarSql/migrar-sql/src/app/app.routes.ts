import { Routes } from '@angular/router';
import { AuthGuard } from './guards/auth.guard';

export const routes: Routes = [
    {
        path: '',
        loadComponent: () => import('./components/layout/layout.component'),
        children: [
            {
                path: 'dashboard',
                loadComponent: () => import('./components/dashboard/dashboard.component'),
                canActivate: [AuthGuard], // Protege todo el dashboard
                children: [
                    {
                        path: 'migracion',
                        loadComponent: () => import('./components/migrar-datos/migrar-datos.component'),
                    },
                    {
                        path: '',
                        redirectTo: 'migracion',
                        pathMatch: 'full'
                    }
                ]
            },
            {
                path: '',
                redirectTo: 'dashboard',
                pathMatch: 'full'
            }
        ]
    },
    {
        path: 'login',
        loadComponent: () => import('./components/login/login.component'),
    }
];
