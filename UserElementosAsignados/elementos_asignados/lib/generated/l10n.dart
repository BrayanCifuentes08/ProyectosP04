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

  /// `Maintenance`
  String get splashMantenimiento {
    return Intl.message(
      'Maintenance',
      name: 'splashMantenimiento',
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
