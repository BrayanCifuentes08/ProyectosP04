import { Routes } from '@angular/router';

export const routes: Routes = [
    {
        path: '',
        loadComponent: ()  => import('./components/layout/layout.component'),
        children: [
            {
                path: 'dashboard',
                loadComponent: ()  => import('./components/dashboard/dashboard.component'),
            },
            {
                path: '',
                redirectTo: 'dashboard',
                pathMatch: 'full'
            }
        ]
    }
];

