import 'package:flutter/material.dart';
import 'package:test_traslado_datos/splash_screen.dart';
import 'package:test_traslado_datos/trasladar_datos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFDD952A),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: Color.fromARGB(246, 255, 255, 255),
          primary: Color(0xFFDD952A),
          secondary: Color(0xFFDD952A),
        ),
      ),
      initialRoute: '/inicio',
      routes: {
        '/inicio': (context) => SplashScreen(),
        '/trasladar': (context) => TrasladarDatosScreen(),
      },
    ));
  }
}
