import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mantenimiento_catalogos/Dashboard.dart';
import 'package:mantenimiento_catalogos/common/ThemeNotifier.dart';
import 'package:mantenimiento_catalogos/components/Footer.dart';
import 'package:mantenimiento_catalogos/components/PantallaInicio.dart';
import 'package:mantenimiento_catalogos/components/Drawer.dart';
import 'package:mantenimiento_catalogos/generated/l10n.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Mantenimiento extends StatefulWidget {
  final String imagePath;
  final String? catalogo;
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

  Mantenimiento({
    required this.imagePath,
    required this.isBackgroundSet,
    required this.catalogo,
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
  });

  @override
  _MantenimientoState createState() => _MantenimientoState();
}

class _MantenimientoState extends State<Mantenimiento> {
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  FocusNode _focusSearch = FocusNode();
  late Locale _idiomaActual;
  String _opcionSeleccionada = '';
  int _backGestureCount = 0;
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
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
    _idiomaActual = widget.idiomaDropDown;
  }

  @override
  void dispose() {
    super.dispose();
    _focusSearch.dispose();
  }

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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                gradient: !themeNotifier.temaClaro
                    ? LinearGradient(
                        colors: [
                          Color.fromARGB(255, 124, 124, 124),
                          Color.fromARGB(255, 124, 124, 124),
                          Color(0xFF004964),
                          Color(0xFF004964),
                          Color(0xFF004964),
                          Color(0xFF004964),
                          Color(0xFF004964),
                          Color(0xFF004964),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          Color(0xFFDD952A),
                          Color(0xFFDD952A),
                          Color(0xFF004964),
                          Color(0xFF004964),
                          Color(0xFF004964),
                          Color(0xFF004964),
                          Color(0xFF004964),
                          Color(0xFF004964),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )),
          ),
          Scaffold(
            backgroundColor: Color.fromARGB(0, 255, 255, 255),
            key: _scaffoldKey,
            drawer: CustomDrawer(
              imagePath: widget.imagePath,
              isBackgroundSet: widget.isBackgroundSet,
              catalogo: widget.catalogo,
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
              SliverAppBar(
                expandedHeight: 110.0,
                pinned: true,
                floating: true,
                elevation: 10,
                shadowColor: Color(0xFF004964),
                backgroundColor: Color(0xFF004964),
                flexibleSpace: FlexibleSpaceBar(
                  background: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      gradient: !themeNotifier.temaClaro
                          ? LinearGradient(colors: [
                              Color.fromARGB(255, 124, 124, 124),
                              Color(0xFF004964),
                            ])
                          : LinearGradient(colors: [
                              Color(0xFFDD952A),
                              Color(0xFF004964),
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
                          widget.catalogo != null
                              ? S.of(context).drawerMantenimiento
                              : S.of(context).inicioInicio,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ),
                leading: IconButton(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0),
                  icon: Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                actions: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: 10.0, top: 5.0, bottom: 5.0),
                    child: Image.asset('assets/logo.png',
                        height: 50.0, color: Colors.white),
                  ),
                ],
              ),
              if (widget.catalogo != null)
                Dashboard(
                  catalogo: widget.catalogo,
                  searchController: searchController,
                  opcionSeleccionado: _opcionSeleccionada,
                  onOpcionChanged: (String? newValue) {
                    setState(() {
                      _opcionSeleccionada = newValue!;
                      print(_opcionSeleccionada);
                    });
                  },
                  isBackgroundSet: widget.isBackgroundSet,
                  imagePath: widget.imagePath,
                  changeLanguage: widget.changeLanguage,
                  idiomaDropDown: _idiomaActual,
                  temaClaro: widget.temaClaro,
                  baseUrl: widget.baseUrl,
                  onScrollToTop: desplazarScrollArriba,
                  onScrollToDown: desplazarScroll,
                  token: widget.token,
                  pUserName: widget.pUserName,
                  pEmpresa: widget.pEmpresa,
                  pEstacion_Trabajo: widget.pEstacion_Trabajo,
                  fechaSesion: widget.fechaSesion,
                  fechaExpiracion: widget.fechaExpiracion,
                  despEmpresa: widget.despEmpresa,
                  despEstacion_Trabajo: widget.despEstacion_Trabajo,
                  focusSearch: _focusSearch,
                ),
              if (widget.catalogo == null)
                PantallaInicio(
                  isBackgroundSet: widget.isBackgroundSet,
                  imagePath: widget.imagePath,
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
            ]),
            bottomNavigationBar: widget.catalogo != null
                ? Footer(
                    imagePath: widget.imagePath,
                    isBackgroundSet: widget.isBackgroundSet,
                    catalogo: widget.catalogo,
                    changeLanguage: widget.changeLanguage,
                    idiomaDropDown: _idiomaActual,
                    pUserName: widget.pUserName,
                    despEmpresa: widget.despEmpresa,
                    despEstacion_Trabajo: widget.despEstacion_Trabajo,
                    token: widget.token,
                    pEmpresa: widget.pEmpresa,
                    pEstacion_Trabajo: widget.pEstacion_Trabajo,
                    baseUrl: widget.baseUrl,
                    fechaSesion: widget.fechaSesion,
                    fechaExpiracion: widget.fechaExpiracion,
                  )
                : null,
            floatingActionButton: widget.catalogo != null
                ? AnimatedOpacity(
                    opacity: _isFabVisible ? 1.0 : 0.0,
                    duration: Duration(
                        milliseconds:
                            500), // Ajusta la duración para hacerla más suave
                    curve: Curves.easeInOut, // Curva para suavizar la animación
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Mantenimiento(
                                      isBackgroundSet: widget.isBackgroundSet,
                                      imagePath: widget.imagePath,
                                      changeLanguage: widget.changeLanguage,
                                      idiomaDropDown: widget.idiomaDropDown,
                                      temaClaro: themeNotifier.temaClaro,
                                      token: widget.token,
                                      pUserName: widget.pUserName,
                                      pEmpresa: widget.pEmpresa,
                                      pEstacion_Trabajo:
                                          widget.pEstacion_Trabajo,
                                      fechaSesion: widget.fechaSesion,
                                      baseUrl: widget.baseUrl,
                                      fechaExpiracion: widget.fechaExpiracion,
                                      despEmpresa: widget.despEmpresa,
                                      despEstacion_Trabajo:
                                          widget.despEstacion_Trabajo,
                                      catalogo: null,
                                    ))); // Acción del botón
                      },
                      backgroundColor: Color(0xFF004964),
                      child: Icon(Icons.home, size: 25, color: Colors.white),
                      tooltip: 'Regresar a Pantalla de Inicio',
                      mini: true,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Bordes más redondeados
                      ),
                    ),
                  )
                : null,
            floatingActionButtonLocation: FloatingActionButtonLocation
                .startFloat, // Lado inferior izquierdo
          ),
        ]));
  }
}
