import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:test_cuenta_corriente/CreacionRecibo.dart';
import 'package:test_cuenta_corriente/DocPendientesPago.dart';
import 'package:test_cuenta_corriente/Login.dart';
import 'package:test_cuenta_corriente/PlantillaImagen.dart';
import 'package:test_cuenta_corriente/SeleccionFondo.dart';
import 'package:test_cuenta_corriente/SplashScreen.dart';
import 'package:test_cuenta_corriente/TablaCliente.dart';
import 'package:test_cuenta_corriente/services/LoginService.dart';
import 'package:test_cuenta_corriente/services/PreferenciasService.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GRecaptchaV3.ready('6LeEnzYqAAAAAH4ZTLA0Xb8HnZJuS1xjoGL6gcgZ');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('es', 'ES');
  String _backgroundImagePath = 'assets/Fondos/background2.jpg';
  bool _isBackgroundSet = false;
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
    print(
        'Loaded background image path: $imagePath'); // Agregado para depuración
    setState(() {
      _backgroundImagePath = imagePath ?? _backgroundImagePath;
      _isBackgroundSet = isSet;
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
                    changeLanguage: _changeLanguage,
                    seleccionarIdioma: _locale,
                    imagePath: _backgroundImagePath,
                    isBackgroundSet: _isBackgroundSet,
                    loadPreferences: _loadPreferences,
                    changeBackgroundImage: _changeBackgroundImage,
                  ),
                ],
              ),
          '/cliente': (context) => Stack(
                children: [
                  BackgroundImage(imagePath: _backgroundImagePath),
                  TablaCliente(
                    pUserName: '',
                    pEmpresa: 1,
                    pEstacion_Trabajo: 1,
                    changeLanguage: _changeLanguage,
                    seleccionarIdioma: _locale,
                    idiomaDropDown: _locale,
                    baseUrl: '',
                    token: '',
                    temaClaro: true,
                    imagePath: _backgroundImagePath,
                    isBackgroundSet: _isBackgroundSet,
                    fechaSesion: DateTime.now(),
                    fechaExpiracion: null,
                  ),
                ],
              ),
          '/docspendientes': (context) => Stack(children: [
                BackgroundImage(imagePath: _backgroundImagePath),
                TablaDocsPendientes(
                  seleccionadoCuentaCorrentista: 1,
                  seleccionadoCuentaCta: '',
                  facturaNombre: '',
                  facturaNit: '',
                  facturaDireccion: '',
                  ccDireccion: '',
                  telefono: '',
                  pUserName: '',
                  pEmpresa: 1,
                  pEstacion_Trabajo: 1,
                  changeLanguage: _changeLanguage,
                  seleccionarIdioma: _locale,
                  idiomaDropDown: _locale,
                  baseUrl: '',
                  token: '',
                  temaClaro: true,
                  imagePath: _backgroundImagePath,
                  isBackgroundSet: _isBackgroundSet,
                  fechaSesion: DateTime.now(),
                  tokenSesionGuardada: false,
                  imageLogo: '',
                  verificarCaptcha: false,
                  fechaExpiracion: null,
                ),
              ]),
          '/creacionRecibo': (context) => Stack(children: [
                BackgroundImage(imagePath: _backgroundImagePath),
                CreacionRecibo(
                  selectedOpc_Cuenta_Corriente: 0,
                  selectedCuenta_Corriente: 0,
                  selectedEmpresa: 0,
                  selectedEstacionTrabajo: 0,
                  selectedUserName: '',
                  selectedpT_Filtro_6: false,
                  selectedbGrupo: 0,
                  selectedpDocumento_Conv: false,
                  selectedpFE_Tipo: false,
                  selectedpPOS_Tipo: 0,
                  selectedpVer_FE: false,
                  selectedIdCuenta: '',
                  pUserName: '',
                  pEmpresa: 1,
                  pEstacion_Trabajo: 1,
                  selectedCuentaCta: "",
                  selectedCuentaCorrentista: 1,
                  facturaNombre: '',
                  facturaNit: '',
                  facturaDireccion: '',
                  montosGuardados: [],
                  documentosSeleccionados: [],
                  montosGuardadosAcumulados: [],
                  documentosSeleccionadosAcumulados: [],
                  ccDireccion: '',
                  telefono: '',
                  changeLanguage: _changeLanguage,
                  seleccionarIdioma: _locale,
                  idiomaDropDown: _locale,
                  baseUrl: '',
                  token: '',
                  temaClaro: true,
                  imagePath: _backgroundImagePath,
                  isBackgroundSet: _isBackgroundSet,
                  fechaSesion: DateTime.now(),
                  tokenSesionGuardada: false,
                  imageLogo: '',
                  fechaExpiracion: null,
                ),
              ]),
          '/login': (context) => Stack(children: [
                BackgroundImage(imagePath: _backgroundImagePath),
                LoginScreen(
                  changeLanguage: _changeLanguage,
                  seleccionarIdioma: _locale,
                  idiomaDropDown: _locale,
                  imagePath: _backgroundImagePath,
                  isBackgroundSet: _isBackgroundSet,
                )
              ]),
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
