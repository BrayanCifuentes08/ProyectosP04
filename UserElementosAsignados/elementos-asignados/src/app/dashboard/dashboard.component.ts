import { Component } from '@angular/core';
import { InicioComponent } from "../components/inicio/inicio.component";

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [InicioComponent],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export default class DashboardComponent {

}
