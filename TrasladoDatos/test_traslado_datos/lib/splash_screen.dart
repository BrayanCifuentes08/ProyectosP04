import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:test_traslado_datos/trasladar_datos.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animacionController;
  late Animation<double> _animacion;

  @override
  void initState() {
    super.initState();
    _animacionController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animacion = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animacionController);
    _animacionController.forward();

    _animacionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return TrasladarDatosScreen();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDD952A),
      body: Center(
        child: FadeTransition(
          opacity: _animacion,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 180.0,
                width: 180.0,
                color: Colors.white, // Cambiar el color del logo a blanco
              ),
              SizedBox(height: 30),
              Text(
                "Traslado Datos",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(height: 50),
              SpinKitFadingCube(
                color: Colors.white,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
