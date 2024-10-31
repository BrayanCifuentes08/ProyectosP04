// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get locale {
    return Intl.message(
      'en',
      name: 'locale',
      desc: '',
      args: [],
    );
  }

  /// `You must enter the user`
  String get loginDebeIngresarElUsuario {
    return Intl.message(
      'You must enter the user',
      name: 'loginDebeIngresarElUsuario',
      desc: '',
      args: [],
    );
  }

  /// `You must enter the password`
  String get loginDebeIngresarLaContrasena {
    return Intl.message(
      'You must enter the password',
      name: 'loginDebeIngresarLaContrasena',
      desc: '',
      args: [],
    );
  }

  /// `Enter your URL here`
  String get loginIngresarURL {
    return Intl.message(
      'Enter your URL here',
      name: 'loginIngresarURL',
      desc: '',
      args: [],
    );
  }

  /// `Text copied to clipboard`
  String get loginTextoCopiado {
    return Intl.message(
      'Text copied to clipboard',
      name: 'loginTextoCopiado',
      desc: '',
      args: [],
    );
  }

  /// `The URL is valid and responding.`
  String get loginURLvalida {
    return Intl.message(
      'The URL is valid and responding.',
      name: 'loginURLvalida',
      desc: '',
      args: [],
    );
  }

  /// `The URL is not responding or invalid.`
  String get loginURLNoValida {
    return Intl.message(
      'The URL is not responding or invalid.',
      name: 'loginURLNoValida',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get loginVerificar {
    return Intl.message(
      'Verify',
      name: 'loginVerificar',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get loginConfirmar {
    return Intl.message(
      'Confirm',
      name: 'loginConfirmar',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginIniciarSesion {
    return Intl.message(
      'Login',
      name: 'loginIniciarSesion',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get loginUsuario {
    return Intl.message(
      'User',
      name: 'loginUsuario',
      desc: '',
      args: [],
    );
  }

  /// `Enter your user`
  String get loginIngresaUsuario {
    return Intl.message(
      'Enter your user',
      name: 'loginIngresaUsuario',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get loginContrasena {
    return Intl.message(
      'Password',
      name: 'loginContrasena',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get loginIngresaContrasena {
    return Intl.message(
      'Enter your password',
      name: 'loginIngresaContrasena',
      desc: '',
      args: [],
    );
  }

  /// `Save Session`
  String get loginGuardarSesion {
    return Intl.message(
      'Save Session',
      name: 'loginGuardarSesion',
      desc: '',
      args: [],
    );
  }

  /// `Select a workstation`
  String get loginSeleccionarEstacionTrabajo {
    return Intl.message(
      'Select a workstation',
      name: 'loginSeleccionarEstacionTrabajo',
      desc: '',
      args: [],
    );
  }

  /// `Select a company`
  String get loginSeleccionarEmpresa {
    return Intl.message(
      'Select a company',
      name: 'loginSeleccionarEmpresa',
      desc: '',
      args: [],
    );
  }

  /// `Select an application`
  String get loginSeleccionarAplicacion {
    return Intl.message(
      'Select an application',
      name: 'loginSeleccionarAplicacion',
      desc: '',
      args: [],
    );
  }

  /// `Select Displays`
  String get loginSeleccionarDisplay {
    return Intl.message(
      'Select Displays',
      name: 'loginSeleccionarDisplay',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get loginIngresar {
    return Intl.message(
      'Join',
      name: 'loginIngresar',
      desc: '',
      args: [],
    );
  }

  /// `If you swipe again, you will exit the application.`
  String get layoutSiVuelvesADeslizar {
    return Intl.message(
      'If you swipe again, you will exit the application.',
      name: 'layoutSiVuelvesADeslizar',
      desc: '',
      args: [],
    );
  }

  /// `Up`
  String get layoutSubir {
    return Intl.message(
      'Up',
      name: 'layoutSubir',
      desc: '',
      args: [],
    );
  }

  /// `Down`
  String get layoutBajar {
    return Intl.message(
      'Down',
      name: 'layoutBajar',
      desc: '',
      args: [],
    );
  }

  /// `Connection error`
  String get dashboardErrorConexion {
    return Intl.message(
      'Connection error',
      name: 'dashboardErrorConexion',
      desc: '',
      args: [],
    );
  }

  /// `The data could not be retrieved. Please check your connection and try again.`
  String get dashboardNoSePudoRecuperarLaInformacion {
    return Intl.message(
      'The data could not be retrieved. Please check your connection and try again.',
      name: 'dashboardNoSePudoRecuperarLaInformacion',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get dashboardReintentar {
    return Intl.message(
      'Retry',
      name: 'dashboardReintentar',
      desc: '',
      args: [],
    );
  }

  /// `Assign`
  String get dashboardAsignar {
    return Intl.message(
      'Assign',
      name: 'dashboardAsignar',
      desc: '',
      args: [],
    );
  }

  /// `Assign elements`
  String get dashboardAsignarElementos {
    return Intl.message(
      'Assign elements',
      name: 'dashboardAsignarElementos',
      desc: '',
      args: [],
    );
  }

  /// `Unassign`
  String get dashboardDesasignar {
    return Intl.message(
      'Unassign',
      name: 'dashboardDesasignar',
      desc: '',
      args: [],
    );
  }

  /// `Unassign elements`
  String get dashboardDesasignarElementos {
    return Intl.message(
      'Unassign elements',
      name: 'dashboardDesasignarElementos',
      desc: '',
      args: [],
    );
  }

  /// `Back to home`
  String get dashboardVolverAlInicio {
    return Intl.message(
      'Back to home',
      name: 'dashboardVolverAlInicio',
      desc: '',
      args: [],
    );
  }

  /// `There are no assigned elements`
  String get dashboardNoHayElementosAsignados {
    return Intl.message(
      'There are no assigned elements',
      name: 'dashboardNoHayElementosAsignados',
      desc: '',
      args: [],
    );
  }

  /// `has no element assigned to him.`
  String get dashboardNoTieneNingunElementoAsignado {
    return Intl.message(
      'has no element assigned to him.',
      name: 'dashboardNoTieneNingunElementoAsignado',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get dashboardRefrescar {
    return Intl.message(
      'Refresh',
      name: 'dashboardRefrescar',
      desc: '',
      args: [],
    );
  }

  /// `Search element...`
  String get dashboardBuscarElemento {
    return Intl.message(
      'Search element...',
      name: 'dashboardBuscarElemento',
      desc: '',
      args: [],
    );
  }

  /// `No. of elements assigned:`
  String get dashboardNoElementosAsignados {
    return Intl.message(
      'No. of elements assigned:',
      name: 'dashboardNoElementosAsignados',
      desc: '',
      args: [],
    );
  }

  /// `Session`
  String get dashboardSesion {
    return Intl.message(
      'Session',
      name: 'dashboardSesion',
      desc: '',
      args: [],
    );
  }

  /// `Expires`
  String get dashboardExpira {
    return Intl.message(
      'Expires',
      name: 'dashboardExpira',
      desc: '',
      args: [],
    );
  }

  /// `Element`
  String get asignadorElemento {
    return Intl.message(
      'Element',
      name: 'asignadorElemento',
      desc: '',
      args: [],
    );
  }

  /// `assigned correctly`
  String get asignadorAsignadoCorrectamente {
    return Intl.message(
      'assigned correctly',
      name: 'asignadorAsignadoCorrectamente',
      desc: '',
      args: [],
    );
  }

  /// `No. of unassigned elements:`
  String get asignadorNoElementosSinAsignar {
    return Intl.message(
      'No. of unassigned elements:',
      name: 'asignadorNoElementosSinAsignar',
      desc: '',
      args: [],
    );
  }

  /// `Deselect All`
  String get asignadorDeseleccionarTodos {
    return Intl.message(
      'Deselect All',
      name: 'asignadorDeseleccionarTodos',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get asignadorSeleccionarTodos {
    return Intl.message(
      'Select All',
      name: 'asignadorSeleccionarTodos',
      desc: '',
      args: [],
    );
  }

  /// `Clear selections`
  String get asignadorLimpiarSelecciones {
    return Intl.message(
      'Clear selections',
      name: 'asignadorLimpiarSelecciones',
      desc: '',
      args: [],
    );
  }

  /// `Selected elements`
  String get asignadorElementosSeleccionados {
    return Intl.message(
      'Selected elements',
      name: 'asignadorElementosSeleccionados',
      desc: '',
      args: [],
    );
  }

  /// `selected`
  String get asignadorSeleccionados {
    return Intl.message(
      'selected',
      name: 'asignadorSeleccionados',
      desc: '',
      args: [],
    );
  }

  /// `Element no.`
  String get asignadorElementoNo {
    return Intl.message(
      'Element no.',
      name: 'asignadorElementoNo',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Assignment`
  String get asignadorConfirmarAsignacion {
    return Intl.message(
      'Confirm Assignment',
      name: 'asignadorConfirmarAsignacion',
      desc: '',
      args: [],
    );
  }

  /// `correctly unassigned`
  String get desasignadorDesasignadoCorrectamente {
    return Intl.message(
      'correctly unassigned',
      name: 'desasignadorDesasignadoCorrectamente',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Unassignment`
  String get desasignadorConfirmarDesasignacion {
    return Intl.message(
      'Confirm Unassignment',
      name: 'desasignadorConfirmarDesasignacion',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get mensajesAdvertencia {
    return Intl.message(
      'Warning',
      name: 'mensajesAdvertencia',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get mensajesAceptar {
    return Intl.message(
      'Accept',
      name: 'mensajesAceptar',
      desc: '',
      args: [],
    );
  }

  /// `Confirm creation:`
  String get mensajesConfirmarCreacion {
    return Intl.message(
      'Confirm creation:',
      name: 'mensajesConfirmarCreacion',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get mensajesConfimar {
    return Intl.message(
      'Confirm',
      name: 'mensajesConfimar',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get mensajesCancelar {
    return Intl.message(
      'Cancel',
      name: 'mensajesCancelar',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get mensajesCerrarSesion {
    return Intl.message(
      'Log out',
      name: 'mensajesCerrarSesion',
      desc: '',
      args: [],
    );
  }

  /// `UserName`
  String get mensajesUsuario {
    return Intl.message(
      'UserName',
      name: 'mensajesUsuario',
      desc: '',
      args: [],
    );
  }

  /// `Session saved on`
  String get mensajesSesionGuardadaEl {
    return Intl.message(
      'Session saved on',
      name: 'mensajesSesionGuardadaEl',
      desc: '',
      args: [],
    );
  }

  /// `Session expires on`
  String get mensajesSesionExpiraEl {
    return Intl.message(
      'Session expires on',
      name: 'mensajesSesionExpiraEl',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to assign this item?`
  String get mensajesDeseaAsignarEsteElemento {
    return Intl.message(
      'Do you want to assign this item?',
      name: 'mensajesDeseaAsignarEsteElemento',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to unassign this item?`
  String get mensajesDeseaDesasignarEsteElemento {
    return Intl.message(
      'Do you want to unassign this item?',
      name: 'mensajesDeseaDesasignarEsteElemento',
      desc: '',
      args: [],
    );
  }

  /// `Assigned Elements`
  String get splashElementosAsignados {
    return Intl.message(
      'Assigned Elements',
      name: 'splashElementosAsignados',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Catalog Maintenance System`
  String get inicioBienvenido {
    return Intl.message(
      'Welcome to the Catalog Maintenance System',
      name: 'inicioBienvenido',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get inicioCerrarSesion {
    return Intl.message(
      'Logout',
      name: 'inicioCerrarSesion',
      desc: '',
      args: [],
    );
  }

  /// `Login time:`
  String get inicioHoraDeInicioSesion {
    return Intl.message(
      'Login time:',
      name: 'inicioHoraDeInicioSesion',
      desc: '',
      args: [],
    );
  }

  /// `The session expires:`
  String get inicioLaSesionExpira {
    return Intl.message(
      'The session expires:',
      name: 'inicioLaSesionExpira',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get inicioInicio {
    return Intl.message(
      'Home',
      name: 'inicioInicio',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance`
  String get drawerMantenimiento {
    return Intl.message(
      'Maintenance',
      name: 'drawerMantenimiento',
      desc: '',
      args: [],
    );
  }

  /// `MAINTENANCE`
  String get drawerManetenimientoMayus {
    return Intl.message(
      'MAINTENANCE',
      name: 'drawerManetenimientoMayus',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get drawerIdioma {
    return Intl.message(
      'Language',
      name: 'drawerIdioma',
      desc: '',
      args: [],
    );
  }

  /// `TEMPLATE`
  String get drawerPlantilla {
    return Intl.message(
      'TEMPLATE',
      name: 'drawerPlantilla',
      desc: '',
      args: [],
    );
  }

  /// `Loading data...`
  String get loadingCargando {
    return Intl.message(
      'Loading data...',
      name: 'loadingCargando',
      desc: '',
      args: [],
    );
  }

  /// `Select Template`
  String get seleccionFondoSeleccionarPlantilla {
    return Intl.message(
      'Select Template',
      name: 'seleccionFondoSeleccionarPlantilla',
      desc: '',
      args: [],
    );
  }

  /// `Remove Background`
  String get seleccionFondoQuitarFondo {
    return Intl.message(
      'Remove Background',
      name: 'seleccionFondoQuitarFondo',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
