import { Component } from '@angular/core';
import { HeaderComponent } from '../header/header.component';
import { SidebarComponent } from '../sidebar/sidebar.component';
import { FooterComponent } from '../footer/footer.component';
import { RouterOutlet } from '@angular/router';
import { InicioComponent } from "../inicio/inicio.component";
import { SharedService } from '../../services/shared.service';

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [HeaderComponent, SidebarComponent, FooterComponent, RouterOutlet, InicioComponent],
  templateUrl: './layout.component.html',
  styleUrl: './layout.component.css'
})
export  default class LayoutComponent {
  headerText: string = ''; 

  constructor(private sharedService: SharedService) {}

  ngOnInit() {
    this.sharedService.currentHeaderText.subscribe(text => {
      this.headerText = text || '';
    });
  }
}
