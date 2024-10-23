import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:test_cuenta_corriente/DocPendientesPago.dart';
import 'package:test_cuenta_corriente/PlantillaImagen.dart';
import 'package:test_cuenta_corriente/generated/l10n.dart';

class PdfPreviewScreen extends StatefulWidget {
  final Uint8List pdfData;
  final String nombrePdf;
  final bool afectar;
  final int seleccionadoCuentaCorrentista;
  final String seleccionadoCuentaCta;
  final String facturaNombre;
  final String facturaNit;
  final String facturaDireccion;
  final String ccDireccion;
  final String telefono;
  final String pUserName;
  final int pEmpresa;
  final int pEstacion_Trabajo;
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
  PdfPreviewScreen({
    required this.pdfData,
    required this.nombrePdf,
    required this.afectar,
    required this.seleccionadoCuentaCorrentista,
    required this.seleccionadoCuentaCta,
    required this.facturaNombre,
    required this.facturaNit,
    required this.facturaDireccion,
    required this.ccDireccion,
    required this.telefono,
    required this.pUserName,
    required this.pEmpresa,
    required this.pEstacion_Trabajo,
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
    this.fechaExpiracion,
  });
  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewState();
}

class _PdfPreviewState extends State<PdfPreviewScreen> {
  int _backGestureCount = 0;
  late Locale _idiomaActual;

  @override
  void initState() {
    super.initState();

    _idiomaActual = widget.idiomaDropDown;
  }

  Future<bool> _onWillPop() async {
    if (_backGestureCount == 0) {
      _backGestureCount++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).siVuelvesADeslizarPdf),
          backgroundColor: Colors.grey,
        ),
      );
      // Resetea el contador después de unos segundos
      Future.delayed(Duration(seconds: 2), () {
        _backGestureCount = 0;
      });
      return false;
    } else {
      // Cierra la aplicación
      SystemNavigator.pop();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(children: [
          if (widget.isBackgroundSet)
            BackgroundImage(imagePath: widget.imagePath),
          Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).vistaPreviaPdf),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  if (widget.afectar) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(S.of(context).aviso),
                        content: Text(S.of(context).asegurateDeImprimir),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Cierra el AlertDialog
                            },
                            child: Text(S.of(context).regresarGuardarCompartir),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Cierra el AlertDialog
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => TablaDocsPendientes(
                                    seleccionadoCuentaCorrentista:
                                        widget.seleccionadoCuentaCorrentista,
                                    seleccionadoCuentaCta:
                                        widget.seleccionadoCuentaCta,
                                    facturaNombre: widget.facturaNombre,
                                    facturaNit: widget.facturaNit,
                                    facturaDireccion: widget.facturaDireccion,
                                    ccDireccion: widget.ccDireccion,
                                    telefono: widget.telefono,
                                    pUserName: widget.pUserName,
                                    pEmpresa: widget.pEmpresa,
                                    pEstacion_Trabajo: widget.pEstacion_Trabajo,
                                    changeLanguage: widget.changeLanguage,
                                    seleccionarIdioma: widget.seleccionarIdioma,
                                    idiomaDropDown: _idiomaActual,
                                    baseUrl: widget.baseUrl,
                                    token: widget.token,
                                    temaClaro: widget.temaClaro,
                                    imagePath: widget.imagePath,
                                    isBackgroundSet: widget.isBackgroundSet,
                                    fechaSesion: widget.fechaSesion,
                                    tokenSesionGuardada:
                                        widget.tokenSesionGuardada,
                                    imageLogo: widget.imageLogo,
                                    verificarCaptcha: false,
                                    fechaExpiracion: widget.fechaExpiracion,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              S.of(context).regresarPantalla,
                              style: TextStyle(color: Colors.grey[500]!),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(S.of(context).aviso),
                        content: Text(S.of(context).asegurateDeImprimir),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Cierra el AlertDialog
                            },
                            child: Text(S.of(context).regresarGuardarCompartir),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Cierra el AlertDialog
                              Navigator.of(context)
                                  .pop(); // Regresa a la otra pantalla
                            },
                            child: Text(
                              S.of(context).regresarPantalla,
                              style: TextStyle(color: Colors.grey[500]!),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            body: PdfPreview(
              build: (format) async => widget.pdfData,
              pdfFileName: '${widget.nombrePdf}.pdf',
              canChangePageFormat: false,
            ),
          ),
        ]));
  }
}
