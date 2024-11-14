import { isPlatformBrowser } from '@angular/common';
import { Inject, Injectable, PLATFORM_ID } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { ApiService } from './api.service';
import { TraduccionService } from './traduccion.service';

@Injectable({
  providedIn: 'root'
})
export class UtilidadService {
  private cargaSubject = new BehaviorSubject<boolean>(false);
  public carga$ = this.cargaSubject.asObservable();
  private darkModeKey = 'darkMode';
  private baseUrl: string = '';
  public colorSeleccionado: string = '';
  private esModoOscuro: boolean = false;

  constructor(@Inject(PLATFORM_ID) private platformId: Object, private apiService: ApiService,
  private idiomaService: TraduccionService ) {
    const storedMode = localStorage.getItem('darkMode');
    this.esModoOscuro = storedMode ? JSON.parse(storedMode) : false;
    this.updateTheme();
    this.baseUrl = this.apiService.getBaseUrl();
  }

  private unidades = {
    'es': ["", "UNO", "DOS", "TRES", "CUATRO", "CINCO", "SEIS", "SIETE", "OCHO", "NUEVE"],
    'en': ["", "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE"],
    'de': ["", "EINS", "ZWEI", "DREI", "VIER", "FÜNF", "SECHS", "SIEBEN", "ACHT", "NEUN"],
    'fr': ["", "UN", "DEUX", "TROIS", "QUATRE", "CINQ", "SIX", "SEPT", "HUIT", "NEUF"]
  };

  private decenas = {
    'es': ["", "DIEZ", "VEINTE", "TREINTA", "CUARENTA", "CINCUENTA", "SESENTA", "SETENTA", "OCHENTA", "NOVENTA"],
    'en': ["", "TEN", "TWENTY", "THIRTY", "FORTY", "FIFTY", "SIXTY", "SEVENTY", "EIGHTY", "NINETY"],
    'de': ["", "ZEHN", "ZWANZIG", "DREISSIG", "VIERZIG", "FÜNFZIG", "SECHZIG", "SIEBZIG", "ACHTZIG", "NEUNZIG"],
    'fr': ["", "DIX", "VINGT", "TRENTE", "QUARANTE", "CINQUANTE", "SOIXANTE", "SOIXANTE-DIX", "QUATRE-VINGT", "QUATRE-VINGT-DIX"]
  };

  private especiales = {
    'es': ["DIEZ", "ONCE", "DOCE", "TRECE", "CATORCE", "QUINCE", "DIECISÉIS", "DIECISIETE", "DIECIOCHO", "DIECINUEVE"],
    'en': ["TEN", "ELEVEN", "TWELVE", "THIRTEEN", "FOURTEEN", "FIFTEEN", "SIXTEEN", "SEVENTEEN", "EIGHTEEN", "NINETEEN"],
    'de': ["ZEHN", "ELF", "ZWÖLF", "DREIZEHN", "VIERZEHN", "FÜNFZEHN", "SECHZEHN", "SIEBZEHN", "ACHTZEHN", "NEUNZEHN"],
    'fr': ["DIX", "ONZE", "DOUZE", "TREIZE", "QUATORZE", "QUINZE", "SEIZE", "DIX-SEPT", "DIX-HUIT", "DIX-NEUF"]
  };

  private centenas = {
    'es': ["", "CIEN", "DOSCIENTOS", "TRESCIENTOS", "CUATROCIENTOS", "QUINIENTOS", "SEISCIENTOS", "SETECIENTOS", "OCHOCIENTOS", "NOVECIENTOS"],
    'en': ["", "ONE HUNDRED", "TWO HUNDRED", "THREE HUNDRED", "FOUR HUNDRED", "FIVE HUNDRED", "SIX HUNDRED", "SEVEN HUNDRED", "EIGHT HUNDRED", "NINE HUNDRED"],
    'de': ["", "EINHUNDERT", "ZWEIHUNDERT", "DREIHUNDERT", "VIERHUNDERT", "FÜNFHUNDERT", "SECHSHUNDERT", "SIEBENHUNDERT", "ACHTHUNDERT", "NEUNHUNDERT"],
    'fr': ["", "CENT", "DEUX CENTS", "TROIS CENTS", "QUATRE CENTS", "CINQ CENTS", "SIX CENTS", "SEPT CENTS", "HUIT CENTS", "NEUF CENTS"]
  };

  private miles = {
    'es': [
      "",
      "MIL",
      "DOS MIL",
      "TRES MIL",
      "CUATRO MIL",
      "CINCO MIL",
      "SEIS MIL",
      "SIETE MIL",
      "OCHO MIL",
      "NUEVE MIL"
    ],
    'en': [
      "",
      "ONE THOUSAND",
      "TWO THOUSAND",
      "THREE THOUSAND",
      "FOUR THOUSAND",
      "FIVE THOUSAND",
      "SIX THOUSAND",
      "SEVEN THOUSAND",
      "EIGHT THOUSAND",
      "NINE THOUSAND"
    ],
    'de': [
      "",
      "TAUSEND",
      "ZWEITAUSEND",
      "DREITAUSEND",
      "VIERTAUSEND",
      "FÜNFTAUSEND",
      "SECHSTAUSEND",
      "SIEBENTAUSEND",
      "ACHTTAUSEND",
      "NEUNTAUSEND"
    ],
    'fr': [
      "",
      "MILLE",
      "DEUX MILLE",
      "TROIS MILLE",
      "QUATRE MILLE",
      "CINQ MILLE",
      "SIX MILLE",
      "SEPT MILLE",
      "HUIT MILLE",
      "NEUF MILLE"
    ]
  };

  private millones = {
    'es': [
      "",
      "UN MILLÓN",
      "DOS MILLONES",
      "TRES MILLONES",
      "CUATRO MILLONES",
      "CINCO MILLONES",
      "SEIS MILLONES",
      "SIETE MILLONES",
      "OCHO MILLONES",
      "NUEVE MILLONES"
    ],
    'en': [
      "",
      "ONE MILLION",
      "TWO MILLION",
      "THREE MILLION",
      "FOUR MILLION",
      "FIVE MILLION",
      "SIX MILLION",
      "SEVEN MILLION",
      "EIGHT MILLION",
      "NINE MILLION"
    ],
    'de': [
      "",
      "EINE MILLION",
      "ZWEI MILLIONEN",
      "DREI MILLIONEN",
      "VIER MILLIONEN",
      "FÜNF MILLIONEN",
      "SECHS MILLIONEN",
      "SIEBEN MILLIONEN",
      "ACHT MILLIONEN",
      "NEUN MILLIONEN"
    ],
    'fr': [
      "",
      "UN MILLION",
      "DEUX MILLIONS",
      "TROIS MILLIONS",
      "QUATRE MILLIONS",
      "CINQ MILLIONS",
      "SIX MILLIONS",
      "SEPT MILLIONS",
      "HUIT MILLIONS",
      "NEUF MILLIONS"
    ]
  };

  private textosConexion = {
    'es': { 'y': ' Y ', 'con': ' CON ' },
    'en': { 'y': '', 'con': ' WITH ' },
    'de': { 'y': ' UND ', 'con': ' MIT ' },
    'fr': { 'y': ' ET ', 'con': ' AVEC ' }
  };

  // UtilidadService
  setUrlService(newUrl: string): void {
    this.baseUrl = newUrl;

    // Guardar la URL en localStorage y sessionStorage
    localStorage.setItem('urlApi', newUrl); // Guardar en localStorage
    sessionStorage.setItem('urlApi', newUrl); // Guardar en sessionStorage

    // Actualizar la URL en el API
    this.apiService.setBaseUrl(this.baseUrl);
    console.log(`URL API actualizada a: ${this.baseUrl}`);
  }

  getUrlService(): string {
    // Verificar si existe una URL en localStorage o sessionStorage
    const urlFromLocal = localStorage.getItem('urlApi');
    const urlFromSession = sessionStorage.getItem('urlApi');
    
    // Preferir la URL almacenada en localStorage, luego en sessionStorage
    return urlFromLocal ?? urlFromSession ?? this.baseUrl; // Retornar la URL, o la base por defecto si no existe ninguna
  }
  toggleModoOscuro() {
    this.esModoOscuro = !this.esModoOscuro;
    localStorage.setItem('darkMode', JSON.stringify(this.esModoOscuro));
    this.updateTheme();
  }

  updateTheme() {
    if (this.esModoOscuro) {
      document.documentElement.classList.add('dark');
      this.colorSeleccionado = 'linear-gradient(to bottom, #09203f, #537895)';
    } else {
      document.documentElement.classList.remove('dark');
      this.colorSeleccionado = 'linear-gradient(to bottom, #1e3a8a, #f97316)';
    }
  }

  getColorSeleccionado() {
    return this.colorSeleccionado;
  }

  isDarkMode() {
    return this.esModoOscuro;
  }
 

  formatearFecha(fechaString: string): string {
    if (!fechaString) return ''; //Manejo de casos donde la fecha es nula o indefinida

    const fecha = new Date(fechaString);
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const año = fecha.getFullYear();
    
    return `${dia}/${mes}/${año}`;
  }

  formatearFechaHora(date: Date): string {
    return date.toLocaleString('es-ES', { // Cambia 'es-ES' por el locale que desees
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hour12: false // Usa 24 horas
    });
  }

  formatearNumeros(valor: number): string {
    return valor.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
  }
  
  private logoSubject = new BehaviorSubject<string | null>(localStorage.getItem('userLogo') || null);
  logo$ = this.logoSubject.asObservable();
  
  setLogo(logo: string | null) {
    this.logoSubject.next(logo);
    if (logo) {
      localStorage.setItem('userLogo', logo); // Guarda el logo en el localStorage
    } else {
      localStorage.removeItem('userLogo'); // Elimina el logo si es nulo
    }
  }
  
  // Método para obtener el logo
  getLogo(): string | null {
    return this.logoSubject.getValue(); // Obtiene el valor actual del logo
  }

  numeroALetras(numero: number, idioma: string): string {
    if (!['es', 'en', 'de', 'fr'].includes(idioma)) {
        throw new Error('Idioma no soportado');
    }

    numero = Math.abs(numero);

    const convertirParteEntera = (num: number): string => {

      if (numero < 0 || numero >= 1000000000) {
        return "Número fuera de rango";
      }

        switch(idioma){
          case 'es': // Español
            if (num < 10) {
              return this.unidades['es']![num];
            } else if (num < 20) {
              return this.especiales['es']![num - 10];
            } else if (num < 100) {
              const decena = Math.floor(num / 10);
              const unidad = num % 10;
  
              // Verificamos si el número está entre 21 y 29
              if (decena == 2 && unidad > 0) {
                return "VEINTI" +
                    this.unidades['es']![
                        unidad]; // Casos como veintiuno, veintidós, etc.
              } else {
                // Para otros casos (como treinta y uno, cuarenta y cinco, etc.)
                return  this.decenas['es']![decena] +
                    (unidad > 0
                        ? ` ${this.textosConexion['es']!['y']} ` +
                        this.unidades['es']![unidad]
                        : "");
              }
            } else if (num < 1000) {
              const unidad = num % 10;
              const decena =  Math.floor(num / 10) % 10;
              const centena =  Math.floor(num / 100);;
  
              // Corregimos el uso de "CIEN" y "CIENTO"
              let textoCentena: string ;
              if (centena == 1 && decena == 0 && unidad == 0) {
                textoCentena = "CIEN"; // Exactamente 100
              } else if (centena == 1) {
                textoCentena = "CIENTO"; // De 101 a 199
              } else {
                textoCentena = this.centenas['es']![centena]; // Otros casos
              }
  
            let decenaEspecial = numero % 100;
            if (decenaEspecial >= 10 && decenaEspecial <= 19) {
              // Restamos 10 para obtener el índice correcto en la lista
              const textoEspecial = this.especiales['es']![decenaEspecial - 10];
              return textoCentena + " " + textoEspecial;
            }

              // Verificamos si el número está entre 21 y 29
              let textoDecena = this.decenas['es']![decena];
              let textoUnidad = unidad > 0 ? this.unidades['es']![unidad] : "";
  
              // Agregar "y" entre la decena y la unidad cuando es necesario (excepto en los casos 11-19)
              if (decena == 2 && unidad > 0) {
                textoDecena = "VEINTI" + this.unidades['es']![unidad];
                textoUnidad = "";
              } else if (unidad > 0 && decena > 2) {
                textoUnidad =
                    ` ${this.textosConexion['es']!['y']} ` + this.unidades['es']![unidad];
              }
  
              return textoCentena +
                  (decena > 0 ? " " + textoDecena : "") +
                  (unidad > 0 ? " " + textoUnidad : "");
            } else if (numero < 10000) {
              const mil = Math.floor(num / 1000);
              const resto = num % 1000;
              return (mil == 1 ? "MIL" : convertirParteEntera(mil) + " MIL") +
                  (resto > 0 ? " " + convertirParteEntera(resto) : "");
            } else if (numero < 1000000) {
              const miles = Math.floor(num / 1000);
            const resto = num % 1000;
              return convertirParteEntera(miles) +
                  " MIL" +
                  (resto > 0 ? " " + convertirParteEntera(resto) : "");
            } else if (numero < 1000000000) {
              const cantidadMillones = Math.floor(num / 1000000);
            const resto = num % 1000000;
              return (cantidadMillones == 1
                      ? "UN MILLÓN"
                      : convertirParteEntera(cantidadMillones) + " MILLONES") +
                  (resto > 0 ? " " + convertirParteEntera(resto) : "");
            }
            break;   
          case 'en': // Inglés
          if (num < 10) {
            return this.unidades['en']![num];
          } else if (num < 20) {
            return this.especiales['en']![num - 10];
          } else if (num < 100) {
            const unidad = num % 10;
            const decena =  Math.floor(num / 10) ;
            return this.decenas['en']![decena] +
                (unidad > 0
                    ? ` ${this.textosConexion['en']!['y']} ` +
                       this. unidades['en']![unidad]
                    : "");
          } else if (num < 1000) {
            const unidad = num % 10;
            const decena = Math.floor(num / 10)  % 10;
            const centena = Math.floor(num / 100) ;
            return this.centenas['en']![centena] +
                (decena > 0 ? " " + this.decenas['en']![decena] : "") +
                (unidad > 0
                    ? ` ${this.textosConexion['en']!['y']} ` +
                    this.unidades['en']![unidad]
                    : "");
          } else if (num < 10000) {
            const mil = Math.floor(num / 1000);
            const resto = num % 1000;
            return (mil == 1
                    ? "ONE THOUSAND"
                    : convertirParteEntera(mil) + " THOUSAND") +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (num < 1000000) {
            const miles = Math.floor(num / 1000);
            const resto = num % 1000;
            return convertirParteEntera(miles) +
                " THOUSAND" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (num < 1000000000) {
            const cantidadMillones = Math.floor(num / 1000000);
            const resto = num % 1000000;
            return convertirParteEntera(cantidadMillones) +
                " MILLION" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          }
          break;
          case 'fr': // Francés
          if (num < 10) {
            return this.unidades['fr']![num];
          } else if (num < 20) {
            return this.especiales['fr']![num - 10];
          } else if (num < 100) {
            const unidad = num % 10;
            const decena =  Math.floor(num / 10) ;
            return this.decenas['fr']![decena] +
                (unidad > 0
                    ? ` ${this.textosConexion['fr']!['y']} ` +
                        this.unidades['fr']![unidad]
                    : "");
          } else if (num < 1000) {
            const unidad = num % 10;
            const decena =  Math.floor(num / 10) % 10;
            const centena =  Math.floor(num / 100);
            return this.centenas['fr']![centena] +
                (decena > 0 ? " " + this.decenas['fr']![decena] : "") +
                (unidad > 0
                    ? ` ${this.textosConexion['fr']!['y']} ` +
                    this. unidades['fr']![unidad]
                    : "");
          } else if (num < 10000) {
            const mil = Math.floor(num / 1000);
            const resto = num % 1000;
            return (mil == 1 ? "MILLE" : convertirParteEntera(mil) + " MILLE") +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (num < 1000000) {
            const miles = Math.floor(num / 1000);
            const resto = num % 1000;
            return convertirParteEntera(miles) +
                " MILLE" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (num < 1000000000) {
            const cantidadMillones = Math.floor(num / 1000000) ;
            const resto = num % 1000000;
            return convertirParteEntera(cantidadMillones) +
                " MILLIONS" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          }
          break;
          case 'de': // Alemán
          if (num < 10) {
            return this.unidades['de']![num];
          } else if (num < 20) {
            return this.especiales['de']![num - 10];
          } else if (num < 100) {
            const unidad = num % 10;
            const decena =  Math.floor(num / 10) ;
            return this.decenas['de']![decena] +
                (unidad > 0
                    ? ` ${this.textosConexion['de']!['y']} ` +
                    this.unidades['de']![unidad]
                    : "");
          } else if (num < 1000) {
            const unidad = num % 10;
            const decena =  Math.floor(num / 10) % 10;
            const centena =  Math.floor(num / 100);
            return this.centenas['de']![centena] +
                (decena > 0 ? " " + this.decenas['de']![decena] : "") +
                (unidad > 0
                    ? ` ${this.textosConexion['de']!['y']} `  +
                    this.unidades['de']![unidad]
                    : "");
          } else if (num < 10000) {
            const mil =Math.floor(num / 1000);
            const resto = num % 1000;
            return (mil == 1
                    ? "EINTAUSEND"
                    : convertirParteEntera(mil) + " TAUSEND") +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (num < 1000000) {
            const miles = Math.floor(num / 1000);
            const resto = num % 1000;
            return convertirParteEntera(miles) +
                " TAUSEND" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (num < 1000000000) {
            const cantidadMillones =  Math.floor(num / 1000000) ;
            const resto = num % 1000000;
            return convertirParteEntera(cantidadMillones) +
                " MILLIONEN" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          }
          break;
        }
        return "Número fuera de rango";
    }

    const parteEntera = Math.floor(numero);
    const parteDecimal = Math.round((numero - parteEntera) * 100);

    let textoParteEntera = convertirParteEntera(parteEntera);
    const textoParteDecimal: string = parteDecimal > 0
    ? ` ${this.textosConexion[idioma as 'es' | 'en' | 'de' | 'fr']['con']} (${parteDecimal}/100)`
    : "";


    return textoParteEntera + textoParteDecimal;
  }
}
