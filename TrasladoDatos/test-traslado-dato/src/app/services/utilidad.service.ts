import { Injectable } from '@angular/core';
import { BehaviorSubject, Subject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class UtilidadService {

  private esModoOscuro = false;
  private loading = true;
  private catalogoSeleccionadoSource = new BehaviorSubject<string | null>(null);
  catalogoSeleccionado$              = this.catalogoSeleccionadoSource.asObservable();
  private sidebarOpenSubject         = new Subject<boolean>();
  sidebarOpen$                       = this.sidebarOpenSubject.asObservable();
  private updateListSubject          = new Subject<void>();
  updateList$                        = this.updateListSubject.asObservable();
  
  constructor() {
    if (typeof window !== 'undefined') {
      this.esModoOscuro = localStorage.getItem('theme') === 'dark';
      this.aplicarTema(); //Aplica el tema inicial al cargar el servicio
    }
  }
  //*Seccion de metodos utilizados para controlar el modo de la interfaz
  alternarTema(): void {
    this.esModoOscuro = !this.esModoOscuro;

    //Solo guardar en localStorage en el contexto del navegador
    if (typeof window !== 'undefined') {
      localStorage.setItem('theme', this.esModoOscuro ? 'dark' : 'light');
    }
    this.aplicarTema();
  }

  esModoOscuroHabilitado(): boolean {
    return this.esModoOscuro; // Retorna el estado actual
  }

  //Inicializa el tema
  inicializacionTema(): void {
    if (typeof window !== 'undefined') { 
      this.esModoOscuro = localStorage.getItem('theme') === 'dark'; //Inicializa el modo oscuro basado en localStorage
      this.aplicarTema(); //Aplica el tema al cargar el servicio
    }
  }

  private aplicarTema(): void {
    const body = document.body; //Obtiene el elemento body del documento
    if (this.esModoOscuro) {
      body.classList.add('dark');
      body.classList.remove('light');
    } else {
      body.classList.remove('dark');
      body.classList.add('light');
    }
  }

}