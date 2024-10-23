import 'dart:io';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:number2words/number2words.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:test_cuenta_corriente/Models/PaBscBanco1M.dart';
import 'package:test_cuenta_corriente/Models/PaBscCuentaBancaria1M.dart';
import 'package:test_cuenta_corriente/Models/PaBscCuentaCorriente1M.dart';
import 'package:test_cuenta_corriente/Models/PaBscSerieDocumento1M.dart';
import 'package:test_cuenta_corriente/Models/PaBscTipoCargoAbono1M.dart';
import 'package:test_cuenta_corriente/Models/PaBscTipoDocumentoMovilM.dart';
import 'package:test_cuenta_corriente/Models/PaTblCargoAbonoM.dart';
import 'package:test_cuenta_corriente/Models/PaTblDocumentoM.dart';
import 'package:test_cuenta_corriente/VistaPreviaPdf.dart';
import 'package:test_cuenta_corriente/common/Utilidades.dart';
import 'package:test_cuenta_corriente/generated/l10n.dart';

class ImprimirDocumento {
  final List<PaTblDocumentoM> documento;
  final PaBscTipoDocumentoMovilM? selectedTipoDocumento;
  final PaBscSerieDocumento1M? selectedSerieDocumento;
  final PaBscTipoCargoAbono1M? selectedTipoCargoAbono;
  final PaBscBanco1M? selectedBanco;
  final PaBscCuentaBancaria1M? selectedCuentaBancaria;
  final String selectedCuentaCta;
  final int selectedCuentaCorrentista;
  final String pUserName;
  final int pEmpresa;
  final int pEstacion_Trabajo;
  final String facturaNombre;
  final String facturaNit;
  final String facturaDireccion;
  final List<double> montosGuardados;
  final List<PaBscCuentaCorriente1M> documentosSeleccionados;
  List<PaTblCargoAbonoM> registrosCargoAbono;
  List<PaTblCargoAbonoM> registrosCargoAbonoAfectar;
  final bool afectar;
  final BuildContext context;
  final String ccDireccion;
  final String telefono;
  final Function(Locale) changeLanguage;
  final Locale seleccionarIdioma;
  final Locale idiomaDropDown;
  final String baseUrl;
  final String token;
  final bool temaClaro;
  final String imagePath;
  final String? imageLogo;
  final bool isBackgroundSet;
  final DateTime fechaSesion;
  final bool tokenSesionGuardada;
  final DateTime? fechaExpiracion;
  ImprimirDocumento(
      {required this.selectedCuentaCta,
      required this.selectedCuentaCorrentista,
      required this.pUserName,
      required this.pEmpresa,
      required this.pEstacion_Trabajo,
      required this.facturaNombre,
      required this.facturaNit,
      required this.facturaDireccion,
      required this.selectedTipoDocumento,
      required this.selectedSerieDocumento,
      required this.selectedTipoCargoAbono,
      required this.selectedBanco,
      required this.selectedCuentaBancaria,
      required this.documento,
      required this.montosGuardados,
      required this.documentosSeleccionados,
      required this.registrosCargoAbono,
      required this.registrosCargoAbonoAfectar,
      required this.afectar,
      required this.context,
      required this.ccDireccion,
      required this.telefono,
      required this.changeLanguage,
      required this.seleccionarIdioma,
      required this.idiomaDropDown,
      required this.baseUrl,
      required this.token,
      required this.temaClaro,
      required this.imagePath,
      required this.isBackgroundSet,
      required this.fechaSesion,
      required this.tokenSesionGuardada,
      this.imageLogo,
      this.fechaExpiracion});

  Uint8List? _logoImage;
  Uint8List? _logoImageEmpresa;
  final List<PaTblCargoAbonoM> registrosCargoAbonoAcumular = [];
  final List<PaTblCargoAbonoM> registrosCargoAbonoAfectarAcumular = [];
  List<PaTblCargoAbonoM> registros = [];
  List<PaTblCargoAbonoM> registrosExistentes = [];
  final List<PaBscCuentaCorriente1M> documentosSeleccionadosAcumulados = [];
  final List<double> montosGuardadosAcumulados = [];
  List<PaTblCargoAbonoM> registrosCargoAbonoAfectarCopia = [];
  final Map<String, PaBscCuentaCorriente1M> documentoMap = {};
  final NumberFormat formatter = NumberFormat('#,##0.00');
  late Locale _idiomaActual;

  void initialize() {
    registrosCargoAbonoAfectarCopia = List.from(registrosCargoAbonoAfectar);
    _idiomaActual = idiomaDropDown;
    generarYGuardarRecibo();
  }

  //generar Pdf
  Future<void> generarYGuardarRecibo() async {
    _logoImage = await _loadLogoImage('assets/logo.png');

    // Cargar la segunda imagen (desde almacenamiento local si existe)
    if (imageLogo != null && File(imageLogo!).existsSync()) {
      _logoImageEmpresa = await _loadLogoImage(imageLogo!);
    } else {
      print('El archivo no existe o está vacío: $imageLogo');
    }

    final pdf = pw.Document();
    //Reiniciar las listas de acumulación
    registrosCargoAbonoAcumular.clear();
    registrosCargoAbonoAfectarAcumular.clear();
    // Iterar sobre registrosCargoAbono
    if (afectar == false) {
      for (var cargoAbono in registrosCargoAbono) {
        // Verificar si ya existe un documento con el mismo Tipo_Cargo_Abono en registrosCargoAbonoAcumular
        var existingDocumento = registrosCargoAbonoAcumular.firstWhereOrNull(
          (doc) => doc.Tipo_Cargo_Abono == cargoAbono.Tipo_Cargo_Abono,
        );

        if (existingDocumento != null) {
          // Si ya existe un documento con el mismo Tipo_Cargo_Abono, sumar los montos
          existingDocumento.Monto += cargoAbono.Monto;
        } else {
          // Si no existe un documento con el mismo Tipo_Cargo_Abono, se agrega a registrosCargoAbonoAcumular
          registrosCargoAbonoAcumular.add(cargoAbono);
        }
      }
    }

    // Iterar sobre registrosCargoAbonoAfectar
    if (afectar) {
      for (var cargoAbono in registrosCargoAbonoAfectarCopia) {
        // Verificar si ya existe un documento con el mismo Tipo_Cargo_Abono en registrosCargoAbonoAcumular
        PaTblCargoAbonoM? existingDocumento =
            registrosCargoAbonoAfectarAcumular.firstWhereOrNull(
          (doc) => doc.Tipo_Cargo_Abono == cargoAbono.Tipo_Cargo_Abono,
        );

        if (existingDocumento != null) {
          // Si ya existe un documento con el mismo Tipo_Cargo_Abono, sumar los montos
          existingDocumento.Monto += cargoAbono.Monto;
        } else {
          // Si no existe un documento con el mismo Tipo_Cargo_Abono, se agrega a registrosCargoAbonoAcumular
          registrosCargoAbonoAfectarAcumular.add(cargoAbono);
        }
      }
    }

    if (afectar) {
      registros = registrosCargoAbonoAfectarAcumular;
    } else {
      registros = registrosCargoAbonoAcumular;
    }

    // Iterar sobre documentosSeleccionados para acumular por idDocumento
    for (int i = 0; i < documentosSeleccionados.length; i++) {
      final documento = documentosSeleccionados[i];
      final idDocumento = documento.idDocumento;

      if (documentoMap.containsKey(idDocumento)) {
        // Si ya existe un documento con el mismo idDocumento, sumar los montos guardados
        final index = documentoMap.keys.toList().indexOf(idDocumento);
        montosGuardadosAcumulados[index] += montosGuardados[i];
      } else {
        // Si no existe un documento con el mismo idDocumento, agregarlo al mapa
        documentoMap[idDocumento] = documento;
        // Agregar el monto correspondiente en montosGuardados
        montosGuardadosAcumulados.add(montosGuardados[i]);
      }
    }

    // Convertir el mapa a una lista de documentos acumulados
    List<PaBscCuentaCorriente1M> documentosSeleccionadosAcumulados =
        documentoMap.values.toList();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 10),
              _buildDocumento(),
              pw.SizedBox(height: 5),
              _buildCargoAbono(registros),
              pw.SizedBox(height: 5),
              if (afectar)
                _buildDocumentosAplicados(documentosSeleccionadosAcumulados,
                    montosGuardadosAcumulados),
              pw.SizedBox(height: 5),
              _buildOtros(registros),
            ],
          );
        },
        margin: pw.EdgeInsets.all(20),
      ),
    );

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd').format(now);

    final fileName =
        '${selectedTipoDocumento?.descripcion}_${selectedSerieDocumento?.descripcion}_$formattedDate.pdf';

    final pdfData = await pdf.save();

    // Navegar a la pantalla de vista previa del PDF
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewScreen(
          pdfData: pdfData,
          nombrePdf: fileName,
          afectar: afectar,
          seleccionadoCuentaCorrentista: selectedCuentaCorrentista,
          seleccionadoCuentaCta: selectedCuentaCta,
          facturaNombre: facturaNombre,
          facturaNit: facturaNit,
          facturaDireccion: facturaDireccion,
          ccDireccion: ccDireccion,
          telefono: telefono,
          pUserName: pUserName,
          pEmpresa: pEmpresa,
          pEstacion_Trabajo: pEstacion_Trabajo,
          changeLanguage: changeLanguage,
          seleccionarIdioma: seleccionarIdioma,
          idiomaDropDown: _idiomaActual,
          baseUrl: baseUrl,
          token: token,
          temaClaro: temaClaro,
          imagePath: imagePath,
          isBackgroundSet: isBackgroundSet,
          fechaSesion: fechaSesion,
          tokenSesionGuardada: tokenSesionGuardada,
          imageLogo: imageLogo,
          fechaExpiracion: fechaExpiracion,
        ),
      ),
    );
  }

  //Información de encabezado documento:
  pw.Widget _buildDocumento() {
    return pw.Stack(
      alignment: pw.Alignment.topCenter,
      children: [
        // Textos principales centrados:
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.SizedBox(height: 40),
            pw.Text(
              '${DocumentoTraduccion.traducirTipoDocumento(selectedTipoDocumento?.descripcion ?? '', context)}',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.red,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.Text(
              '${S.of(context).serie}: ${selectedSerieDocumento?.descripcion}',
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.red,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 10),
            // Información del cliente:
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${S.of(context).documentoNo}.',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '${S.of(context).nit}:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '${S.of(context).fecha}:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '${S.of(context).recibiDe}:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '${S.of(context).ctaCliente}:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(width: 10),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${documento[0].Documento}',
                      style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
                    ),
                    pw.Text(
                      '${facturaNit}',
                      style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
                    ),
                    pw.Text(
                      DateFormat('dd/MM/yyyy').format(
                          DateTime.parse(documento[0].Fecha_Hora.toString())),
                      style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
                    ),
                    pw.Container(
                      width: 200,
                      child: pw.Text(
                        '${facturaNombre}',
                        style:
                            pw.TextStyle(fontSize: 10, color: PdfColors.black),
                        maxLines: null,
                        overflow: pw.TextOverflow.clip,
                      ),
                    ),
                    pw.Text(
                      '${selectedCuentaCta}',
                      style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        pw.Positioned(
          top: 0,
          right: 0,
          child: pw.Row(
            children: [
              if (_logoImage != null)
                pw.Container(
                  width: 80,
                  height: 80,
                  child: pw.Image(
                    pw.MemoryImage(_logoImage!),
                  ),
                ),
            ],
          ),
        ),
        pw.Positioned(
          top: 0,
          left: 0,
          child: pw.Row(
            children: [
              if (_logoImageEmpresa != null)
                pw.Container(
                  width: 60,
                  height: 60,
                  child: pw.Image(
                    pw.MemoryImage(_logoImageEmpresa!),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  //Información de tipo Pago:
  pw.Widget _buildCargoAbono(List<PaTblCargoAbonoM> registros) {
    final totalMonto = registros.fold<num>(0, (sum, item) => sum + item.Monto);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        //Información de tipo Pago:
        pw.Divider(
          thickness: 1,
          color: PdfColors.blue700,
          height: 5,
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              '${S.of(context).tipodePago}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.blue700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${S.of(context).banco}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.blue700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${S.of(context).cuentaBancaria}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.blue700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${S.of(context).monto}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.blue700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.Divider(
          thickness: 1,
          color: PdfColors.blue700,
          height: 5,
        ),
        // Lista de documentos seleccionados
        for (var item in registros)
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                children: [
                  pw.Container(
                      child: pw.Text(
                        '${item.Tipo_Cargo_Abono}',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.black,
                        ),
                      ),
                      width: 160),
                ],
              ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                        child: pw.Text(
                          item.Banco == null ? 'N/A' : '${item.Banco}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.black,
                          ),
                        ),
                        width: 115)
                  ]),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                        child: pw.Text(
                          item.Cuenta_Bancaria == null
                              ? 'N/A'
                              : '${item.Cuenta_Bancaria}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.black,
                          ),
                        ),
                        width: 100),
                  ]),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                        child: pw.Text(
                          '${formatter.format(item.Monto)}' ?? 'N/A',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.black,
                          ),
                          textAlign: pw.TextAlign.end,
                        ),
                        width: 95),
                  ]),
            ],
          ),
        pw.Divider(
          thickness: 1,
          color: PdfColors.blue700,
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Container(
              child: pw.Text(
                '${S.of(context).total}',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              width: 50,
            ),
            pw.SizedBox(width: 172),
            pw.Container(
              child: pw.Text(
                '${formatter.format(totalMonto)}',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.black,
                ),
                textAlign: pw.TextAlign.end,
              ),
              width: 105,
            ),
          ],
        ),
      ],
    );
  }

  // Información de documentos aplicados:
  pw.Widget _buildDocumentosAplicados(
      List<PaBscCuentaCorriente1M> documentosSeleccionados,
      List<double> montosGuardados) {
    final List<double> montosValidos =
        montosGuardados.where((monto) => monto != 0.0).toList();

    final totalMontoAplicado = montosValidos.fold<double>(
      0.0,
      (sum, item) => sum + item,
    );

    double totalMontoSaldos = 0.0;
    for (var item in montosValidos) {
      totalMontoSaldos +=
          documentosSeleccionados[montosGuardados.indexOf(item)].aplicar;
    }
    ;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${S.of(context).documentosAplicados}:',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.red,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        //Información de tipo Pago:
        pw.Divider(
          thickness: 1,
          color: PdfColors.blue700,
          height: 5,
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              '${S.of(context).tipoDocumento}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.blue700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${S.of(context).serieDocumento}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.blue700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${S.of(context).fechaDocumento}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.blue700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${S.of(context).idDocumento}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.blue700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${S.of(context).aplicado}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.blue700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${S.of(context).saldo}',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.blue700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.Divider(
          thickness: 1,
          color: PdfColors.blue700,
          height: 5,
        ),
        // Lista de documentos seleccionados
        for (var item in montosValidos)
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                children: [
                  pw.Container(
                      child: pw.Text(
                        documentosSeleccionados[montosValidos.indexOf(item)]
                                .desTipoDocumento
                                ?.toString() ??
                            'N/A',
                        style:
                            pw.TextStyle(fontSize: 10, color: PdfColors.black),
                      ),
                      width: 95),
                ],
              ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                        child: pw.Text(
                          documentosSeleccionados[montosValidos.indexOf(item)]
                                  .desSerieDocumento
                                  ?.toString() ??
                              'N/A',
                          style: pw.TextStyle(
                              fontSize: 10, color: PdfColors.black),
                        ),
                        width: 100),
                  ]),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                        child: pw.Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.parse(
                              documentosSeleccionados[
                                      montosValidos.indexOf(item)]
                                  .fechaDocumento
                                  .toString())),
                          style: pw.TextStyle(
                              fontSize: 10, color: PdfColors.black),
                        ),
                        width: 95),
                  ]),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                        child: pw.Text(
                          documentosSeleccionados[montosValidos.indexOf(item)]
                                  .idDocumento
                                  ?.toString() ??
                              'N/A',
                          style: pw.TextStyle(
                              fontSize: 10, color: PdfColors.black),
                        ),
                        width: 70), //60
                  ]),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                    child: pw.Text(
                      formatter
                          .format(montosValidos[montosValidos.indexOf(item)]),
                      style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
                      textAlign: pw.TextAlign.end,
                    ),
                    width: 55,
                  ),
                ],
              ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                        child: pw.Text(
                          formatter.format(documentosSeleccionados[
                                      montosGuardados.indexOf(item)]
                                  .aplicar) ??
                              'N/A',
                          style: pw.TextStyle(
                              fontSize: 10, color: PdfColors.black),
                          textAlign: pw.TextAlign.end,
                        ),
                        width: 50),
                  ])
            ],
          ),
        pw.Divider(
          thickness: 1,
          color: PdfColors.blue700,
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Container(
              child: pw.Text(
                '${S.of(context).total}:',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              width: 50,
            ),
            pw.SizedBox(width: 158),
            pw.Container(
              child: pw.Text(
                formatter.format(totalMontoAplicado),
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.black,
                ),
                textAlign: pw.TextAlign.end,
              ),
              width: 55,
            ),
            pw.SizedBox(width: 18),
            pw.Container(
              child: pw.Text(
                formatter.format(totalMontoSaldos),
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.black,
                ),
                textAlign: pw.TextAlign.end,
              ),
              width: 50,
            ),
          ],
        ),
      ],
    );
  }

  //Otra información y espacio para indicar de recibido:
  pw.Widget _buildOtros(List<PaTblCargoAbonoM> registros) {
    final totalMonto = registros.fold<num>(0, (sum, item) => sum + item.Monto);
    final String totalLetras =
        numeroALetras(totalMonto.toDouble(), _idiomaActual);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${S.of(context).totalLetras}: ',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  '${S.of(context).observacion}:',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(width: 10),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 400,
                  child: pw.Text(
                    totalLetras,
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
                    maxLines: null,
                    overflow: pw.TextOverflow.clip,
                  ),
                ),
                pw.Container(
                  width: 400,
                  child: pw.Text(
                    '${documento[0].Observacion_1}',
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
                    maxLines: null,
                    overflow: pw.TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.Divider(
          thickness: 1,
          color: PdfColors.blue700,
          height: 1,
        ),
        pw.SizedBox(height: 3),
        pw.Divider(
          thickness: 1,
          color: PdfColors.blue700,
          height: 1,
        ),
        pw.SizedBox(height: 30),
        pw.Divider(
            thickness: 1, color: PdfColors.blue700, indent: 350, height: 20),
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text("${S.of(context).recibido}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ])
      ],
    );
  }

  //Funcion para cargar logo
  Future<Uint8List?> _loadLogoImage(String pathImage) async {
    Uint8List? imageData;

    if (pathImage.startsWith('assets/')) {
      // Cargar imagen desde assets
      final ByteData data = await rootBundle.load(pathImage);
      imageData = data.buffer.asUint8List();
    } else {
      // Cargar imagen desde almacenamiento local
      final File file = File(pathImage);
      if (await file.exists()) {
        imageData = await file.readAsBytes();
      } else {
        throw Exception(
            'La imagen no existe en la ruta proporcionada: $pathImage');
      }
    }

    if (imageData != null && imageData.isNotEmpty) {
      return imageData;
    } else {
      throw Exception('La imagen cargada está vacía o es nula.');
    }
  }

  String numeroALetras(double numero, Locale _idiomaActual) {
    // Listas en diferentes idiomas para unidades, decenas, centenas, miles, millones, etc.
    Map<String, List<String>> unidades = {
      'es': [
        "",
        "UNO",
        "DOS",
        "TRES",
        "CUATRO",
        "CINCO",
        "SEIS",
        "SIETE",
        "OCHO",
        "NUEVE"
      ],
      'en': [
        "",
        "ONE",
        "TWO",
        "THREE",
        "FOUR",
        "FIVE",
        "SIX",
        "SEVEN",
        "EIGHT",
        "NINE"
      ],
      'de': [
        "",
        "EINS",
        "ZWEI",
        "DREI",
        "VIER",
        "FÜNF",
        "SECHS",
        "SIEBEN",
        "ACHT",
        "NEUN"
      ],
      'fr': [
        "",
        "UN",
        "DEUX",
        "TROIS",
        "QUATRE",
        "CINQ",
        "SIX",
        "SEPT",
        "HUIT",
        "NEUF"
      ]
    };

    Map<String, List<String>> decenas = {
      'es': [
        "",
        "DIEZ",
        "VEINTE",
        "TREINTA",
        "CUARENTA",
        "CINCUENTA",
        "SESENTA",
        "SETENTA",
        "OCHENTA",
        "NOVENTA"
      ],
      'en': [
        "",
        "TEN",
        "TWENTY",
        "THIRTY",
        "FORTY",
        "FIFTY",
        "SIXTY",
        "SEVENTY",
        "EIGHTY",
        "NINETY"
      ],
      'de': [
        "",
        "ZEHN",
        "ZWANZIG",
        "DREISSIG",
        "VIERZIG",
        "FÜNFZIG",
        "SECHZIG",
        "SIEBZIG",
        "ACHTZIG",
        "NEUNZIG"
      ],
      'fr': [
        "",
        "DIX",
        "VINGT",
        "TRENTE",
        "QUARANTE",
        "CINQUANTE",
        "SOIXANTE",
        "SOIXANTE-DIX",
        "QUATRE-VINGT",
        "QUATRE-VINGT-DIX"
      ]
    };

    Map<String, List<String>> especiales = {
      'es': [
        "DIEZ",
        "ONCE",
        "DOCE",
        "TRECE",
        "CATORCE",
        "QUINCE",
        "DIECISÉIS",
        "DIECISIETE",
        "DIECIOCHO",
        "DIECINUEVE"
      ],
      'en': [
        "TEN",
        "ELEVEN",
        "TWELVE",
        "THIRTEEN",
        "FOURTEEN",
        "FIFTEEN",
        "SIXTEEN",
        "SEVENTEEN",
        "EIGHTEEN",
        "NINETEEN"
      ],
      'de': [
        "ZEHN",
        "ELF",
        "ZWÖLF",
        "DREIZEHN",
        "VIERZEHN",
        "FÜNFZEHN",
        "SECHZEHN",
        "SIEBZEHN",
        "ACHTZEHN",
        "NEUNZEHN"
      ],
      'fr': [
        "DIX",
        "ONZE",
        "DOUZE",
        "TREIZE",
        "QUATORZE",
        "QUINZE",
        "SEIZE",
        "DIX-SEPT",
        "DIX-HUIT",
        "DIX-NEUF"
      ]
    };

    Map<String, List<String>> centenas = {
      'es': [
        "",
        "CIEN",
        "DOSCIENTOS",
        "TRESCIENTOS",
        "CUATROCIENTOS",
        "QUINIENTOS",
        "SEISCIENTOS",
        "SETECIENTOS",
        "OCHOCIENTOS",
        "NOVECIENTOS"
      ],
      'en': [
        "",
        "ONE HUNDRED",
        "TWO HUNDRED",
        "THREE HUNDRED",
        "FOUR HUNDRED",
        "FIVE HUNDRED",
        "SIX HUNDRED",
        "SEVEN HUNDRED",
        "EIGHT HUNDRED",
        "NINE HUNDRED"
      ],
      'de': [
        "",
        "EINHUNDERT",
        "ZWEIHUNDERT",
        "DREIHUNDERT",
        "VIERHUNDERT",
        "FÜNFHUNDERT",
        "SECHSHUNDERT",
        "SIEBENHUNDERT",
        "ACHTHUNDERT",
        "NEUNHUNDERT"
      ],
      'fr': [
        "",
        "CENT",
        "DEUX CENTS",
        "TROIS CENTS",
        "QUATRE CENTS",
        "CINQ CENTS",
        "SIX CENTS",
        "SEPT CENTS",
        "HUIT CENTS",
        "NEUF CENTS"
      ]
    };

    Map<String, List<String>> miles = {
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

    Map<String, List<String>> millones = {
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

    Map<String, Map<String, String>> textosConexion = {
      'es': {
        'y': 'Y',
        'con': 'CON',
      },
      'en': {
        'y': '',
        'con': 'WITH',
      },
      'de': {
        'y': 'UND',
        'con': 'MIT',
      },
      'fr': {
        'y': 'ET',
        'con': 'AVEC',
      }
    };

    // Convierte números negativos a positivos
    numero = numero.abs();

    // Escoge el idioma según la configuración actual
    String idioma = _idiomaActual.languageCode;
    print("IDIOMA: ${idioma}");
    String convertirParteEntera(int numero) {
      // Verifica que el número esté en el rango permitido.
      if (numero < 0 || numero >= 1000000000) {
        return "Número fuera de rango";
      }

      switch (idioma) {
        case 'es': // Español
          if (numero < 10) {
            return unidades['es']![numero];
          } else if (numero < 20) {
            return especiales['es']![numero - 10];
          } else if (numero < 100) {
            int unidad = numero % 10;
            int decena = numero ~/ 10;

            // Verificamos si el número está entre 21 y 29
            if (decena == 2 && unidad > 0) {
              return "VEINTI" +
                  unidades['es']![
                      unidad]; // Casos como veintiuno, veintidós, etc.
            } else {
              // Para otros casos (como treinta y uno, cuarenta y cinco, etc.)
              return decenas['es']![decena] +
                  (unidad > 0
                      ? " ${textosConexion['es']!['y']} " +
                          unidades['es']![unidad]
                      : "");
            }
          } else if (numero < 1000) {
            int unidad = numero % 10;
            int decena = (numero ~/ 10) % 10;
            int centena = numero ~/ 100;

            // Corregimos el uso de "CIEN" y "CIENTO"
            String textoCentena;
            if (centena == 1 && decena == 0 && unidad == 0) {
              textoCentena = "CIEN"; // Exactamente 100
            } else if (centena == 1) {
              textoCentena = "CIENTO"; // De 101 a 199
            } else {
              textoCentena = centenas['es']![centena]; // Otros casos
            }

            // Verificar si el número está entre 10 y 19
            int decenaEspecial = numero % 100;
            if (decenaEspecial >= 10 && decenaEspecial <= 19) {
              // Restamos 10 para obtener el índice correcto en la lista
              String textoEspecial = especiales['es']![decenaEspecial - 10];
              return textoCentena + " " + textoEspecial;
            }

            // Verificamos si el número está entre 21 y 29
            String textoDecena = decenas['es']![decena];
            String textoUnidad = unidad > 0 ? unidades['es']![unidad] : "";

            // Agregar "y" entre la decena y la unidad cuando es necesario (excepto en los casos 11-19)
            if (decena == 2 && unidad > 0) {
              textoDecena = "VEINTI" + unidades['es']![unidad];
              textoUnidad = "";
            } else if (unidad > 0 && decena > 2) {
              textoUnidad =
                  " ${textosConexion['es']!['y']} " + unidades['es']![unidad];
            }

            return textoCentena +
                (decena > 0 ? " " + textoDecena : "") +
                (unidad > 0 ? " " + textoUnidad : "");
          } else if (numero < 10000) {
            int mil = numero ~/ 1000;
            int resto = numero % 1000;
            return (mil == 1 ? "MIL" : convertirParteEntera(mil) + " MIL") +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (numero < 1000000) {
            int miles = numero ~/ 1000;
            int resto = numero % 1000;
            return convertirParteEntera(miles) +
                " MIL" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (numero < 1000000000) {
            int cantidadMillones = numero ~/ 1000000;
            int resto = numero % 1000000;
            return (cantidadMillones == 1
                    ? "UN MILLÓN"
                    : convertirParteEntera(cantidadMillones) + " MILLONES") +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          }
          break;

        case 'en': // Inglés
          if (numero < 10) {
            return unidades['en']![numero];
          } else if (numero < 20) {
            return especiales['en']![numero - 10];
          } else if (numero < 100) {
            int unidad = numero % 10;
            int decena = numero ~/ 10;
            return decenas['en']![decena] +
                (unidad > 0
                    ? " ${textosConexion['en']!['y']} " +
                        unidades['en']![unidad]
                    : "");
          } else if (numero < 1000) {
            int unidad = numero % 10;
            int decena = (numero ~/ 10) % 10;
            int centena = numero ~/ 100;
            return centenas['en']![centena] +
                (decena > 0 ? " " + decenas['en']![decena] : "") +
                (unidad > 0
                    ? " ${textosConexion['en']!['y']} " +
                        unidades['en']![unidad]
                    : "");
          } else if (numero < 10000) {
            int mil = numero ~/ 1000;
            int resto = numero % 1000;
            return (mil == 1
                    ? "ONE THOUSAND"
                    : convertirParteEntera(mil) + " THOUSAND") +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (numero < 1000000) {
            int miles = numero ~/ 1000;
            int resto = numero % 1000;
            return convertirParteEntera(miles) +
                " THOUSAND" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (numero < 1000000000) {
            int cantidadMillones = numero ~/ 1000000;
            int resto = numero % 1000000;
            return convertirParteEntera(cantidadMillones) +
                " MILLION" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          }
          break;

        case 'fr': // Francés
          if (numero < 10) {
            return unidades['fr']![numero];
          } else if (numero < 20) {
            return especiales['fr']![numero - 10];
          } else if (numero < 100) {
            int unidad = numero % 10;
            int decena = numero ~/ 10;
            return decenas['fr']![decena] +
                (unidad > 0
                    ? " ${textosConexion['fr']!['y']} " +
                        unidades['fr']![unidad]
                    : "");
          } else if (numero < 1000) {
            int unidad = numero % 10;
            int decena = (numero ~/ 10) % 10;
            int centena = numero ~/ 100;
            return centenas['fr']![centena] +
                (decena > 0 ? " " + decenas['fr']![decena] : "") +
                (unidad > 0
                    ? " ${textosConexion['fr']!['y']} " +
                        unidades['fr']![unidad]
                    : "");
          } else if (numero < 10000) {
            int mil = numero ~/ 1000;
            int resto = numero % 1000;
            return (mil == 1 ? "MILLE" : convertirParteEntera(mil) + " MILLE") +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (numero < 1000000) {
            int miles = numero ~/ 1000;
            int resto = numero % 1000;
            return convertirParteEntera(miles) +
                " MILLE" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (numero < 1000000000) {
            int cantidadMillones = numero ~/ 1000000;
            int resto = numero % 1000000;
            return convertirParteEntera(cantidadMillones) +
                " MILLIONS" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          }
          break;

        case 'de': // Alemán
          if (numero < 10) {
            return unidades['de']![numero];
          } else if (numero < 20) {
            return especiales['de']![numero - 10];
          } else if (numero < 100) {
            int unidad = numero % 10;
            int decena = numero ~/ 10;
            return decenas['de']![decena] +
                (unidad > 0
                    ? " ${textosConexion['de']!['y']} " +
                        unidades['de']![unidad]
                    : "");
          } else if (numero < 1000) {
            int unidad = numero % 10;
            int decena = (numero ~/ 10) % 10;
            int centena = numero ~/ 100;
            return centenas['de']![centena] +
                (decena > 0 ? " " + decenas['de']![decena] : "") +
                (unidad > 0
                    ? " ${textosConexion['de']!['y']} " +
                        unidades['de']![unidad]
                    : "");
          } else if (numero < 10000) {
            int mil = numero ~/ 1000;
            int resto = numero % 1000;
            return (mil == 1
                    ? "EINTAUSEND"
                    : convertirParteEntera(mil) + " TAUSEND") +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (numero < 1000000) {
            int miles = numero ~/ 1000;
            int resto = numero % 1000;
            return convertirParteEntera(miles) +
                " TAUSEND" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          } else if (numero < 1000000000) {
            int cantidadMillones = numero ~/ 1000000;
            int resto = numero % 1000000;
            return convertirParteEntera(cantidadMillones) +
                " MILLIONEN" +
                (resto > 0 ? " " + convertirParteEntera(resto) : "");
          }
          break;
      }

      return "Número fuera de rango";
    }

    // Parte entera y decimal
    int parteEntera = numero.floor();
    int parteDecimal = ((numero - parteEntera) * 100).round();

    // Convertir la parte entera a texto
    String textoParteEntera = convertirParteEntera(parteEntera);
    String textoParteDecimal = parteDecimal > 0
        ? " ${textosConexion[idioma]!['con']} (${parteDecimal.toInt()}/100)"
        : "";

    return textoParteEntera + textoParteDecimal;
  }
}
