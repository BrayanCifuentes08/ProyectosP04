import 'package:elementos_asignados/common/FloatingActionButtonNotifier.dart';
import 'package:elementos_asignados/common/ThemeNotifier.dart';
import 'package:elementos_asignados/components/Dashboard.dart';
import 'package:elementos_asignados/components/Drawer.dart';
import 'package:elementos_asignados/generated/l10n.dart';
import 'package:elementos_asignados/services/Shared.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accionService = Provider.of<AccionService>(context, listen: false);
      accionService.setAccion("${S.of(context).inicioInicio}");
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

  //WIDGET PRINCIPAL
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final fabNotifier = Provider.of<FloatingActionButtonNotifier>(context);
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
            Dashboard(
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
          //BOTÓN FLOTANTE PARA SUBIR O BAJAR
          floatingActionButton: fabNotifier.buttonState == 0
              ? null // No mostrar el botón
              : FloatingActionButton(
                  onPressed: () {
                    if (fabNotifier.buttonState == 1) {
                      desplazarScroll();
                      fabNotifier.setButtonState(2);
                    } else if (fabNotifier.buttonState == 2) {
                      desplazarScrollArriba();
                      fabNotifier.setButtonState(1);
                    }
                  },
                  backgroundColor: Color(0xFF004964),
                  child: Icon(
                    fabNotifier.buttonState == 1
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    size: 25,
                    color: Colors.white,
                  ),
                  tooltip: fabNotifier.buttonState == 1
                      ? S.of(context).layoutSubir
                      : S.of(context).layoutBajar,
                  mini: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
        ),
      ]),
    );
  }
}
