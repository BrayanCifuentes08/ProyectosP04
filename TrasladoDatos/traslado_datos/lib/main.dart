import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:traslado_datos/common/CatalogoProvider.dart';
import 'package:traslado_datos/common/IdiomaNotifier.dart';
import 'package:traslado_datos/common/ThemeNotifier.dart';
import 'package:traslado_datos/components/Login.dart';
import 'package:traslado_datos/components/Plantillas/PlantillaImagen.dart';
import 'package:traslado_datos/components/Plantillas/SeleccionFondo.dart';
import 'package:traslado_datos/components/SplashScreen.dart';
import 'package:traslado_datos/services/LoginService.dart';
import 'package:traslado_datos/services/PreferenciasService.dart';
import 'package:traslado_datos/services/Shared.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => CatalogoProvider()),
        ChangeNotifierProvider(create: (context) => AccionService()),
        ChangeNotifierProvider(create: (context) => IdiomaNotifier())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('es', 'ES');
  String _backgroundImagePath = 'assets/Fondos/background2.jpg';
  bool _isBackgroundSet = false;
  bool _temaClaro = false;
  final PreferenciasService _preferencesService = PreferenciasService();
  final LoginService _loginService = LoginService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkSession() async {
    final sessionData = await _loginService.getUserSession();
    final tokenExpirationString = sessionData['tokenExpiration'] as String?;
    if (tokenExpirationString != null) {
      final tokenExpiration = DateTime.parse(tokenExpirationString);
      if (DateTime.now().isAfter(tokenExpiration)) {
        // Si la sesión ha expirado, redirigir al usuario
        Navigator.of(context).pushReplacementNamed('/inicio');
      } else {
        // Si la sesión es válida, cargar las preferencias de fondo
        _loadPreferences();
      }
    } else {
      // Si no hay datos de sesión, cargar las preferencias de fondo
      _loadPreferences();
    }
  }

  void _loadPreferences() async {
    final imagePath = await _preferencesService.getBackgroundImage();
    final isSet = await _preferencesService.isBackgroundSet();
    final temaClaro = await _preferencesService.getTemaClaro();
    print(
        'Loaded background image path: $imagePath'); // Agregado para depuración
    setState(() {
      _backgroundImagePath = imagePath ?? _backgroundImagePath;
      _isBackgroundSet = isSet;
      _temaClaro = temaClaro;
    });
  }

  void _changeBackgroundImage(String imagePath) {
    print(
        'Changing background image to: $imagePath'); // Agregado para depuración
    setState(() {
      _backgroundImagePath = imagePath;
      _isBackgroundSet = imagePath.isNotEmpty;
    });
    _preferencesService.saveBackgroundImage(imagePath);
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

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
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateColor.resolveWith(
              (states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.teal.shade300;
                }
                return const Color.fromARGB(255, 255, 255, 255);
              },
            ),
          ),
        ),
        initialRoute: '/inicio',
        routes: {
          '/inicio': (context) => Stack(
                children: [
                  if (_isBackgroundSet)
                    BackgroundImage(imagePath: _backgroundImagePath),
                  SplashScreen(
                    imagePath: _backgroundImagePath,
                    isBackgroundSet: _isBackgroundSet,
                    loadPreferences: _loadPreferences,
                    changeBackgroundImage: _changeBackgroundImage,
                    changeLanguage: _changeLanguage,
                    idiomaDropDown: _locale,
                    temaClaro: _temaClaro,
                  ),
                ],
              ),
          // '/mantenimiento': (context) => Stack(
          //       children: [
          //         Mantenimiento(
          //           imagePath: _backgroundImagePath,
          //           isBackgroundSet: _isBackgroundSet,
          //           catalogo: null,
          //           changeLanguage: _changeLanguage,
          //           idiomaDropDown: _locale,
          //           temaClaro: _temaClaro,
          //           token: '',
          //           pUserName: '',
          //           pEmpresa: 1,
          //           pEstacion_Trabajo: 1,
          //           baseUrl: '',
          //           fechaSesion: DateTime.now(),
          //           fechaExpiracion: null,
          //           despEmpresa: '',
          //           despEstacion_Trabajo: '',
          //           pApplication: 1,
          //         ),
          //       ],
          //     ),
          // '/login': (context) => Stack(children: [
          //       BackgroundImage(imagePath: _backgroundImagePath),
          //       LoginScreen(
          //         changeLanguage: _changeLanguage,
          //         seleccionarIdioma: _locale,
          //         idiomaDropDown: _locale,
          //         imagePath: _backgroundImagePath,
          //         isBackgroundSet: _isBackgroundSet,
          //       )
          //     ]),
          '/selectBackground': (context) => SeleccionFondo(
                onSelectBackground: _changeBackgroundImage,
              ),
        },
        locale: _locale,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
