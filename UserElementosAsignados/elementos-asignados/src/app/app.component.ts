import { Component, Inject, PLATFORM_ID } from '@angular/core';
import { Router, RouterOutlet } from '@angular/router';
import { SharedService } from './services/shared.service';
import { isPlatformBrowser } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'mantenimiento-elementos-asignados';
  loading: boolean = true;
  constructor(public sharedService: SharedService, private router: Router,     @Inject(PLATFORM_ID) private platformId: Object){}

  ngOnInit(): void {
    // this.mostrarLoadingScreen();
  }

  
}
