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

  /// `Type Distribution Channel`
  String get paBscCanalDistribucionMTipoCanalDistribucion {
    return Intl.message(
      'Type Distribution Channel',
      name: 'paBscCanalDistribucionMTipoCanalDistribucion',
      desc: '',
      args: [],
    );
  }

  /// `Winery`
  String get paBscCanalDistribucionMBodega {
    return Intl.message(
      'Winery',
      name: 'paBscCanalDistribucionMBodega',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get paBscCanalDistribucionMDescripcion {
    return Intl.message(
      'Description',
      name: 'paBscCanalDistribucionMDescripcion',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get paBscCanalDistribucionMEstado {
    return Intl.message(
      'State',
      name: 'paBscCanalDistribucionMEstado',
      desc: '',
      args: [],
    );
  }

  /// `Date and Time`
  String get paBscCanalDistribucionMFechayHora {
    return Intl.message(
      'Date and Time',
      name: 'paBscCanalDistribucionMFechayHora',
      desc: '',
      args: [],
    );
  }

  /// `UserName`
  String get paBscCanalDistribucionMUserName {
    return Intl.message(
      'UserName',
      name: 'paBscCanalDistribucionMUserName',
      desc: '',
      args: [],
    );
  }

  /// `Type Distribution Channel`
  String get paBscTipoCanalDistribucionMTipoCanalDistribucion {
    return Intl.message(
      'Type Distribution Channel',
      name: 'paBscTipoCanalDistribucionMTipoCanalDistribucion',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get paBscTipoCanalDistribucionMDescripcion {
    return Intl.message(
      'Description',
      name: 'paBscTipoCanalDistribucionMDescripcion',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get paBscTipoCanalDistribucionMEstado {
    return Intl.message(
      'State',
      name: 'paBscTipoCanalDistribucionMEstado',
      desc: '',
      args: [],
    );
  }

  /// `Date and Time`
  String get paBscTipoCanalDistribucionMFechayHora {
    return Intl.message(
      'Date and Time',
      name: 'paBscTipoCanalDistribucionMFechayHora',
      desc: '',
      args: [],
    );
  }

  /// `UserName`
  String get paBscTipoCanalDistribucionMUserName {
    return Intl.message(
      'UserName',
      name: 'paBscTipoCanalDistribucionMUserName',
      desc: '',
      args: [],
    );
  }

  /// `Viewing catalog:`
  String get dashboardVisualizandoCatalogo {
    return Intl.message(
      'Viewing catalog:',
      name: 'dashboardVisualizandoCatalogo',
      desc: '',
      args: [],
    );
  }

  /// `Viewing record:`
  String get dashboardVisualizandoRegistro {
    return Intl.message(
      'Viewing record:',
      name: 'dashboardVisualizandoRegistro',
      desc: '',
      args: [],
    );
  }

  /// `Adding record`
  String get dashboardAgregandoRegistro {
    return Intl.message(
      'Adding record',
      name: 'dashboardAgregandoRegistro',
      desc: '',
      args: [],
    );
  }

  /// `The following fields are empty:`
  String get dashboardLosSiguientesCamposEstanVacios {
    return Intl.message(
      'The following fields are empty:',
      name: 'dashboardLosSiguientesCamposEstanVacios',
      desc: '',
      args: [],
    );
  }

  /// `Empty Fields`
  String get dashboardCamposVacios {
    return Intl.message(
      'Empty Fields',
      name: 'dashboardCamposVacios',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get dashboardAceptar {
    return Intl.message(
      'Accept',
      name: 'dashboardAceptar',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get dashboardConfirmar {
    return Intl.message(
      'Confirm',
      name: 'dashboardConfirmar',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to insert this record?`
  String get dashboardDeseaInsertarEsteRegistro {
    return Intl.message(
      'Do you want to insert this record?',
      name: 'dashboardDeseaInsertarEsteRegistro',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get dashboardInsertar {
    return Intl.message(
      'Enter',
      name: 'dashboardInsertar',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to update this record?`
  String get dashboardDeseaActualizarEsteRegistro {
    return Intl.message(
      'Do you want to update this record?',
      name: 'dashboardDeseaActualizarEsteRegistro',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get dashboardActualizar {
    return Intl.message(
      'Update',
      name: 'dashboardActualizar',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this record?`
  String get dashboardDeseaEliminarEsteRegistro {
    return Intl.message(
      'Do you want to delete this record?',
      name: 'dashboardDeseaEliminarEsteRegistro',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get dashboardEliminar {
    return Intl.message(
      'Delete',
      name: 'dashboardEliminar',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get dashboardError {
    return Intl.message(
      'Error',
      name: 'dashboardError',
      desc: '',
      args: [],
    );
  }

  /// `Select a catalog`
  String get dashboardSeleccionaUnCatalogo {
    return Intl.message(
      'Select a catalog',
      name: 'dashboardSeleccionaUnCatalogo',
      desc: '',
      args: [],
    );
  }

  /// `Search Registration`
  String get dashboardBuscarRegistro {
    return Intl.message(
      'Search Registration',
      name: 'dashboardBuscarRegistro',
      desc: '',
      args: [],
    );
  }

  /// `Clicking this button,\nwill perform a search with\nthe entered search criteria.`
  String get dashboardSeRealizaraUnaBusqueda {
    return Intl.message(
      'Clicking this button,\nwill perform a search with\nthe entered search criteria.',
      name: 'dashboardSeRealizaraUnaBusqueda',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get dashboardBuscar {
    return Intl.message(
      'Search...',
      name: 'dashboardBuscar',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get dashboardAgregar {
    return Intl.message(
      'Add',
      name: 'dashboardAgregar',
      desc: '',
      args: [],
    );
  }

  /// `Clicking this button,\nwill enable the empty inputs to \ncomplete the required information.`
  String get dashboardSeHabilitaranLosInputs {
    return Intl.message(
      'Clicking this button,\nwill enable the empty inputs to \ncomplete the required information.',
      name: 'dashboardSeHabilitaranLosInputs',
      desc: '',
      args: [],
    );
  }

  /// `Refresh catalog`
  String get dashboardRefrescarCatalogo {
    return Intl.message(
      'Refresh catalog',
      name: 'dashboardRefrescarCatalogo',
      desc: '',
      args: [],
    );
  }

  /// `Clear selection`
  String get dashboardLimpiarSeleccion {
    return Intl.message(
      'Clear selection',
      name: 'dashboardLimpiarSeleccion',
      desc: '',
      args: [],
    );
  }

  /// `Clicking this button, \nwill remove the current selections and \nupdate the list of records.`
  String get dashboardSeEliminaranSelecciones {
    return Intl.message(
      'Clicking this button, \nwill remove the current selections and \nupdate the list of records.',
      name: 'dashboardSeEliminaranSelecciones',
      desc: '',
      args: [],
    );
  }

  /// `Number of records`
  String get dashboardNumeroDeRegistros {
    return Intl.message(
      'Number of records',
      name: 'dashboardNumeroDeRegistros',
      desc: '',
      args: [],
    );
  }

  /// `Save Record`
  String get dashboardGuardarRegistro {
    return Intl.message(
      'Save Record',
      name: 'dashboardGuardarRegistro',
      desc: '',
      args: [],
    );
  }

  /// `Clicking this button\nwill save the record.`
  String get dashboardSeGuardaraElRegistro {
    return Intl.message(
      'Clicking this button\nwill save the record.',
      name: 'dashboardSeGuardaraElRegistro',
      desc: '',
      args: [],
    );
  }

  /// `Clicking this button\nwill delete the record.`
  String get dashboardSeEliminaraElRegistro {
    return Intl.message(
      'Clicking this button\nwill delete the record.',
      name: 'dashboardSeEliminaraElRegistro',
      desc: '',
      args: [],
    );
  }

  /// `Clicking this button\nwill update the record.`
  String get dashboardSeActualizaraElRegistro {
    return Intl.message(
      'Clicking this button\nwill update the record.',
      name: 'dashboardSeActualizaraElRegistro',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get dashboardInformacion {
    return Intl.message(
      'Information',
      name: 'dashboardInformacion',
      desc: '',
      args: [],
    );
  }

  /// `Pressing the card \nwill display the complete \nregistration information.`
  String get dashboardSeMostraraInformacion {
    return Intl.message(
      'Pressing the card \nwill display the complete \nregistration information.',
      name: 'dashboardSeMostraraInformacion',
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
