import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:traslado_datos/common/Loading.dart';
import 'package:traslado_datos/common/Mensajes.dart';
import 'package:traslado_datos/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traslado_datos/common/ThemeNotifier.dart';

// ignore: must_be_immutable
class TrasladoDatos extends StatefulWidget {
  final bool isBackgroundSet;
  final String imagePath;
  final Function(Locale) changeLanguage;
  final Function onScrollToDown;
  final Function onScrollToTop;
  Locale idiomaDropDown;
  final bool temaClaro;
  final String token;
  final String pUserName;
  final int pEmpresa;
  final int pEstacion_Trabajo;
  String baseUrl;
  final DateTime fechaSesion;
  final DateTime? fechaExpiracion;
  final String? despEmpresa;
  final String? despEstacion_Trabajo;

  TrasladoDatos({
    required this.isBackgroundSet,
    required this.imagePath,
    required this.changeLanguage,
    required this.idiomaDropDown,
    required this.onScrollToDown,
    required this.onScrollToTop,
    required this.baseUrl,
    required this.token,
    required this.pUserName,
    required this.pEmpresa,
    required this.pEstacion_Trabajo,
    required this.fechaSesion,
    required this.despEmpresa,
    required this.despEstacion_Trabajo,
    this.fechaExpiracion,
    required this.temaClaro,
  });
  @override
  _TrasladoDatosState createState() => _TrasladoDatosState();
}

class _TrasladoDatosState extends State<TrasladoDatos> {
  bool _cargandoTraslado = false;
  bool _cargandoHojas = false;
  bool isAsignarElemento = true;
  bool isDesasignarElemento = true;
  bool mostrarGridElementosUsuario = true;
  TextEditingController searchController = TextEditingController();

  bool isEmptyAsignados = false;
  bool isRequestError = false;
  bool _expandir = false;

  PlatformFile? _archivoSeleccionado;
  String? _tablaSeleccionada;
  List<String> _nombresHojas = [];
  List<String> _nombresHojasSeleccionadas = [];
  Dio _dio = Dio();
  String? _nombreHojaSeleccionada;
  final TextEditingController _urlController = TextEditingController();
  bool _isChecking = false;
  String? _checkResult;

  @override
  void initState() {
    super.initState();
  }

  void _mostrarAlerta(
    BuildContext context,
    String titulo,
    String mensaje,
    IconData? icono,
    Color colorIcono,
    int cantidadBotones,
    String textoPrimerBoton,
    VoidCallback? funcionPrimerBoton,
    String? textoSegundoBoton,
    VoidCallback? funcionSegundoBoton,
  ) async {
    await mostrarDialogo(
      context: context,
      titulo: titulo,
      mensaje: mensaje,
      icono: icono,
      colorIcono: colorIcono,
      cantidadBotones: cantidadBotones,
      textoPrimerBoton: textoPrimerBoton,
      funcionPrimerBoton: funcionPrimerBoton,
      textoSegundoBoton: textoSegundoBoton,
      funcionSegundoBoton: funcionSegundoBoton,
    );
  }

  void _mostrarMensajeScaffold(
    BuildContext context,
    String mensaje,
    IconData? icono,
    Color colorIcono,
    Color colorText,
    Color colorFondo,
    Duration duracion,
  ) async {
    await mostrarMensajeScaffold(
      context: context,
      mensaje: mensaje,
      icono: icono,
      colorIcono: colorIcono,
      duracion: duracion,
      colorText: colorText,
      colorFondo: colorFondo,
    );
  }

  void _seleccionarArchivo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
      );
      if (result != null) {
        setState(() {
          _archivoSeleccionado = result.files.firstOrNull;
        });
        _obtenerHojasExcel(_archivoSeleccionado!);
      }
    } catch (e) {
      _mostrarAlerta(
          context,
          S.of(context).mensajesConfimar,
          'Error al seleccionar el archivo: $e',
          FontAwesomeIcons.circleExclamation,
          Color(0xFFFEAB308),
          1,
          S.of(context).mensajesAceptar, () async {
        Navigator.pop(context);
      }, null, null);
    }
  }

  void _obtenerHojasExcel(PlatformFile file) async {
    setState(() {
      _cargandoHojas = true;
    });
    try {
      // ignore: unnecessary_null_comparison
      if (file != null) {
        dio.FormData formData = dio.FormData.fromMap({
          'archivoExcel':
              await dio.MultipartFile.fromFile(file.path!, filename: file.name),
        });
        final response = await _dio.post(
          '${widget.baseUrl}Ctrl_ObtenerHojasExcel',
          data: formData,
        );
        print('Respuesta del servidor: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.data}');
        // Almacenar las hojas en la lista _sheetNames
        setState(() {
          _nombresHojas = List<String>.from(response.data);
        });
      }
    } catch (e) {
      print('Error al enviar el archivo al servidor: $e');
    } finally {
      setState(() {
        _cargandoHojas = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  void _msgSeleccionarArchivo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF154790),
            ),
          ),
          content: Text(
            'No se ha seleccionado un archivo',
            style: TextStyle(color: Color(0xFF154790)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFDC9525)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _trasladarDatos() async {
    setState(() {
      _cargandoTraslado =
          true; // Establecer cargando al inicio de la operación.
    });

    try {
      PlatformFile? selectedFile = _archivoSeleccionado;

      if (selectedFile == null) {
        _msgSeleccionarArchivo();
        return;
      }

      for (String hojaSeleccionada in _nombresHojasSeleccionadas) {
        // Configura el FormData para cada hoja seleccionada
        FormData formData = FormData.fromMap({
          'ArchivoExcel': await dio.MultipartFile.fromFile(
            selectedFile.path!,
            filename: selectedFile.name,
          ),
          'NombreHojaExcel': hojaSeleccionada, // Cambia la hoja aquí
          'pUserName': widget.pUserName,
          'TAccion': 1,
          'TOpcion': 1,
          'pConsecutivo_Interno': 0,
          'pTipo_Estructura': 1,
          'pEstado': 1,
        });

        final response = await _dio.post(
          '${widget.baseUrl}PaTblDocumentoEstructuraCtrl',
          data: formData,
        );

        if (response.statusCode == 200) {
          print(
              'Datos insertados correctamente para la hoja: $hojaSeleccionada.');

          _mostrarMensajeScaffold(
              context,
              "Datos trasladados correctamente para la hoja $hojaSeleccionada",
              MdiIcons.checkboxMarkedCircle,
              Color(0xFFF15803D),
              Color(0xFFF15803D),
              Color(0xFFFDCFCE7),
              Duration(seconds: 2));
        } else {
          print('Error en la solicitud al servidor: ${response.statusCode}');
          String errorMessage = 'Error desconocido';
          if (response.data != null && response.data is Map) {
            errorMessage = response.data['Message'] ?? 'Error desconocido';
          }
          _mostrarAlerta(
              context,
              'Error al realizar la solicitud',
              response.data['Message'] ?? errorMessage,
              FontAwesomeIcons.circleExclamation,
              Color(0xFFFEAB308),
              0,
              "",
              null,
              null,
              null);
        }
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print(
              "Error al insertar los datos: ${e.response?.statusCode} - ${e.response?.data}");
          _mostrarAlerta(
              context,
              'Error al realizar la solicitud',
              '${e.response?.data}',
              FontAwesomeIcons.circleExclamation,
              Color(0xFFFEAB308),
              0,
              "",
              null,
              null,
              null);
        } else {
          print("Error de red: ${e.message}");
          _mostrarAlerta(
              context,
              'Error de red',
              e.message,
              FontAwesomeIcons.circleExclamation,
              Color(0xFFFEAB308),
              0,
              "",
              null,
              null,
              null);
        }
      } else {
        print('Error inesperado: $e');
        _mostrarAlerta(
            context,
            'Error inesperado',
            'Ocurrió un error inesperado: $e',
            FontAwesomeIcons.circleExclamation,
            Color(0xFFFEAB308),
            0,
            "",
            null,
            null,
            null);
      }
    } finally {
      setState(() {
        _cargandoTraslado = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  //WIDGET PRINCIPAL
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            decoration: BoxDecoration(
              color: widget.isBackgroundSet
                  ? Color.fromARGB(0, 21, 70, 144)
                  : (!themeNotifier.temaClaro
                      ? Color(0xFFF111827)
                      : Colors.white),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: Offset(0, 5),
                ),
              ],
              image: widget.isBackgroundSet
                  ? DecorationImage(
                      image: AssetImage(widget.imagePath),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ExpansionTile(
                    initiallyExpanded: true,
                    backgroundColor: Color.fromARGB(255, 230, 244, 245),
                    title: Text(
                      'Seleccionar archivo Excel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onExpansionChanged: (expanded) {
                      if (expanded && _tablaSeleccionada != null) {
                        setState(() {
                          _expandir = expanded;
                        });
                      }
                    },
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: _archivoSeleccionado == null
                            ? Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _seleccionarArchivo();
                                  },
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      leading: Icon(
                                        MdiIcons
                                            .folderOpenOutline, // Ícono moderno de carpeta
                                        color: Color(0xFFDC9525),
                                        size: 40.0,
                                      ),
                                      title: Text(
                                        "Cargar archivo",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Toca aquí para seleccionar un archivo",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    MdiIcons.fileExcel,
                                    color: Color(0xFFDD952A),
                                    size: 40.0,
                                  ),
                                  title: Text(
                                    _archivoSeleccionado!.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Tamaño: ${(_archivoSeleccionado!.size) / 1024} KB',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _nombresHojas = [];
                                        _nombresHojasSeleccionadas = [];
                                        _nombreHojaSeleccionada = null;
                                        _archivoSeleccionado = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 10),
                      if (_archivoSeleccionado != null)
                        Text(
                          'Seleccionar una hoja Excel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      SizedBox(height: 10),
                      if (_cargandoHojas)
                        LoadingComponent(
                            color: Colors.blue,
                            changeLanguage: widget.changeLanguage),
                      if (_nombresHojas.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _nombresHojas
                              .map(
                                (sheetName) => CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(sheetName),
                                  value: _nombresHojasSeleccionadas
                                      .contains(sheetName),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        _nombresHojasSeleccionadas
                                            .add(sheetName);
                                      } else {
                                        _nombresHojasSeleccionadas
                                            .remove(sheetName);
                                      }
                                    });
                                  },
                                  activeColor: Color(0xFFDC9525),
                                  checkColor: Colors.white,
                                ),
                              )
                              .toList(),
                        ),
                      if (_cargandoTraslado)
                        LoadingComponent(
                            color: Colors.blue,
                            changeLanguage: widget.changeLanguage),
                      if (_archivoSeleccionado != null &&
                          _nombresHojasSeleccionadas.isNotEmpty &&
                          !_cargandoHojas)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _mostrarAlerta(
                                  context,
                                  S.of(context).mensajesConfimar,
                                  "Confirmar el traslado de datos de las hojas seleccionadas: ${_nombresHojasSeleccionadas.join(', ')}",
                                  FontAwesomeIcons.circleExclamation,
                                  Color(0xFFFEAB308),
                                  1,
                                  S.of(context).mensajesConfimar, () async {
                                await _trasladarDatos();
                              }, null, null);
                            },
                            icon: Icon(
                              Icons.add_task_sharp,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Trasladar datos',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFDC9525),
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
