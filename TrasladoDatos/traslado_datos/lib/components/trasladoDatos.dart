import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:traslado_datos/common/Loading.dart';
import 'package:traslado_datos/components/Layout.dart';
import 'package:traslado_datos/generated/l10n.dart';
import 'package:traslado_datos/services/Shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:traslado_datos/common/FloatingActionButtonNotifier.dart';
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
  bool _cargando = false;
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
  Dio _dio = Dio();
  String? _nombreHojaSeleccionada;
  final TextEditingController _urlController = TextEditingController();
  bool _isChecking = false;
  String? _checkResult;

  @override
  void initState() {
    super.initState();
  }

  void _seleccionarArchivo() async {
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
  }

  void _obtenerHojasExcel(PlatformFile file) async {
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
    }
  }

  void _msgConfirmar() async {}

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
                            ? ListTile(
                                onTap: () {
                                  _seleccionarArchivo();
                                },
                                title: Text(
                                  'Seleccionar archivo de Excel',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                leading: Icon(
                                  Icons.attach_file,
                                  color: Colors.grey,
                                ),
                                trailing: ElevatedButton.icon(
                                  onPressed: () {
                                    _seleccionarArchivo();
                                  },
                                  icon: Icon(Icons.upload_file,
                                      color: Colors.white),
                                  label: Text(
                                    'Cargar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFDC9525),
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
                      if (_nombresHojas.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _nombresHojas
                              .map(
                                (sheetName) => Row(
                                  children: [
                                    Checkbox(
                                      value:
                                          _nombreHojaSeleccionada == sheetName,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value!) {
                                            _nombreHojaSeleccionada = sheetName;
                                          } else {
                                            _nombreHojaSeleccionada = null;
                                          }
                                        });
                                      },
                                      fillColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return Color(0xFFDC9525);
                                          }
                                          return Colors.white;
                                        },
                                      ),
                                    ),
                                    Text(sheetName),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      if (_archivoSeleccionado != null &&
                          _nombreHojaSeleccionada != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _msgConfirmar();
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
