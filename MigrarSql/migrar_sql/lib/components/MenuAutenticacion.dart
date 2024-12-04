import 'dart:convert';
import 'dart:math';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:migrar_sql/common/Loading.dart';
import 'package:migrar_sql/common/ThemeNotifier.dart';
import 'package:migrar_sql/components/Layout.dart';
import 'package:migrar_sql/components/Login.dart';
import 'package:migrar_sql/components/Plantillas/PlantillaImagen.dart';
import 'package:migrar_sql/generated/l10n.dart';
import 'package:migrar_sql/models/PaBscApplication1M.dart';
import 'package:migrar_sql/models/PaBscEmpresa1M.dart';
import 'package:migrar_sql/models/PaBscEstacionTrabajo2M.dart';
import 'package:migrar_sql/models/PaBscUser2M.dart';
import 'package:migrar_sql/models/PaBscUserDisplay2M.dart';
import 'package:http/http.dart' as http;
import 'package:migrar_sql/services/LoginService.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MenuAutenticacion extends StatefulWidget {
  final String imagePath;
  final bool isBackgroundSet;
  final Function(Locale) changeLanguage;
  Locale idiomaDropDown;
  final bool temaClaro;
  final String token;
  final String baseUrl;
  final List<PaBscUser2M> user2;
  final TextEditingController urlController;
  final TextEditingController userController;
  final TextEditingController passwordController;
  final bool cargandoUser2;

  MenuAutenticacion({
    required this.imagePath,
    required this.isBackgroundSet,
    required this.changeLanguage,
    required this.idiomaDropDown,
    required this.temaClaro,
    required this.token,
    required this.baseUrl,
    required this.user2,
    required this.urlController,
    required this.userController,
    required this.cargandoUser2,
    required this.passwordController,
  });

  @override
  _MenuAutenticacionState createState() => _MenuAutenticacionState();
}

class _MenuAutenticacionState extends State<MenuAutenticacion>
    with TickerProviderStateMixin {
  bool _guardarSesion = false;

  bool _cargandoApplication = false;
  bool _cargandoEmpresa = false;
  bool _cargandoEstacionTrabajo = false;
  bool _cargandoUserDisplay = false;

  PaBscEstacionTrabajo2M? _selectedEstacionTrabajo;
  PaBscEmpresa1M? _selectedEmpresa;
  PaBscApplication1M? _selectedApplication;
  PaBscUserDisplay2M? _selectedUserDisplay;
  String? despEmpresa;
  String? despEstacion_Trabajo;

  List<PaBscApplication1M> _application1 = [];
  List<PaBscEmpresa1M> _empresa = [];
  List<PaBscEstacionTrabajo2M> _estacionTrabajo = [];
  List<PaBscUserDisplay2M> _userDisplay = [];

  bool _isExpandedEstacionTrabajo = false;
  bool _isExpandedEmpresa = false;
  bool _isExpandedApplication = false;
  bool _isExpandedUserDisplay = false;
  DateTime? fechaExpiracion = null;
  final LoginService _loginService = LoginService();

  Key _expansionTileKeyEstacionTrabajo = ValueKey(Random().nextInt(10000));
  Key _expansionTileKeyEmpresa = ValueKey(Random().nextInt(10000));
  Key _expansionTileKeyApplication = ValueKey(Random().nextInt(10000));
  Key _expansionTileKeyUserDisplay = ValueKey(Random().nextInt(10000));
  int _backGestureCount = 0;

  @override
  void initState() {
    super.initState();
    _application1.clear();
    _empresa.clear();
    _estacionTrabajo.clear();
    _userDisplay.clear();
    _selectedApplication = null;
    _selectedEmpresa = null;
    _selectedEstacionTrabajo = null;
    _selectedUserDisplay = null;
    _buscarEstacionTrabajo();
    _buscarEmpresa();
    _buscarApplication();
  }

  void _guardarDatosSesion() async {
    if (_guardarSesion) {
      final tokenExpiration = DateTime.now().add(Duration(days: 1));
      fechaExpiracion = tokenExpiration;
      await _loginService.saveUserSession(
        username: widget.userController.text,
        password: widget.passwordController.text,
        empresa: _selectedEmpresa!.empresa,
        estacionTrabajo: _selectedEstacionTrabajo!.estacionTrabajo,
        aplicacion: _selectedApplication!.application,
        display: _selectedUserDisplay?.userDisplay != null
            ? _selectedUserDisplay!.userDisplay
            : 0,
        token: widget.token,
        fecha: DateTime.now(),
        tokenExpiration: tokenExpiration,
        urlBase: widget.baseUrl,
        desEmpresa: despEmpresa,
        desEstacionTrabajo: despEstacion_Trabajo,
      );
      final sessionData = await _loginService.getUserSession();
      print('Datos de sesión guardados: $sessionData');
    } else {
      await _loginService.clearUserSession();
      print('Datos de sesión eliminados');
    }
  }

  Future<void> _buscarEstacionTrabajo() async {
    setState(() {
      _cargandoEstacionTrabajo =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaBscEstacionTrabajo2Ctrl';
    Map<String, dynamic> queryParams = {
      "pUserName": widget.userController.text
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscEstacionTrabajo2M> estacionTrabajo = jsonResponse
            .map((data) => PaBscEstacionTrabajo2M.fromJson(data))
            .toList();

        // Convertir la respuesta en objetos de modelo si es una lista
        _estacionTrabajo = estacionTrabajo;
        // Actualizar el estado con los datos obtenidos
        print('Estaciones de Trabajo: ${response.body}');
        setState(() {});
      } else {
        print('Error: ${response.statusCode}');
        print('${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoEstacionTrabajo = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> _buscarEmpresa() async {
    setState(() {
      _cargandoEmpresa =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaBscEmpresa1Ctrl';
    Map<String, dynamic> queryParams = {
      "pUserName": widget.userController.text
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscEmpresa1M> empresa =
            jsonResponse.map((data) => PaBscEmpresa1M.fromJson(data)).toList();

        // Convertir la respuesta en objetos de modelo si es una lista
        _empresa = empresa;
        // Actualizar el estado con los datos obtenidos
        print('Empresas: ${response.body}');
        setState(() {});
      } else {
        print('Error: ${response.statusCode}');
        print('${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoEmpresa = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> _buscarApplication() async {
    setState(() {
      _cargandoApplication =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaBscApplication1Ctrl';
    Map<String, dynamic> queryParams = {
      "TAccion": "1",
      "TOpcion": "1",
      "pFiltro_1": widget.userController.text,
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscApplication1M> application = jsonResponse
            .map((data) => PaBscApplication1M.fromJson(data))
            .toList();

        // Convertir la respuesta en objetos de modelo si es una lista
        _application1 = application;
        // Actualizar el estado con los datos obtenidos
        print('Aplicaciones: ${response.body}');
        setState(() {});
      } else {
        print('Error: ${response.statusCode}');
        print('${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoApplication = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> _buscarUserDisplay2() async {
    setState(() {
      _cargandoUserDisplay =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaBscUserDisplay2Ctrl';
    Map<String, dynamic> queryParams = {
      "UserName": widget.userController.text,
      "Application": _selectedApplication!.application.toString(),
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscUserDisplay2M> userDisplay = jsonResponse
            .map((data) => PaBscUserDisplay2M.fromJson(data))
            .toList();

        // Convertir la respuesta en objetos de modelo si es una lista
        _userDisplay = userDisplay;
        // Actualizar el estado con los datos obtenidos
        print('userDisplay: ${response.body}');
        setState(() {});
      } else {
        print('Error: ${response.statusCode}');
        print('${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoUserDisplay = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_backGestureCount == 0) {
      _backGestureCount++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Si vuelves a deslizar, saldrás de la aplicación."),
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
    _selectedEstacionTrabajo = _estacionTrabajo.isNotEmpty
        ? (_estacionTrabajo.contains(_selectedEstacionTrabajo)
            ? _selectedEstacionTrabajo
            : null)
        : null;
    _selectedEmpresa = _empresa.isNotEmpty
        ? (_empresa.contains(_selectedEmpresa) ? _selectedEmpresa : null)
        : null;
    _selectedApplication = _application1.isNotEmpty
        ? (_application1.contains(_selectedApplication)
            ? _selectedApplication
            : null)
        : null;
    _selectedUserDisplay = _userDisplay.isNotEmpty
        ? (_userDisplay.contains(_selectedUserDisplay)
            ? _selectedUserDisplay
            : null)
        : null;
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(children: [
          if (!widget.isBackgroundSet)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF004964),
                    Colors.black,
                  ],
                ),
              ),
            ),
          // Fondo animado con AnimatedBackground
          if (!widget.isBackgroundSet)
            AnimatedBackground(
              behaviour: RandomParticleBehaviour(
                  options: ParticleOptions(
                      baseColor: Colors.white,
                      spawnMinRadius: 40,
                      spawnMaxRadius: 80,
                      spawnMinSpeed: 15,
                      particleCount: 6,
                      spawnMaxSpeed: 80,
                      spawnOpacity: 0.2,
                      image: Image.asset("assets/image.png"))),
              vsync: this,
              child: Container(),
            ),
          if (widget.isBackgroundSet)
            BackgroundImage(imagePath: widget.imagePath),
          Scaffold(
              backgroundColor: Colors.transparent,
              body: CustomScrollView(slivers: [
                SliverAppBar(
                  expandedHeight: 110.0,
                  pinned: true,
                  floating: true,
                  elevation: 10,
                  shadowColor: Color.fromARGB(255, 0, 73, 100),
                  backgroundColor: Color.fromARGB(0, 0, 73, 100),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                    imagePath: widget.imagePath,
                                    isBackgroundSet: widget.isBackgroundSet,
                                    changeLanguage: widget.changeLanguage,
                                    idiomaDropDown: widget.idiomaDropDown,
                                    seleccionarIdioma: widget.idiomaDropDown,
                                  )),
                        );
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white)),
                  actions: [
                    Padding(
                      padding:
                          EdgeInsets.only(right: 10.0, top: 5.0, bottom: 5.0),
                      child: Image.asset('assets/logo.png',
                          height: 50.0, color: Colors.white),
                    ),
                  ],
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: IntrinsicWidth(
                              child: IntrinsicHeight(
                                  child: Container(
                                      padding: EdgeInsets.all(32.0),
                                      decoration: BoxDecoration(
                                        color: themeNotifier.temaClaro
                                            ? Color.fromARGB(255, 255, 255, 255)
                                                .withOpacity(0.97)
                                            : Color.fromARGB(255, 18, 32, 47)
                                                .withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView(
                                          // Envolver la columna en SingleChildScrollView
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("Menu Autenticación",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                          SizedBox(height: 10),
                                          // COMPONENTE DE CARGA
                                          if (widget.cargandoUser2 ||
                                              _cargandoApplication ||
                                              _cargandoEmpresa ||
                                              _cargandoEstacionTrabajo)
                                            LoadingComponent(
                                              color: Colors.blue[200]!,
                                              changeLanguage:
                                                  widget.changeLanguage,
                                            ),
                                          //EXPANSION TILE DE ESTACIONES DE TRABAJO
                                          if (widget.user2.isNotEmpty &&
                                              widget.user2[0].continuar ==
                                                  true &&
                                              _estacionTrabajo.isNotEmpty)
                                            Column(
                                              children: [
                                                Divider(
                                                  height: 4,
                                                  thickness: 0.5,
                                                  color: Colors.grey,
                                                ),
                                                ExpansionTile(
                                                  key:
                                                      _expansionTileKeyEstacionTrabajo,
                                                  initiallyExpanded:
                                                      _isExpandedEstacionTrabajo,
                                                  backgroundColor:
                                                      _isExpandedEstacionTrabajo
                                                          ? const Color
                                                              .fromARGB(
                                                              21, 2, 53, 236)
                                                          : Colors.white,
                                                  title: Text(
                                                    _selectedEstacionTrabajo
                                                            ?.nombre ??
                                                        S
                                                            .of(context)
                                                            .loginSeleccionarEstacionTrabajo,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: themeNotifier
                                                              .temaClaro
                                                          ? Colors.grey.shade600
                                                          : Colors
                                                              .grey.shade100,
                                                    ),
                                                  ),
                                                  trailing: Icon(
                                                    _isExpandedEstacionTrabajo
                                                        ? Icons
                                                            .keyboard_arrow_up_rounded
                                                        : Icons
                                                            .keyboard_arrow_down_rounded,
                                                    color:
                                                        themeNotifier.temaClaro
                                                            ? Colors.black
                                                            : Colors.white,
                                                  ),
                                                  onExpansionChanged:
                                                      (expanded) {
                                                    setState(() {
                                                      _isExpandedEstacionTrabajo =
                                                          expanded;
                                                    });
                                                  },
                                                  children: [
                                                    Container(
                                                      height:
                                                          150, // Ajusta la altura para controlar el espacio de scroll
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children:
                                                              _estacionTrabajo
                                                                  .map((item) {
                                                            return ListTile(
                                                              title: Text(
                                                                item.nombre,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: themeNotifier
                                                                          .temaClaro
                                                                      ? Colors
                                                                          .black87
                                                                      : Colors.grey[
                                                                          200],
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                setState(() {
                                                                  _selectedEstacionTrabajo =
                                                                      item;
                                                                  despEstacion_Trabajo =
                                                                      item.nombre;
                                                                  _isExpandedEstacionTrabajo =
                                                                      false;
                                                                  _expansionTileKeyEstacionTrabajo =
                                                                      ValueKey(Random()
                                                                          .nextInt(
                                                                              10000));
                                                                });
                                                              },
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (_isExpandedEstacionTrabajo ==
                                                    true)
                                                  Divider(
                                                    height: 4,
                                                    thickness: 0.5,
                                                    color: Colors.grey,
                                                  ),
                                              ],
                                            ),
                                          //EXPANSION TILE  DE EMPRESAS
                                          if (widget.user2.isNotEmpty &&
                                              widget.user2[0].continuar ==
                                                  true &&
                                              _empresa.isNotEmpty)
                                            Column(
                                              children: [
                                                Divider(
                                                  height: 4,
                                                  thickness: 0.5,
                                                  color: Colors.grey,
                                                ),
                                                ExpansionTile(
                                                  key: _expansionTileKeyEmpresa,
                                                  initiallyExpanded:
                                                      _isExpandedEmpresa,
                                                  backgroundColor:
                                                      _isExpandedEmpresa
                                                          ? const Color
                                                              .fromARGB(
                                                              21, 2, 53, 236)
                                                          : Colors.white,
                                                  title: Text(
                                                    _selectedEmpresa
                                                            ?.empresaNombre ??
                                                        S
                                                            .of(context)
                                                            .loginSeleccionarEmpresa,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: themeNotifier
                                                              .temaClaro
                                                          ? Colors.grey.shade600
                                                          : Colors
                                                              .grey.shade100,
                                                    ),
                                                  ),
                                                  trailing: Icon(
                                                    _isExpandedEmpresa
                                                        ? Icons
                                                            .keyboard_arrow_up_rounded
                                                        : Icons
                                                            .keyboard_arrow_down_rounded,
                                                    color:
                                                        themeNotifier.temaClaro
                                                            ? Colors.black
                                                            : Colors.white,
                                                  ),
                                                  onExpansionChanged:
                                                      (expanded) {
                                                    setState(() {
                                                      _isExpandedEmpresa =
                                                          expanded;
                                                    });
                                                  },
                                                  children: [
                                                    if (_empresa.isNotEmpty)
                                                      Container(
                                                        height:
                                                            150, // Altura fija para permitir scroll
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: _empresa
                                                                .map((item) {
                                                              return ListTile(
                                                                title: Text(
                                                                  item.empresaNombre,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: themeNotifier.temaClaro
                                                                        ? Colors
                                                                            .black87
                                                                        : Colors
                                                                            .grey[200],
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    _selectedEmpresa =
                                                                        item;
                                                                    despEmpresa =
                                                                        item.empresaNombre;
                                                                    _expansionTileKeyEmpresa =
                                                                        ValueKey(
                                                                            Random().nextInt(10000));
                                                                    _isExpandedEmpresa =
                                                                        false; // Cierra el ExpansionTile después de seleccionar
                                                                  });
                                                                },
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                if (_isExpandedEmpresa == true)
                                                  Divider(
                                                    height: 4,
                                                    thickness: 0.5,
                                                    color: Colors.grey,
                                                  ),
                                              ],
                                            ),
                                          //EXPANSION TILE  DE APLICACIONES
                                          if (widget.user2.isNotEmpty &&
                                              widget.user2[0].continuar ==
                                                  true &&
                                              _application1.isNotEmpty)
                                            Column(
                                              children: [
                                                Divider(
                                                  height: 4,
                                                  thickness: 0.5,
                                                  color: Colors.grey,
                                                ),
                                                ExpansionTile(
                                                  key:
                                                      _expansionTileKeyApplication,
                                                  initiallyExpanded:
                                                      _isExpandedApplication,
                                                  backgroundColor:
                                                      _isExpandedApplication
                                                          ? const Color
                                                              .fromARGB(
                                                              21, 2, 53, 236)
                                                          : Colors.white,
                                                  title: Text(
                                                    _selectedApplication
                                                            ?.description ??
                                                        S
                                                            .of(context)
                                                            .loginSeleccionarAplicacion,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: themeNotifier
                                                              .temaClaro
                                                          ? Colors.grey.shade600
                                                          : Colors
                                                              .grey.shade100,
                                                    ),
                                                  ),
                                                  trailing: Icon(
                                                    _isExpandedApplication
                                                        ? Icons
                                                            .keyboard_arrow_up_rounded
                                                        : Icons
                                                            .keyboard_arrow_down_rounded,
                                                    color:
                                                        themeNotifier.temaClaro
                                                            ? Colors.black
                                                            : Colors.white,
                                                  ),
                                                  onExpansionChanged:
                                                      (expanded) {
                                                    setState(() {
                                                      _isExpandedApplication =
                                                          expanded;
                                                    });
                                                  },
                                                  children: [
                                                    if (_application1
                                                        .isNotEmpty)
                                                      Container(
                                                        height:
                                                            150, // Altura fija para permitir desplazamiento
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children:
                                                                _application1
                                                                    .map(
                                                                        (item) {
                                                              return ListTile(
                                                                title: Text(
                                                                  item.description,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: themeNotifier.temaClaro
                                                                        ? Colors
                                                                            .black87
                                                                        : Colors
                                                                            .grey[200],
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    _selectedApplication =
                                                                        item;
                                                                    _selectedUserDisplay =
                                                                        null;
                                                                    _buscarUserDisplay2();
                                                                    _isExpandedApplication =
                                                                        false;
                                                                    _expansionTileKeyApplication =
                                                                        ValueKey(
                                                                            Random().nextInt(10000));
                                                                  });
                                                                },
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                if (_isExpandedApplication ==
                                                    true)
                                                  Divider(
                                                    height: 4,
                                                    thickness: 0.5,
                                                    color: Colors.grey,
                                                  ),
                                              ],
                                            ),
                                          //EXPANSION TILE  DE USER DISPLAY
                                          widget.user2.isNotEmpty &&
                                                  widget.user2[0].continuar ==
                                                      true &&
                                                  _selectedApplication !=
                                                      null &&
                                                  _userDisplay.isNotEmpty
                                              ? Column(
                                                  children: [
                                                    Divider(
                                                      height: 4,
                                                      thickness: 0.5,
                                                      color: Colors.grey,
                                                    ),
                                                    ExpansionTile(
                                                      key:
                                                          _expansionTileKeyUserDisplay,
                                                      initiallyExpanded:
                                                          _isExpandedUserDisplay,
                                                      backgroundColor:
                                                          _isExpandedUserDisplay
                                                              ? const Color
                                                                  .fromARGB(21,
                                                                  2, 53, 236)
                                                              : null,
                                                      title: Text(
                                                        _selectedUserDisplay
                                                                ?.name ??
                                                            S
                                                                .of(context)
                                                                .loginSeleccionarDisplay,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: themeNotifier
                                                                  .temaClaro
                                                              ? Colors
                                                                  .grey.shade600
                                                              : Colors.grey
                                                                  .shade100,
                                                        ),
                                                      ),
                                                      trailing: Icon(
                                                        _isExpandedUserDisplay
                                                            ? Icons
                                                                .keyboard_arrow_up_rounded
                                                            : Icons
                                                                .keyboard_arrow_down_rounded,
                                                        color: themeNotifier
                                                                .temaClaro
                                                            ? Colors.black
                                                            : Colors.white,
                                                      ),
                                                      onExpansionChanged:
                                                          (expanded) {
                                                        setState(() {
                                                          _isExpandedUserDisplay =
                                                              expanded;
                                                        });
                                                      },
                                                      children: [
                                                        Container(
                                                          height: 150,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              children:
                                                                  buildUserDisplay(
                                                                      _userDisplay),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      height: 4,
                                                      thickness: 0.5,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          // COMPONENTE DE CARGA PARA USER DISPLAY
                                          if (_cargandoUserDisplay)
                                            LoadingComponent(
                                              color: Colors.blue[200]!,
                                              changeLanguage:
                                                  widget.changeLanguage,
                                            ),
                                          SizedBox(height: 5),
                                          //BOTON DE INGRESAR Y SWITCH PARA GUARDAR SESION
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //Botón Ingresar
                                              if (_selectedEstacionTrabajo !=
                                                      null &&
                                                  _selectedEmpresa != null &&
                                                  (_application1.isEmpty ||
                                                      (_application1
                                                              .isNotEmpty &&
                                                          _selectedApplication !=
                                                              null)) &&
                                                  (_selectedUserDisplay !=
                                                          null ||
                                                      !_userDisplay.any((item) =>
                                                          item.displayURLAlter !=
                                                          null)))
                                                Flexible(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Layout(
                                                                        imagePath:
                                                                            widget.imagePath,
                                                                        isBackgroundSet:
                                                                            widget.isBackgroundSet,
                                                                        changeLanguage:
                                                                            widget.changeLanguage,
                                                                        idiomaDropDown:
                                                                            widget.idiomaDropDown,
                                                                        temaClaro:
                                                                            themeNotifier.temaClaro,
                                                                        token: widget
                                                                            .token,
                                                                        pUserName: widget
                                                                            .userController
                                                                            .text,
                                                                        pEmpresa:
                                                                            _selectedEmpresa!.empresa,
                                                                        pEstacion_Trabajo:
                                                                            _selectedEstacionTrabajo!.estacionTrabajo,
                                                                        baseUrl:
                                                                            widget.baseUrl,
                                                                        fechaSesion:
                                                                            DateTime.now(),
                                                                        fechaExpiracion:
                                                                            fechaExpiracion,
                                                                        despEmpresa:
                                                                            despEmpresa,
                                                                        despEstacion_Trabajo:
                                                                            despEstacion_Trabajo,
                                                                        pApplication:
                                                                            _selectedApplication!.application,
                                                                      )),
                                                        );
                                                      },
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .loginIngresar,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: themeNotifier
                                                                  .temaClaro
                                                              ? Color(
                                                                  0xFF5A38FD)
                                                              : Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              //Switch Guardar sesion
                                              if (_selectedEstacionTrabajo !=
                                                      null &&
                                                  _selectedEmpresa != null &&
                                                  (_application1.isEmpty ||
                                                      (_application1
                                                              .isNotEmpty &&
                                                          _selectedApplication !=
                                                              null)) &&
                                                  (_selectedUserDisplay !=
                                                          null ||
                                                      !_userDisplay.any((item) =>
                                                          item.displayURLAlter !=
                                                          null)))
                                                Flexible(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Flexible(
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            child: Text(
                                                              S
                                                                  .of(context)
                                                                  .loginGuardarSesion,
                                                              style: TextStyle(
                                                                color: widget
                                                                        .temaClaro
                                                                    ? Color(
                                                                        0xFF5A38FD)
                                                                    : Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Transform.scale(
                                                          scale: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width <
                                                                  400
                                                              ? 0.7
                                                              : MediaQuery.of(context)
                                                                          .size
                                                                          .width <
                                                                      600
                                                                  ? 0.75
                                                                  : 1.0,
                                                          child: Switch(
                                                            value:
                                                                _guardarSesion,
                                                            onChanged:
                                                                (bool value) {
                                                              setState(() {
                                                                _guardarSesion =
                                                                    value;
                                                              });
                                                              _guardarDatosSesion();
                                                            },
                                                            activeColor: Color(
                                                                0xFF5A38FD),
                                                            inactiveThumbColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    155,
                                                                    86,
                                                                    86),
                                                            inactiveTrackColor:
                                                                Colors
                                                                    .grey[300],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ))))))),
                )
              ]))
        ]));
  }

  List<Widget> buildUserDisplay(List<PaBscUserDisplay2M> userDisplayList) {
    // Filtramos elementos raíz (padres iniciales)
    List<PaBscUserDisplay2M> rootDisplays =
        userDisplayList.where((item) => item.userDisplayFather == 0).toList();

    // Creamos widgets a partir de la raíz
    List<Widget> displayWidgets = rootDisplays
        .map((rootItem) => buildExpansionTile(rootItem, userDisplayList))
        .where((widget) => widget != null)
        .cast<Widget>() // Asegura que la lista se convierta a List<Widget>
        .toList();

    // Si no hay widgets válidos
    if (displayWidgets.isEmpty) {
      return [
        ListTile(
          title: Text(
            "No hay displays disponibles",
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ];
    }

    return displayWidgets;
  }

  Widget? buildExpansionTile(
      PaBscUserDisplay2M parentItem, List<PaBscUserDisplay2M> userDisplayList) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    // Obtener hijos directos del nodo actual
    List<PaBscUserDisplay2M> children = userDisplayList
        .where((item) => item.userDisplayFather == parentItem.userDisplay)
        .toList();

    // Verificar si alguno de los hijos es un nodo de último nivel válido
    bool hasValidChildren = children.any((child) {
      return child.displayURLAlter != null ||
          userDisplayList
              .any((subItem) => subItem.userDisplayFather == child.userDisplay);
    });

    // Si no hay hijos válidos y el nodo no tiene URL, no mostrar nada
    if (!hasValidChildren && parentItem.displayURLAlter == null) {
      return null;
    }

    // Construcción recursiva
    List<Widget> childWidgets = children
        .map((child) {
          return buildExpansionTile(child, userDisplayList);
        })
        .where((widget) => widget != null)
        .cast<Widget>()
        .toList();

    // Si el nodo tiene hijos válidos, mostrar un ExpansionTile
    if (childWidgets.isNotEmpty) {
      return ExpansionTile(
        backgroundColor: _isExpandedUserDisplay
            ? const Color.fromARGB(20, 23, 68, 230)
            : Colors.white,
        title: Text(
          parentItem.name,
          style: TextStyle(
            fontSize: 14,
            color: themeNotifier.temaClaro
                ? Colors.grey.shade600
                : Colors.grey.shade100,
          ),
        ),
        trailing: Icon(
          _isExpandedUserDisplay
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          color: themeNotifier.temaClaro ? Colors.black : Colors.white,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpandedUserDisplay = expanded;
          });
        },
        children: childWidgets,
      );
    } else if (parentItem.displayURLAlter != null) {
      // Si no tiene hijos pero tiene displayURLAlter, mostramos un ListTile
      return ListTile(
        title: Text(
          parentItem.name,
          style: TextStyle(
            fontSize: 14,
            color: themeNotifier.temaClaro ? Colors.black87 : Colors.grey[200],
          ),
        ),
        onTap: () {
          setState(() {
            _selectedUserDisplay = parentItem;
            _expansionTileKeyUserDisplay = ValueKey(Random().nextInt(10000));
            _isExpandedUserDisplay = false;
          });
        },
      );
    }

    return null; // Nodo sin hijos válidos ni displayURLAlter
  }
}
