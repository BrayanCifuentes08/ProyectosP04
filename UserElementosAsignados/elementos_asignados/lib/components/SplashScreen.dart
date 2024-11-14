import 'package:elementos_asignados/components/Layout.dart';
import 'package:elementos_asignados/components/Login.dart';
import 'package:elementos_asignados/generated/l10n.dart';
import 'package:elementos_asignados/services/LoginService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  final Function(String) changeBackgroundImage;
  final Function loadPreferences;
  final String imagePath;
  final bool isBackgroundSet;
  final Function(Locale) changeLanguage;
  Locale idiomaDropDown;
  final bool temaClaro;

  SplashScreen({
    required this.imagePath,
    required this.isBackgroundSet,
    required this.loadPreferences,
    required this.changeBackgroundImage,
    required this.changeLanguage,
    required this.idiomaDropDown,
    required this.temaClaro,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animacionController;
  late Animation<double> _animacion;
  late LoginService _loginService;
  int _backGestureCount = 0;

  @override
  void initState() {
    super.initState();
    _animacionController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _animacion = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animacionController);
    _animacionController.forward();

    _animacionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _loginService = LoginService();

        _checkSession();
      }
    });
  }

  @override
  void dispose() {
    _animacionController.dispose();
    super.dispose();
  }

  Future<void> _checkSession() async {
    final sessionData = await _loginService.getUserSession();

    //Redirige dependiendo si hay un token guardado o no
    if (sessionData['token'] != '') {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return Layout(
              imagePath: widget.imagePath,
              isBackgroundSet: widget.isBackgroundSet,
              changeLanguage: widget.changeLanguage,
              idiomaDropDown: widget.idiomaDropDown,
              temaClaro: widget.temaClaro,
              token: sessionData['token'],
              pUserName: sessionData['username'],
              pEmpresa: sessionData['empresa'],
              pEstacion_Trabajo: sessionData['estacionTrabajo'],
              baseUrl: sessionData['urlBase'],
              fechaSesion: sessionData['fecha'],
              fechaExpiracion: sessionData['fechaExpiracion'],
              despEmpresa: sessionData['desEmpresa'],
              despEstacion_Trabajo: sessionData['desEstacionTrabajo'],
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return LoginScreen(
              changeLanguage: widget.changeLanguage,
              seleccionarIdioma: widget.idiomaDropDown,
              idiomaDropDown: widget.idiomaDropDown,
              imagePath: widget.imagePath,
              isBackgroundSet: widget.isBackgroundSet,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
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
    final screenSize = MediaQuery.of(context).size;
    final logoSize = screenSize.width * 0.4;
    final textSize = screenSize.width * 0.08;
    final spinnerSize = screenSize.width * 0.15;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: widget.isBackgroundSet
              ? Color.fromARGB(0, 21, 70, 144)
              : Color(0xFF154790),
          body: LayoutBuilder(
            // Utilizamos LayoutBuilder para obtener el tamaño disponible
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: FadeTransition(
                    opacity: _animacion,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: screenSize.height *
                                0.05), // Separación inicial ajustada

                        // Logo responsive
                        Image.asset(
                          'assets/logo.png',
                          height: logoSize,
                          width: logoSize,
                          color: Colors
                              .white, // Cambiar el color del logo a blanco
                        ),
                        SizedBox(
                            height: screenSize.height *
                                0.05), // Ajustar el espaciado
                        // Título responsive
                        Text(
                          S.of(context).splashElementosAsignados,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                textSize.clamp(18.0, 36.0), // Limitar tamaño
                          ),
                        ),

                        SizedBox(
                            height:
                                screenSize.height * 0.1), // Ajustar espaciado

                        // Spinner responsive
                        SpinKitFadingCube(
                          color: Colors.white,
                          size: spinnerSize.clamp(
                              40.0, 80.0), // Tamaño con límites
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
