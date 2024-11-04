import 'package:elementos_asignados/common/FloatingActionButtonNotifier.dart';
import 'package:elementos_asignados/common/IdiomaNotifier.dart';
import 'package:elementos_asignados/common/ThemeNotifier.dart';
import 'package:elementos_asignados/components/Plantillas/PlantillaImagen.dart';
import 'package:elementos_asignados/components/Plantillas/SeleccionFondo.dart';
import 'package:elementos_asignados/components/SplashScreen.dart';
import 'package:elementos_asignados/generated/l10n.dart';
import 'package:elementos_asignados/services/LoginService.dart';
// import 'package:elementos_asignados/services/LoginService.dart';
import 'package:elementos_asignados/services/PreferenciasService.dart';
import 'package:elementos_asignados/services/Shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(
            create: (context) => FloatingActionButtonNotifier()),
        ChangeNotifierProvider(create: (context) => AccionService()),
        ChangeNotifierProvider(create: (context) => IdiomaNotifier()),
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
        _loadPreferences();
      }
    } else {
      _loadPreferences();
    }
  }

  void _loadPreferences() async {
    final imagePath = await _preferencesService.getBackgroundImage();
    final isSet = await _preferencesService.isBackgroundSet();
    final temaClaro = await _preferencesService.getTemaClaro();
    print('Loaded background image path: $imagePath');
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
