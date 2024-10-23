import { CUSTOM_ELEMENTS_SCHEMA, Component } from '@angular/core';
import { TranslateModule } from '@ngx-translate/core';

@Component({
  selector: 'app-loading',
  standalone: true,
  imports: [TranslateModule],
  templateUrl: './loading.component.html',
  styleUrl: './loading.component.css',
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
})
export class LoadingComponent {
  isLoading: boolean = true;

  ngOnInit(): void {
    setTimeout(() => {
      this.isLoading = false; // Ocultar el componente de carga
    }, 3000);
  }
}
