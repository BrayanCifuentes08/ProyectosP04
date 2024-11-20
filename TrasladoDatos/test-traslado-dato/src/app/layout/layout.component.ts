import { Component } from '@angular/core';
import { TrasladoComponent } from "../components/traslado/traslado.component";
import { MenuComponent } from "../components/menu/menu.component";

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [TrasladoComponent, MenuComponent],
  templateUrl: './layout.component.html',
  styleUrl: './layout.component.css'
})
export class LayoutComponent {

}
