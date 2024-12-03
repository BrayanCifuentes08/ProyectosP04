  import { Injectable } from '@angular/core';
  import { CanActivate, Router } from '@angular/router';
  import { isPlatformBrowser } from '@angular/common';
  import { Inject, PLATFORM_ID } from '@angular/core';

  @Injectable({
    providedIn: 'root'
  })
  export class AuthGuard implements CanActivate {
    constructor(private router: Router, @Inject(PLATFORM_ID) private platformId: Object) {}

    canActivate(): boolean {
      if (isPlatformBrowser(this.platformId)) {
        const token = localStorage.getItem('jwtToken') || sessionStorage.getItem('jwtToken');
        if (!token) {
          // Almacenar el estado de redirección
          this.router.navigate(['/login']);
          return false;
        }
      }
      return true; // Permitir acceso si hay un token
    }
    
  }
