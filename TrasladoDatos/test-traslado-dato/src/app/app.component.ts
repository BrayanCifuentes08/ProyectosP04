import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { TrasladoComponent } from "./components/traslado/traslado.component";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, TrasladoComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'test-traslado-dato';
}
