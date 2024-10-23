import { Component, OnDestroy } from '@angular/core';
import jsPDF from 'jspdf';
import { ApiService } from '../services/api.service';
import { Subject } from 'rxjs';
import { UtilidadService } from '../services/utilidad.service';
import { TraduccionService } from '../services/traduccion.service';

@Component({
  selector: 'app-imprimir-documento',
  templateUrl: './imprimirDocumento.component.html',
  styleUrls: ['./imprimirDocumento.component.css']
})
export class ImprimirDocumentoComponent implements OnDestroy {

  datosParaImpresion: any;
  private unsubscribe$: Subject<void> = new Subject<void>();

  // Constantes para colores
  private readonly COLOR_PRINCIPAL = [209, 59, 59] as const;
  private readonly COLOR_SECUNDARIO = [20, 79, 171] as const;

  // Constantes para fuentes y estilos
  private readonly FUENTE_PRINCIPAL = 'Helvetica';
  private readonly ESTILO_NEGRITA = 'bold';
  private readonly ESTILO_NORMAL = 'normal';

  // Constantes para dimensiones y márgenes
  private readonly MARGEN_IZQUIERDO = 10;
  private readonly MARGEN_DERECHO = 10;
  private readonly INTERLINEADO_TEXTO = 5;
  private readonly ANCHO_LINEA = 0.2;
  private readonly TAMAÑO_FUENTE_NORMAL = 10;
  private readonly TAMAÑO_FUENTE_ENCABEZADO = 16;
  private readonly TAMAÑO_FUENTE_SUBTITULO = 12;

  constructor(private apiService: ApiService, private utilidadService: UtilidadService,private traduccionService: TraduccionService, private idiomaService: TraduccionService,  private numeroALetrasService: UtilidadService,) { }

  ngOnDestroy(): void {
    this.unsubscribe$.next();
    this.unsubscribe$.complete();
  }

  private pdfGenerating = false;

  generarPDF(): void {
    if (this.pdfGenerating) return; // Evitar ejecución múltiple
    this.pdfGenerating = true;
  
    this.apiService.getDatosRecibo().subscribe(
      (datos) => {
        if (!datos) {
          console.error('Error: Datos de impresión no encontrados');
          this.pdfGenerating = false;
          return;
        }
  
        this.datosParaImpresion = datos;
        console.log('Datos recibidos en (Componente de impresión): ', this.datosParaImpresion);
  
        const {
          descripcionTipoDoc,
          descripcionSerie,
          clienteSeleccionadoDatoImpresion,
          encabezado,
          documentosSeleccionados,
          montosSeleccionados,
          registrosCargosAbonos,
          registrosCargosAbonosAfectar,
          afectar
        } = this.datosParaImpresion;
  
        const descripcionTipoDocumento = descripcionTipoDoc?.descripcion;
        const descripcionSerieDocumento = descripcionSerie?.descripcion;
        const fechaDocumento = this.utilidadService.formatearFecha(encabezado?.[0]?.fecha_Documento);
        const nit = clienteSeleccionadoDatoImpresion?.factura_Nit;
        const documentoNo = encabezado?.[0]?.documento;
        const recibiDe = clienteSeleccionadoDatoImpresion?.factura_Nombre;
        const cta = clienteSeleccionadoDatoImpresion?.cuenta_Cta;
        const observaciones = encabezado?.[0]?.observacion_1;
  
        const date = new Date().toISOString().split('T')[0].replace(/-/g, '/');
  
        if (!descripcionTipoDocumento || !descripcionSerieDocumento || !nit || !documentoNo) {
          console.error('Error: Datos de impresión incompletos');
          this.pdfGenerating = false;
          return;
        }
  
        const pdf = new jsPDF({
          orientation: 'portrait',
          unit: 'mm',
          format: 'a4',
          putOnlyUsedFonts: true,
          floatPrecision: 16
        });
  
        // Tamaño y posición de los logos
        const logoWidthDmosoft = 25; // Logo Dmosoft más pequeño
        const logoWidthUsuario = 20; // Logo del usuario
        const logoMargin = 5; // Margen entre logos
  
        const logoPositionDmosoftX = pdf.internal.pageSize.width - this.MARGEN_DERECHO - logoWidthDmosoft - logoMargin; // Mantener Dmosoft en la derecha
        const logoPositionUsuarioX = this.MARGEN_IZQUIERDO; // Logo del usuario a la izquierda
  
        // Contador de imágenes cargadas
        const totalImages = 2;
        let imagesLoaded = 0;
  
        const checkImagesLoaded = () => {
          if (imagesLoaded === totalImages) {
            renderPDF();
          }
        };
  
        // Cargar logo de Dmosoft
        const logoDmosoft = new Image();
        logoDmosoft.src = 'assets/logoDmosoft.png';
        logoDmosoft.onload = () => {
          imagesLoaded++;
          checkImagesLoaded();
        };
        logoDmosoft.onerror = (error) => {
          console.error('Error al cargar el logo de Dmosoft:', error);
          if (userLogoSrc) {
            imagesLoaded++;
            checkImagesLoaded();
          } else {
            renderPDF();
          }
        };
  
        // Cargar logo del usuario
        const userLogoSrc = this.utilidadService.getLogo();
        const logoUsuario = new Image();
        if (userLogoSrc) {
          logoUsuario.src = userLogoSrc;
          logoUsuario.onload = () => {
            imagesLoaded++;
            checkImagesLoaded();
          };
          logoUsuario.onerror = (error) => {
            console.error('Error al cargar el logo del usuario:', error);
            imagesLoaded++;
            checkImagesLoaded();
          };
        } else {
          imagesLoaded++;
          checkImagesLoaded();
        }
  
        const renderPDF = () => {
          const logoHeightDmosoft = (logoDmosoft.height * logoWidthDmosoft) / logoDmosoft.width;
  
          // Agregar logo del usuario en la izquierda
          if (userLogoSrc) {
            const logoHeightUsuario = (logoUsuario.height * logoWidthUsuario) / logoUsuario.width;
            pdf.addImage(logoUsuario, 'PNG', logoPositionUsuarioX, 5, logoWidthUsuario, logoHeightUsuario);
          }
  
          // Agregar logo de Dmosoft en la derecha
          pdf.addImage(logoDmosoft, 'PNG', logoPositionDmosoftX, 5, logoWidthDmosoft, logoHeightDmosoft);
  
          let yPosition = 30; // Ajusta esta posición según lo necesites (antes estaba en 10)

          // Texto del encabezado
          pdf.setFontSize(this.TAMAÑO_FUENTE_ENCABEZADO);
          pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NEGRITA);
          pdf.setTextColor(...this.COLOR_PRINCIPAL);
          pdf.text(descripcionTipoDocumento, pdf.internal.pageSize.width / 2, yPosition, { align: 'center' });
          yPosition += 7;
          
          // Subtítulo
          pdf.setFontSize(this.TAMAÑO_FUENTE_SUBTITULO);
          pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NEGRITA);
          pdf.text(`${this.traduccionService.traducirDatosImpresion('labelsImpresion.series')}: ${descripcionSerieDocumento}`, pdf.internal.pageSize.width / 2, yPosition, { align: 'center' });
          yPosition += 7;
          
          // Información general
          const xOffset = 40;
          pdf.setFontSize(this.TAMAÑO_FUENTE_NORMAL);
          pdf.setTextColor(0, 0, 0);
          this.imprimirTextoMixto(pdf, this.traduccionService.traducirDatosImpresion('labelsImpresion.fecha') + ':', fechaDocumento, this.MARGEN_IZQUIERDO, yPosition, xOffset);
          yPosition += 5;
          this.imprimirTextoMixto(pdf, this.traduccionService.traducirDatosImpresion('labelsImpresion.nit') + ':', nit, this.MARGEN_IZQUIERDO, yPosition, xOffset);
          yPosition += 5;
          this.imprimirTextoMixto(pdf, this.traduccionService.traducirDatosImpresion('labelsImpresion.documentoNo') + ':', documentoNo, this.MARGEN_IZQUIERDO, yPosition, xOffset);
          yPosition += 5;
          this.imprimirTextoMixto(pdf, this.traduccionService.traducirDatosImpresion('labelsImpresion.recibiDe') + ':', recibiDe, this.MARGEN_IZQUIERDO, yPosition, xOffset);
          yPosition += 5;
          this.imprimirTextoMixto(pdf, this.traduccionService.traducirDatosImpresion('labelsImpresion.cta') + ':', cta, this.MARGEN_IZQUIERDO, yPosition, xOffset);
          yPosition += 5;
  
          // Imprimir datos de tipo de pago
          yPosition = this.imprimirCargoAbono(pdf, yPosition + 4, registrosCargosAbonos, registrosCargosAbonosAfectar, afectar);
  
          if (afectar) {
            yPosition = this.imprimirDocumentosAplicados(
              pdf,
              yPosition + 10,
              documentosSeleccionados.map((doc: any, index: number) => ({
                tipoDocumento: doc.Des_Tipo_Documento,
                serieDocumento: doc.Des_Serie_Documento,
                fechaDocumento: this.utilidadService.formatearFecha(doc.Fecha_Documento),
                idDocumento: doc.Id_Documento,
                montoAplicado: montosSeleccionados[index]?.montoAplicado ?? doc.montoAplicado,
                saldo: doc.aplicar
              })),
              montosSeleccionados
            );
          }

          // Agregar observaciones y total en letras
          this.agregarObservacionesYTotal(pdf, yPosition + 10, observaciones, this.MARGEN_IZQUIERDO, this.MARGEN_DERECHO,registrosCargosAbonos, registrosCargosAbonosAfectar, afectar);
  
          pdf.save(`${descripcionTipoDocumento}_${descripcionSerieDocumento}_${date}.pdf`);
  
          // Liberar el bloqueo después de generar el PDF
          this.pdfGenerating = false;
        };
      },
      (error) => {
        console.error('Error al obtener los datos para imprimir:', error);
        this.pdfGenerating = false;
      }
    );
  }
  
  imprimirTextoMixto(
    pdf: jsPDF,
    textBold: string,
    textNormal: string,
    x: number,
    y: number,
    xOffset: number // Ajuste horizontal global para alinear textos normales
  ) {
    // Medir el ancho del texto en negrita
    const boldWidth = pdf.getStringUnitWidth(textBold) * pdf.internal.scaleFactor;
  
    // Configurar el texto en negrita
    pdf.setFontSize(this.TAMAÑO_FUENTE_NORMAL);
    pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NEGRITA);
    pdf.text(textBold.toString(), x, y); // Imprimir texto en negrita
  
    // Configurar el texto normal
    pdf.setFontSize(this.TAMAÑO_FUENTE_NORMAL);
    pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NORMAL);
  
    // Imprimir texto normal alineado con el xOffset global
    pdf.text(textNormal.toString(), xOffset, y); // Ajuste horizontal usando xOffset
  }
  
  imprimirLinea(pdf: jsPDF, y: number): void {
    pdf.setLineWidth(this.ANCHO_LINEA);
    pdf.setDrawColor(...this.COLOR_SECUNDARIO);
    pdf.line(this.MARGEN_IZQUIERDO, y, pdf.internal.pageSize.width - this.MARGEN_DERECHO, y);
  }

  imprimirCargoAbono(
    pdf: jsPDF, 
    yPosition: number, 
    registrosCargosAbonos: any[], 
    registrosCargosAbonosAfectar: any[], 
    afectar: boolean
  ): number {
      if (!Array.isArray(registrosCargosAbonos)) {
          console.error('Error: registrosCargosAbonos no es un array válido');
          return yPosition;
      }
  
      const marginLeft = this.MARGEN_IZQUIERDO;
      const lineHeight = 6;
  
      // Ajuste la posición de la columna del monto más a la derecha
      const montoColumnPosition = marginLeft + 180; 
  
      pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NEGRITA);
      pdf.setFontSize(this.TAMAÑO_FUENTE_NORMAL);
      pdf.setTextColor(...this.COLOR_SECUNDARIO);
  
      // Etiquetas
      pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.tipoPago'), marginLeft, yPosition);
      pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.banco'), marginLeft + 60, yPosition);
      pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.cuentaBancaria'), marginLeft + 110, yPosition);
      pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.monto'), montoColumnPosition, yPosition, { align: 'right' });
  
      yPosition += 4;
      this.imprimirLinea(pdf, yPosition);
  
      const tipoPagoMap: { [key: string]: { tipoPago: string, banco: string, cuentaBancaria: string, monto: number } } = {};
  
      const registros = afectar ? registrosCargosAbonosAfectar : registrosCargosAbonos;
  
      registros.forEach((registro) => {
          const tipoPago = registro.tipo_Cargo_Abono.toString();
          const monto = registro.monto ? registro.monto : 0;
          const banco = registro.banco ? registro.banco : 'N/A';
          const cuentaBancaria = registro.cuenta_bancaria ? registro.cuenta_bancaria : 'N/A';
  
          if (tipoPagoMap[tipoPago]) {
              tipoPagoMap[tipoPago].monto += monto;
          } else {
              tipoPagoMap[tipoPago] = { tipoPago, banco, cuentaBancaria, monto };
          }
      });
  
      // Contenido
      pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NORMAL);
      pdf.setTextColor(0, 0, 0);
  
      Object.values(tipoPagoMap).forEach(({ tipoPago, banco, cuentaBancaria, monto }) => {
          yPosition += lineHeight;
  
          const montoTexto = this.utilidadService.formatearNumeros(monto);
          const montoWidth = pdf.getTextWidth(montoTexto);
  
          pdf.text(tipoPago.toString(), marginLeft, yPosition);
          pdf.text(banco.toString(), marginLeft + 60, yPosition);
          pdf.text(cuentaBancaria.toString(), marginLeft + 110, yPosition);
          pdf.text(montoTexto, montoColumnPosition - montoWidth, yPosition);
      });
  
      const totalMonto = Object.values(tipoPagoMap).reduce((sum, { monto }) => sum + monto, 0);
  
      yPosition += lineHeight;
      this.imprimirLinea(pdf, yPosition);
  
      // Total
      pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NEGRITA);
      pdf.setFontSize(this.TAMAÑO_FUENTE_NORMAL);
      pdf.setTextColor(0, 0, 0);
      pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.total'), marginLeft + 110, yPosition + 5);
      
      const totalMontoTexto = this.utilidadService.formatearNumeros(totalMonto);
      const totalMontoWidth = pdf.getTextWidth(totalMontoTexto);
      pdf.text(totalMontoTexto, montoColumnPosition - totalMontoWidth, yPosition + 5);
  
      return yPosition;
  }

  imprimirDocumentosAplicados(
    pdf: jsPDF, 
    yPosition: number, 
    documentosSelAcumulados: any[], 
    montosSeleccionados: any[]
  ): number {
    // Subtítulo "Documentos Aplicados"
    pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NEGRITA);
    pdf.setFontSize(this.TAMAÑO_FUENTE_SUBTITULO);
    pdf.setTextColor(...this.COLOR_PRINCIPAL);
    pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.documentosAplicados'), this.MARGEN_IZQUIERDO, yPosition);
  
    // Línea debajo del subtítulo
    yPosition += 3;
    this.imprimirLinea(pdf, yPosition);
  
    // Campos de encabezado
    pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NEGRITA);
    pdf.setFontSize(this.TAMAÑO_FUENTE_NORMAL);
    pdf.setTextColor(...this.COLOR_SECUNDARIO);
  
    const marginLeft = this.MARGEN_IZQUIERDO;
    const lineHeight = 6; // Espacio entre cada línea de texto
  
    // Ajuste de espacio entre columnas
    pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.tipoDocumento'), marginLeft, yPosition + 3);
    pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.serieDocumento'), marginLeft + 35, yPosition + 3); // Separación ajustada
    pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.fechaDocumento'), marginLeft + 70, yPosition + 3); // Separación ajustada
    pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.idDocumento'), marginLeft + 110, yPosition + 3); // Separación ajustada
  
    // Alinear a la derecha para 'Aplicado' y 'Saldo'
    const aplicadoText = this.traduccionService.traducirDatosImpresion('labelsImpresion.aplicado');
    const saldoText = this.traduccionService.traducirDatosImpresion('labelsImpresion.saldo');
    
    pdf.text(aplicadoText, marginLeft + 160 - pdf.getTextWidth(aplicadoText), yPosition + 3);
    pdf.text(saldoText, marginLeft + 180 - pdf.getTextWidth(saldoText), yPosition + 3); // Columna del saldo más a la izquierda
  
    // Línea debajo de los encabezados
    yPosition += 4;
    this.imprimirLinea(pdf, yPosition);
  
    // Acumular documentos por idDocumento
    const documentoMap: { [key: string]: any } = {};
    const montosGuardadosAcumulados: number[] = [];
  
    // Iterar sobre documentosSeleccionados para acumular por idDocumento
    for (let i = 0; i < documentosSelAcumulados.length; i++) {
      const documento = documentosSelAcumulados[i];
      const idDocumento = documento.idDocumento;
      if (documentoMap[idDocumento]) {
        // Si ya existe un documento con el mismo idDocumento, sumar los montos guardados
        montosGuardadosAcumulados[documentoMap[idDocumento].index] += montosSeleccionados[i]?.montoAplicado ?? documento.montoAplicado;
      } else {
        // Si no existe un documento con el mismo idDocumento, agregarlo al mapa
        documentoMap[idDocumento] = { documento, index: montosGuardadosAcumulados.length };
        montosGuardadosAcumulados.push(montosSeleccionados[i]?.montoAplicado ?? documento.montoAplicado);
      }
    }
  
    // Convertir el mapa a una lista de documentos acumulados
    const documentosSeleccionadosAcumulados = Object.values(documentoMap).map(item => item.documento);
  
    // Datos de documentos aplicados
    pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NORMAL);
    pdf.setTextColor(0, 0, 0);
  
    let totalMontoAplicado = 0.0;
    let totalMontoSaldos = 0.0;
  
    if (documentosSeleccionadosAcumulados.length > 0) {
      documentosSeleccionadosAcumulados.forEach((doc, index) => {
        yPosition += lineHeight;
  
        pdf.text(doc.tipoDocumento, marginLeft, yPosition);
        pdf.text(doc.serieDocumento, marginLeft + 35, yPosition);
        pdf.text(doc.fechaDocumento, marginLeft + 70, yPosition);
        pdf.text(doc.idDocumento.toString(), marginLeft + 110, yPosition);
  
        // Obtener los montos acumulados
        const montoAplicado = montosGuardadosAcumulados[index];
        const saldo = doc.saldo;
  
        // Asegurar que montoAplicado y saldo sean cadenas de texto formateadas
        const montoAplicadoTexto = this.utilidadService.formatearNumeros(montoAplicado);
        const saldoTexto = this.utilidadService.formatearNumeros(saldo);
  
        pdf.text(montoAplicadoTexto, marginLeft + 160 - pdf.getTextWidth(montoAplicadoTexto), yPosition);
        pdf.text(saldoTexto, marginLeft + 180 - pdf.getTextWidth(saldoTexto), yPosition);
  
        totalMontoAplicado += montoAplicado;
        totalMontoSaldos += saldo;
      });
    } else {
    }

    yPosition += lineHeight;
    this.imprimirLinea(pdf, yPosition);
  
    // Total debajo de la línea de documentos aplicados
    pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NEGRITA);
    pdf.setFontSize(this.TAMAÑO_FUENTE_NORMAL);
    pdf.setTextColor(0, 0, 0);
    pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.total'), marginLeft + 110, yPosition + 5);
    pdf.text(this.utilidadService.formatearNumeros(totalMontoAplicado), marginLeft + 160 - pdf.getTextWidth(this.utilidadService.formatearNumeros(totalMontoAplicado)), yPosition + 5); 
    pdf.text(this.utilidadService.formatearNumeros(totalMontoSaldos), marginLeft + 180 - pdf.getTextWidth(this.utilidadService.formatearNumeros(totalMontoSaldos)), yPosition + 5); 
  
    yPosition += lineHeight;
    return yPosition;
  }
  
  agregarObservacionesYTotal(pdf: jsPDF, yPosition: number, observaciones: string, marginLeft: number, marginRight: number,  registrosCargosAbonos: any[], 
    registrosCargosAbonosAfectar: any[], 
    afectar: boolean) {
    // Observaciones
    const textoObservaciones = this.traduccionService.traducirDatosImpresion('labelsImpresion.observacion') + `: ${observaciones}`;
    const observacionesLines = pdf.splitTextToSize(textoObservaciones, pdf.internal.pageSize.width - marginLeft - marginRight);
    const idiomaActual = this.idiomaService.getIdiomaActual();

    const tipoPagoMap: { [key: string]: { tipoPago: string, banco: string, cuentaBancaria: string, monto: number } } = {};
    const registros = afectar ? registrosCargosAbonosAfectar : registrosCargosAbonos;
  
    registros.forEach((registro) => {
        const tipoPago = registro.tipo_Cargo_Abono.toString();
        const monto = registro.monto ? registro.monto : 0;
        const banco = registro.banco ? registro.banco : 'N/A';
        const cuentaBancaria = registro.cuenta_bancaria ? registro.cuenta_bancaria : 'N/A';

        if (tipoPagoMap[tipoPago]) {
            tipoPagoMap[tipoPago].monto += monto;
        } else {
            tipoPagoMap[tipoPago] = { tipoPago, banco, cuentaBancaria, monto };
        }
    });


    const totalMonto = Object.values(tipoPagoMap).reduce((sum, { monto }) => sum + monto, 0);

    pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NORMAL);
    pdf.setFontSize(this.TAMAÑO_FUENTE_NORMAL);
    pdf.setTextColor(0, 0, 0);

    yPosition += 5;
    observacionesLines.forEach((line: string) => {
        pdf.text(line, marginLeft, yPosition);
        yPosition += this.INTERLINEADO_TEXTO;
    });

    // Total en letras
    pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NEGRITA);
    pdf.setFontSize(this.TAMAÑO_FUENTE_NORMAL);
    pdf.setTextColor(0, 0, 0);
    const totalLetras = this.numeroALetrasService.numeroALetras(totalMonto,idiomaActual);
    console.log('Total:', totalMonto);
    console.log('Total en letras:', totalLetras);
    pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.totalLetras') +  `:  ${totalLetras} `, marginLeft, yPosition + 5); 
    yPosition += 4;

    // Línea debajo de Total en letras
    yPosition += 6;
    this.imprimirLinea(pdf, yPosition);

    // Segunda línea doble
    yPosition += 3; 
    this.imprimirLinea(pdf, yPosition); 

    yPosition += 6; 

    // Línea de recibido
    const totalLineY = yPosition + 10;
    const totalLineXEnd = pdf.internal.pageSize.width - marginRight;
    const totalLineXStart = totalLineXEnd - 50;

    pdf.setLineWidth(0.1);
    pdf.line(totalLineXStart, totalLineY, totalLineXEnd, totalLineY);

    pdf.setFont(this.FUENTE_PRINCIPAL, this.ESTILO_NEGRITA);
    pdf.setFontSize(this.TAMAÑO_FUENTE_NORMAL);
    pdf.setTextColor(0, 0, 0);
    const textoRecibidoWidth = pdf.getStringUnitWidth('Recibido') * pdf.internal.scaleFactor;
    const textoRecibidoX = totalLineXEnd - textoRecibidoWidth - 7;
    pdf.text(this.traduccionService.traducirDatosImpresion('labelsImpresion.recibido'), textoRecibidoX, totalLineY + 5);
  }
}
