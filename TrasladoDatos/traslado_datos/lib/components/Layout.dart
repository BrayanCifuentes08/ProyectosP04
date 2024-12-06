import 'dart:convert';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:traslado_datos/common/FloatingActionButtonNotifier.dart';
import 'package:traslado_datos/common/ThemeNotifier.dart';
import 'package:traslado_datos/common/UrlNotifier.dart';
import 'package:traslado_datos/components/Drawer.dart';
import 'package:traslado_datos/components/trasladoDatos.dart';
import 'package:traslado_datos/generated/l10n.dart';
import 'package:traslado_datos/services/Shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Layout extends StatefulWidget {
  final String imagePath;
  final bool isBackgroundSet;
  final Function(Locale) changeLanguage;
  Locale idiomaDropDown;
  final bool temaClaro;
  final String token;
  final String pUserName;
  final int pEmpresa;
  final int pEstacion_Trabajo;
  String baseUrl;
  final DateTime fechaSesion;
  final DateTime? fechaExpiracion;
  final String? imageLogo;
  final String? despEmpresa;
  final String? despEstacion_Trabajo;
  final int? pApplication;

  Layout({
    required this.imagePath,
    required this.isBackgroundSet,
    required this.changeLanguage,
    required this.idiomaDropDown,
    required this.temaClaro,
    required this.token,
    required this.pUserName,
    required this.pEmpresa,
    required this.pEstacion_Trabajo,
    required this.baseUrl,
    this.fechaExpiracion,
    required this.fechaSesion,
    this.imageLogo,
    required this.despEmpresa,
    required this.despEstacion_Trabajo,
    required this.pApplication,
  });

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  FocusNode _focusSearch = FocusNode();
  late Locale _idiomaActual;
  int _backGestureCount = 0;
  bool _isFabVisible = true;
  late AccionService accionService;
  TextEditingController _serverController = TextEditingController();
  TextEditingController _databaseController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  bool _isChecking = false;
  String? _checkResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final urlProvider = Provider.of<UrlProvider>(context, listen: false);
      urlProvider.setBaseUrl(widget.baseUrl);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible) {
          setState(() {
            _isFabVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isFabVisible) {
          setState(() {
            _isFabVisible = true;
          });
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accionService = Provider.of<AccionService>(context, listen: false);
      accionService.setAccion(
          "${S.of(context).inicioInicio}", Icons.import_contacts);
    });
    _idiomaActual = widget.idiomaDropDown;
  }

  @override
  void dispose() {
    super.dispose();
    _focusSearch.dispose();
  }

  //METODO PARA DESPLAZAR HACIA ABAJO
  void desplazarScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Mueve el scroll al máximo del CustomScrollView
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  //METODO PARA DESPLAZAR HACIA ARRIBA
  void desplazarScrollArriba() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Mueve el scroll al inicio del CustomScrollView
      _scrollController.animateTo(
        0.0, // Posición inicial del scroll
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  //LOGICA DE MANEJO PARA GESTOS
  Future<bool> _onWillPop() async {
    if (_backGestureCount == 0) {
      _backGestureCount++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).layoutSiVuelvesADeslizar),
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

  void _msgConexion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conexión a Base de Datos"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _serverController,
                  decoration: InputDecoration(labelText: "Server"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _databaseController,
                  decoration: InputDecoration(labelText: "Database"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _conectarBaseDeDatos();
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text("Conectar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _conectarBaseDeDatos() async {
    final url = Uri.parse('${widget.baseUrl}ConexionCtrl');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}'
      },
      body: jsonEncode({
        'serverName': _serverController.text,
        'databaseName': _databaseController.text,
      }),
    );

    if (response.statusCode == 200) {
      // La conexión fue exitosa
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    } else {
      // Hubo un error al conectar
      final data = jsonDecode(response.body);
      print('Error: ${data['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${data['message']}')),
      );
    }
  }

  Future<bool> verificarBaseUrl(String baseUrl) async {
    String testEndpoint = 'VerificarUrlCtrl/estado';
    final url = '${baseUrl}$testEndpoint';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return true; // La URL base responde correctamente
      } else {
        return false; // La URL base no responde como se esperaba
      }
    } catch (e) {
      print('Error: $e'); // Error al intentar hacer la solicitud
      return false; // Error al intentar hacer la solicitud
    }
  }

  void mostrarDialogoBaseUrl() async {
    final urlProvider = Provider.of<UrlProvider>(context, listen: false);
    _urlController.text = urlProvider.baseUrl;
    widget.baseUrl = urlProvider.baseUrl;
    showDialog(
      barrierColor: Color.fromARGB(193, 0, 0, 0),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _urlController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _urlController.text.length,
              );
            });
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'URL:',
                style: TextStyle(color: Colors.black),
              ),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: 'Ingresar Url',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link,
                            color: Color.fromARGB(255, 56, 125, 253)),
                        suffixIcon: IconButton(
                          highlightColor:
                              const Color.fromARGB(255, 97, 168, 201),
                          icon: Icon(Icons.paste, color: Colors.black),
                          onPressed: () async {
                            Clipboard.setData(
                                ClipboardData(text: _urlController.text));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "Url copiada",
                            )));
                          },
                        ),
                      ),
                      cursorColor: Color(0xFFDD952A),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                    ),
                    if (_isChecking) CircularProgressIndicator(),
                    if (_checkResult != null)
                      Text(
                        _checkResult!,
                        style: TextStyle(
                          fontSize: 14,
                          color: _checkResult == 'URL válida'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isChecking = true;
                        });

                        final isValid =
                            await verificarBaseUrl(_urlController.text);
                        setState(() {
                          _isChecking = false;
                          _checkResult =
                              isValid ? 'Url válida' : 'Url no válida';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: Text(
                        'Verificar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        urlProvider.setBaseUrl(_urlController.text);
                        widget.baseUrl = urlProvider.baseUrl;
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                      ),
                      child: Text(
                        'Confirmar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  //WIDGET PRINCIPAL
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    accionService = Provider.of<AccionService>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(children: [
        //FONDO SCAFFOLD
        Container(
          decoration: BoxDecoration(
              gradient: !themeNotifier.temaClaro
                  ? LinearGradient(
                      colors: [
                        Color(0xFFF0276a2),
                        Color(0xFFF194a5a),
                        Color(0xFFF194a5a),
                        Color(0xFFF194a5a),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Color(0xFFF0276a2),
                        Color(0xFFF194a5a),
                        Color(0xFFF194a5a),
                        Color(0xFFF194a5a),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
        ),
        Scaffold(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          key: _scaffoldKey,
          //DRAWER - MENU LATERAL
          drawer: CustomDrawer(
            imagePath: widget.imagePath,
            isBackgroundSet: widget.isBackgroundSet,
            changeLanguage: widget.changeLanguage,
            idiomaDropDown: _idiomaActual,
            temaClaro: widget.temaClaro,
            token: widget.token,
            pUserName: widget.pUserName,
            pEmpresa: widget.pEmpresa,
            pEstacion_Trabajo: widget.pEstacion_Trabajo,
            fechaSesion: widget.fechaSesion,
            baseUrl: widget.baseUrl,
            fechaExpiracion: widget.fechaExpiracion,
            despEmpresa: widget.despEmpresa,
            despEstacion_Trabajo: widget.despEstacion_Trabajo,
          ),
          body: CustomScrollView(controller: _scrollController, slivers: [
            //SLIVERAPPBAR CON TÍTULO DINÁMICO
            SliverAppBar(
              expandedHeight: 110.0,
              pinned: true,
              floating: true,
              snap: true,
              elevation: 10,
              shadowColor: Color(0xFF004964),
              backgroundColor: Color(0xFF004964),
              flexibleSpace: FlexibleSpaceBar(
                  background: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      gradient: !themeNotifier.temaClaro
                          ? LinearGradient(colors: [
                              Color(0xFFF0276a2),
                              Color(0xFFF194a5a),
                            ])
                          : LinearGradient(colors: [
                              Color(0xFFF0276a2),
                              Color(0xFFF194a5a),
                            ]),
                    ),
                  ),
                  centerTitle: false,
                  title: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth * 0.8,
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          accionService.accion?.texto ?? '',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  )),
              leading: IconButton(
                padding: EdgeInsets.only(left: 20.0, top: 10.0),
                icon: Icon(Icons.menu, color: Colors.white, size: 30),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0, top: 5.0, bottom: 5.0),
                  child: Image.asset('assets/logo.png',
                      height: 50.0, color: Colors.white),
                ),
              ],
            ),
            //LLAMADA DEL DASHBOARD
            TrasladoDatos(
              isBackgroundSet: widget.isBackgroundSet,
              imagePath: widget.imagePath,
              changeLanguage: widget.changeLanguage,
              idiomaDropDown: widget.idiomaDropDown,
              onScrollToDown: desplazarScroll,
              onScrollToTop: desplazarScrollArriba,
              baseUrl: widget.baseUrl,
              pUserName: widget.pUserName,
              token: widget.token,
              pEmpresa: widget.pEmpresa,
              pEstacion_Trabajo: widget.pEstacion_Trabajo,
              fechaSesion: widget.fechaSesion,
              despEmpresa: widget.despEmpresa,
              despEstacion_Trabajo: widget.despEstacion_Trabajo,
              temaClaro: widget.temaClaro,
              fechaExpiracion: widget.fechaExpiracion,
            ),
          ]),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            backgroundColor: Colors.cyan,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            children: [
              SpeedDialChild(
                child: Icon(MdiIcons.database, color: Colors.white),
                backgroundColor: Colors.blue,
                label: 'Base de Datos',
                labelStyle: TextStyle(fontSize: 16.0),
                onTap: () {
                  _msgConexion();
                },
              ),
              SpeedDialChild(
                child: Icon(MdiIcons.earthPlus, color: Colors.white),
                backgroundColor: Colors.green,
                label: 'Configurar URL',
                labelStyle: TextStyle(fontSize: 16.0),
                onTap: () {
                  mostrarDialogoBaseUrl();
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
