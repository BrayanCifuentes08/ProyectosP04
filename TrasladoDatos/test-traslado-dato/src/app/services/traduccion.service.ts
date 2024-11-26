import { Injectable } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';

@Injectable({
  providedIn: 'root'
})
export class TraduccionService {

  constructor(private translate: TranslateService ) {
    this.translate.addLangs(['en', 'es', 'fr', 'de']);
    this.translate.setDefaultLang('es');
    const browserLang = this.translate.getBrowserLang();
    this.translate.use(browserLang && (browserLang.match(/en|es|fr|de/) ? browserLang : 'es') || 'es');
  }
   
  cambiarIdioma(language: string) {
    this.translate.use(language);
  }

  getIdiomaActual(): string {
    const currentLang = this.translate.currentLang || 'es';
    return currentLang;
  }

  traducirDatosImpresion(clave: string): string {
    return this.translate.instant(clave);
  }
  
  traducirTexto(clave: string): string {
    const traduccion = this.translate.instant(`labels.${clave}`);
    // Si no encuentra la traducción, devuelve el texto original (que ahora sería la clave)
    return traduccion !== `labels.${clave}` ? traduccion : clave;
  }
}


