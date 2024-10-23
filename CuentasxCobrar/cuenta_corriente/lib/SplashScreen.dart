import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_cuenta_corriente/Login.dart';
import 'package:test_cuenta_corriente/TablaCliente.dart';
import 'package:test_cuenta_corriente/generated/l10n.dart';
import 'package:test_cuenta_corriente/services/LoginService.dart';

class SplashScreen extends StatefulWidget {
  final Function(Locale) changeLanguage;
  final Function(String) changeBackgroundImage;
  final Function loadPreferences;
  final Locale seleccionarIdioma;
  final String imagePath;
  final bool isBackgroundSet;

  SplashScreen({
    required this.changeLanguage,
    required this.seleccionarIdioma,
    required this.imagePath,
    required this.isBackgroundSet,
    required this.loadPreferences,
    required this.changeBackgroundImage,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animacionController;
  late Animation<double> _animacion;
  late LoginService _loginService;

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

  Future<void> _checkSession() async {
    final sessionData = await _loginService.getUserSession();

    // Redirige dependiendo si hay un token guardado o no
    if (sessionData['token'] != '') {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return TablaCliente(
              // Pasa los argumentos necesarios a TablaCliente

              token: sessionData['token'],
              pUserName: sessionData['username'],
              pEmpresa: sessionData['empresa'],
              pEstacion_Trabajo: sessionData['estacionTrabajo'],
              changeLanguage: widget.changeLanguage,
              seleccionarIdioma: widget.seleccionarIdioma,
              idiomaDropDown: widget.seleccionarIdioma,
              baseUrl: sessionData['urlBase'],
              temaClaro: true,
              imagePath: widget.imagePath,
              isBackgroundSet: widget.isBackgroundSet,
              fechaSesion: sessionData['fecha'],
              fechaExpiracion: sessionData['fechaExpiracion'],
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
              seleccionarIdioma: widget.seleccionarIdioma,
              idiomaDropDown: widget.seleccionarIdioma,
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

  @override
  void dispose() {
    _animacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final logoSize = screenSize.width * 0.4;
    final textSize = screenSize.width * 0.08;
    final spinnerSize = screenSize.width * 0.15;

    return Scaffold(
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
                      color: Colors.white, // Cambiar el color del logo a blanco
                    ),

                    SizedBox(
                        height:
                            screenSize.height * 0.05), // Ajustar el espaciado

                    // Título responsive
                    Text(
                      S.of(context).tituloMenu,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: textSize.clamp(18.0, 36.0), // Limitar tamaño
                      ),
                    ),

                    SizedBox(
                        height: screenSize.height * 0.1), // Ajustar espaciado

                    // Spinner responsive
                    SpinKitFadingCube(
                      color: Colors.white,
                      size: spinnerSize.clamp(40.0, 80.0), // Tamaño con límites
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
