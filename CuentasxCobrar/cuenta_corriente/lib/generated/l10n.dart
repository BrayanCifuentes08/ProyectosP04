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

  /// `If you swipe again, you will exit the application.`
  String get siVuelvesADeslizar {
    return Intl.message(
      'If you swipe again, you will exit the application.',
      name: 'siVuelvesADeslizar',
      desc: '',
      args: [],
    );
  }

  /// `If you swipe again, you will exit the application, be sure to save the pdf by printing or sharing it.`
  String get siVuelvesADeslizarPdf {
    return Intl.message(
      'If you swipe again, you will exit the application, be sure to save the pdf by printing or sharing it.',
      name: 'siVuelvesADeslizarPdf',
      desc: '',
      args: [],
    );
  }

  /// `Loading data...`
  String get cargando {
    return Intl.message(
      'Loading data...',
      name: 'cargando',
      desc: '',
      args: [],
    );
  }

  /// `Accounts Receivable`
  String get tituloMenu {
    return Intl.message(
      'Accounts Receivable',
      name: 'tituloMenu',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get iniciarSesion {
    return Intl.message(
      'Login',
      name: 'iniciarSesion',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get usuarioLogin {
    return Intl.message(
      'User',
      name: 'usuarioLogin',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get contrasenaLogin {
    return Intl.message(
      'Password',
      name: 'contrasenaLogin',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get ingresaContrasena {
    return Intl.message(
      'Enter your password',
      name: 'ingresaContrasena',
      desc: '',
      args: [],
    );
  }

  /// `Enter your user`
  String get ingresaUsuario {
    return Intl.message(
      'Enter your user',
      name: 'ingresaUsuario',
      desc: '',
      args: [],
    );
  }

  /// `Select a workstation`
  String get seleccionarEstacionTrabajo {
    return Intl.message(
      'Select a workstation',
      name: 'seleccionarEstacionTrabajo',
      desc: '',
      args: [],
    );
  }

  /// `Select a company`
  String get seleccionarEmpresa {
    return Intl.message(
      'Select a company',
      name: 'seleccionarEmpresa',
      desc: '',
      args: [],
    );
  }

  /// `Select an application`
  String get seleccionarAplicacion {
    return Intl.message(
      'Select an application',
      name: 'seleccionarAplicacion',
      desc: '',
      args: [],
    );
  }

  /// `Select Displays`
  String get seleccionarDisplay {
    return Intl.message(
      'Select Displays',
      name: 'seleccionarDisplay',
      desc: '',
      args: [],
    );
  }

  /// `Enter your URL here`
  String get ingresarURL {
    return Intl.message(
      'Enter your URL here',
      name: 'ingresarURL',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verificar {
    return Intl.message(
      'Verify',
      name: 'verificar',
      desc: '',
      args: [],
    );
  }

  /// `The URL is valid and responding.`
  String get URLvalida {
    return Intl.message(
      'The URL is valid and responding.',
      name: 'URLvalida',
      desc: '',
      args: [],
    );
  }

  /// `The URL is not responding or invalid.`
  String get URLNoValida {
    return Intl.message(
      'The URL is not responding or invalid.',
      name: 'URLNoValida',
      desc: '',
      args: [],
    );
  }

  /// `CLIENTS SEARCH`
  String get busquedaClienteMenu {
    return Intl.message(
      'CLIENTS SEARCH',
      name: 'busquedaClienteMenu',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get idiomaMenu {
    return Intl.message(
      'Language',
      name: 'idiomaMenu',
      desc: '',
      args: [],
    );
  }

  /// `Guide Errors`
  String get guiaErrores {
    return Intl.message(
      'Guide Errors',
      name: 'guiaErrores',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get ayudaMenu {
    return Intl.message(
      'Help',
      name: 'ayudaMenu',
      desc: '',
      args: [],
    );
  }

  /// `Client Table`
  String get tablaClientes {
    return Intl.message(
      'Client Table',
      name: 'tablaClientes',
      desc: '',
      args: [],
    );
  }

  /// `Enter criteria...`
  String get ingresarCriterio {
    return Intl.message(
      'Enter criteria...',
      name: 'ingresarCriterio',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get buscar {
    return Intl.message(
      'Search',
      name: 'buscar',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get selectCliente {
    return Intl.message(
      'Select',
      name: 'selectCliente',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Name`
  String get facturaNombreCliente {
    return Intl.message(
      'Invoice Name',
      name: 'facturaNombreCliente',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get cuentaCliente {
    return Intl.message(
      'Account',
      name: 'cuentaCliente',
      desc: '',
      args: [],
    );
  }

  /// `Cta`
  String get ctaCliente {
    return Intl.message(
      'Cta',
      name: 'ctaCliente',
      desc: '',
      args: [],
    );
  }

  /// `Invoice NIT`
  String get facturaNitCliente {
    return Intl.message(
      'Invoice NIT',
      name: 'facturaNitCliente',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Address`
  String get facturaDireccionCliente {
    return Intl.message(
      'Invoice Address',
      name: 'facturaDireccionCliente',
      desc: '',
      args: [],
    );
  }

  /// `CC Address`
  String get ccDireccionCliente {
    return Intl.message(
      'CC Address',
      name: 'ccDireccionCliente',
      desc: '',
      args: [],
    );
  }

  /// `Account_Cta_Description`
  String get descripcionCuentaCtaCliente {
    return Intl.message(
      'Account_Cta_Description',
      name: 'descripcionCuentaCtaCliente',
      desc: '',
      args: [],
    );
  }

  /// `Address_1_Account_Cta`
  String get direccion1CuentaCtaCliente {
    return Intl.message(
      'Address_1_Account_Cta',
      name: 'direccion1CuentaCtaCliente',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailCliente {
    return Intl.message(
      'Email',
      name: 'emailCliente',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get telefonoCliente {
    return Intl.message(
      'Phone',
      name: 'telefonoCliente',
      desc: '',
      args: [],
    );
  }

  /// `Cell Phone`
  String get celularCliente {
    return Intl.message(
      'Cell Phone',
      name: 'celularCliente',
      desc: '',
      args: [],
    );
  }

  /// `Credit Limit`
  String get limiteCreditoCliente {
    return Intl.message(
      'Credit Limit',
      name: 'limiteCreditoCliente',
      desc: '',
      args: [],
    );
  }

  /// `Allow CxC`
  String get permitirCxCCliente {
    return Intl.message(
      'Allow CxC',
      name: 'permitirCxCCliente',
      desc: '',
      args: [],
    );
  }

  /// `Account Group`
  String get grupoCuentaCliente {
    return Intl.message(
      'Account Group',
      name: 'grupoCuentaCliente',
      desc: '',
      args: [],
    );
  }

  /// `Account Group Description`
  String get descripcionGrupoCuentaCliente {
    return Intl.message(
      'Account Group Description',
      name: 'descripcionGrupoCuentaCliente',
      desc: '',
      args: [],
    );
  }

  /// `No data found`
  String get noSeLocalizaronDatos {
    return Intl.message(
      'No data found',
      name: 'noSeLocalizaronDatos',
      desc: '',
      args: [],
    );
  }

  /// `No data matches the search criteria`
  String get noHayDatosQueCoincidanConElCriterioDeBusqueda {
    return Intl.message(
      'No data matches the search criteria',
      name: 'noHayDatosQueCoincidanConElCriterioDeBusqueda',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get advertencia {
    return Intl.message(
      'Warning',
      name: 'advertencia',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a search criterion`
  String get debeIngresarCriterioBusqueda {
    return Intl.message(
      'Please enter a search criterion',
      name: 'debeIngresarCriterioBusqueda',
      desc: '',
      args: [],
    );
  }

  /// `PENDING PAYMENT DOCUMENTS`
  String get documentosPendientesTitulo {
    return Intl.message(
      'PENDING PAYMENT DOCUMENTS',
      name: 'documentosPendientesTitulo',
      desc: '',
      args: [],
    );
  }

  /// `Pending Payment\nDocuments`
  String get documentosPendientesTituloMultilinea {
    return Intl.message(
      'Pending Payment\nDocuments',
      name: 'documentosPendientesTituloMultilinea',
      desc: '',
      args: [],
    );
  }

  /// `Client Data`
  String get datosDelCliente {
    return Intl.message(
      'Client Data',
      name: 'datosDelCliente',
      desc: '',
      args: [],
    );
  }

  /// `Account Name not registered`
  String get nombreCtaNoRegistrado {
    return Intl.message(
      'Account Name not registered',
      name: 'nombreCtaNoRegistrado',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Name not registered`
  String get nombreFacturaNoRegistrada {
    return Intl.message(
      'Invoice Name not registered',
      name: 'nombreFacturaNoRegistrada',
      desc: '',
      args: [],
    );
  }

  /// `NIT not registered`
  String get nitNoRegistrado {
    return Intl.message(
      'NIT not registered',
      name: 'nitNoRegistrado',
      desc: '',
      args: [],
    );
  }

  /// `Address not registered`
  String get direccionNoRegistrada {
    return Intl.message(
      'Address not registered',
      name: 'direccionNoRegistrada',
      desc: '',
      args: [],
    );
  }

  /// `Not registered`
  String get noRegistrado {
    return Intl.message(
      'Not registered',
      name: 'noRegistrado',
      desc: '',
      args: [],
    );
  }

  /// `Chronological Payment`
  String get pagoCronologico {
    return Intl.message(
      'Chronological Payment',
      name: 'pagoCronologico',
      desc: '',
      args: [],
    );
  }

  /// `Enter amount`
  String get ingresarMonto {
    return Intl.message(
      'Enter amount',
      name: 'ingresarMonto',
      desc: '',
      args: [],
    );
  }

  /// `No. Record: `
  String get numeroRegistro {
    return Intl.message(
      'No. Record: ',
      name: 'numeroRegistro',
      desc: '',
      args: [],
    );
  }

  /// `Ascending`
  String get ascendente {
    return Intl.message(
      'Ascending',
      name: 'ascendente',
      desc: '',
      args: [],
    );
  }

  /// `Descending`
  String get descendente {
    return Intl.message(
      'Descending',
      name: 'descendente',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get aplicar {
    return Intl.message(
      'Apply',
      name: 'aplicar',
      desc: '',
      args: [],
    );
  }

  /// `Amount is required`
  String get seRequiereIngresarMonto {
    return Intl.message(
      'Amount is required',
      name: 'seRequiereIngresarMonto',
      desc: '',
      args: [],
    );
  }

  /// `Confirm application`
  String get confirmarAplicacion {
    return Intl.message(
      'Confirm application',
      name: 'confirmarAplicacion',
      desc: '',
      args: [],
    );
  }

  /// `This amount `
  String get esteMonto {
    return Intl.message(
      'This amount ',
      name: 'esteMonto',
      desc: '',
      args: [],
    );
  }

  /// `will be applied to this balance `
  String get seVaAplicarASaldo {
    return Intl.message(
      'will be applied to this balance ',
      name: 'seVaAplicarASaldo',
      desc: '',
      args: [],
    );
  }

  /// `\n\nAre you sure you want to make the changes?`
  String get confirmacionCambios {
    return Intl.message(
      '\n\nAre you sure you want to make the changes?',
      name: 'confirmacionCambios',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirmar {
    return Intl.message(
      'Confirm',
      name: 'confirmar',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelar {
    return Intl.message(
      'Cancel',
      name: 'cancelar',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get aceptar {
    return Intl.message(
      'Accept',
      name: 'aceptar',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get monto {
    return Intl.message(
      'Amount',
      name: 'monto',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get saldo {
    return Intl.message(
      'Balance',
      name: 'saldo',
      desc: '',
      args: [],
    );
  }

  /// `Applied Value`
  String get valorAplicado {
    return Intl.message(
      'Applied Value',
      name: 'valorAplicado',
      desc: '',
      args: [],
    );
  }

  /// `Internal Consecutive`
  String get consecutivoInterno {
    return Intl.message(
      'Internal Consecutive',
      name: 'consecutivoInterno',
      desc: '',
      args: [],
    );
  }

  /// `R_UserName`
  String get rUserName {
    return Intl.message(
      'R_UserName',
      name: 'rUserName',
      desc: '',
      args: [],
    );
  }

  /// `Exchange Rate`
  String get tipoCambio {
    return Intl.message(
      'Exchange Rate',
      name: 'tipoCambio',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get moneda {
    return Intl.message(
      'Currency',
      name: 'moneda',
      desc: '',
      args: [],
    );
  }

  /// `Currency_Amount`
  String get montoMoneda {
    return Intl.message(
      'Currency_Amount',
      name: 'montoMoneda',
      desc: '',
      args: [],
    );
  }

  /// `Applied_Currency_Value`
  String get valorAplicadoMoneda {
    return Intl.message(
      'Applied_Currency_Value',
      name: 'valorAplicadoMoneda',
      desc: '',
      args: [],
    );
  }

  /// `D_Due_Date`
  String get dfechaVencimiento {
    return Intl.message(
      'D_Due_Date',
      name: 'dfechaVencimiento',
      desc: '',
      args: [],
    );
  }

  /// `UserName`
  String get username {
    return Intl.message(
      'UserName',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Document_Status_Description`
  String get desEstadoDocumento {
    return Intl.message(
      'Document_Status_Description',
      name: 'desEstadoDocumento',
      desc: '',
      args: [],
    );
  }

  /// `Current_Account`
  String get cuentaCorriente {
    return Intl.message(
      'Current_Account',
      name: 'cuentaCorriente',
      desc: '',
      args: [],
    );
  }

  /// `Collect_Pay`
  String get cobrarPagar {
    return Intl.message(
      'Collect_Pay',
      name: 'cobrarPagar',
      desc: '',
      args: [],
    );
  }

  /// `Company`
  String get empresa {
    return Intl.message(
      'Company',
      name: 'empresa',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get localizacion {
    return Intl.message(
      'Location',
      name: 'localizacion',
      desc: '',
      args: [],
    );
  }

  /// `Workstation`
  String get estacionTrabajo {
    return Intl.message(
      'Workstation',
      name: 'estacionTrabajo',
      desc: '',
      args: [],
    );
  }

  /// `Registration_Date`
  String get fechaReg {
    return Intl.message(
      'Registration_Date',
      name: 'fechaReg',
      desc: '',
      args: [],
    );
  }

  /// `States`
  String get estado {
    return Intl.message(
      'States',
      name: 'estado',
      desc: '',
      args: [],
    );
  }

  /// `Date_Time`
  String get fechaHora {
    return Intl.message(
      'Date_Time',
      name: 'fechaHora',
      desc: '',
      args: [],
    );
  }

  /// `M_Date_Time`
  String get mFechaHora {
    return Intl.message(
      'M_Date_Time',
      name: 'mFechaHora',
      desc: '',
      args: [],
    );
  }

  /// `M_UserName`
  String get mUsername {
    return Intl.message(
      'M_UserName',
      name: 'mUsername',
      desc: '',
      args: [],
    );
  }

  /// `Account_Holder`
  String get cuentaCorrentista {
    return Intl.message(
      'Account_Holder',
      name: 'cuentaCorrentista',
      desc: '',
      args: [],
    );
  }

  /// `Account_CTA`
  String get cuentaCta {
    return Intl.message(
      'Account_CTA',
      name: 'cuentaCta',
      desc: '',
      args: [],
    );
  }

  /// `Parent_Current_Account`
  String get cuentaCorrientePadre {
    return Intl.message(
      'Parent_Current_Account',
      name: 'cuentaCorrientePadre',
      desc: '',
      args: [],
    );
  }

  /// `Parent_Collect_Pay`
  String get cobrarPagarPadre {
    return Intl.message(
      'Parent_Collect_Pay',
      name: 'cobrarPagarPadre',
      desc: '',
      args: [],
    );
  }

  /// `Parent_Company`
  String get empresaPadre {
    return Intl.message(
      'Parent_Company',
      name: 'empresaPadre',
      desc: '',
      args: [],
    );
  }

  /// `Parent_Location`
  String get localizacionPadre {
    return Intl.message(
      'Parent_Location',
      name: 'localizacionPadre',
      desc: '',
      args: [],
    );
  }

  /// `Parent_Workstation`
  String get estacionTrabajoPadre {
    return Intl.message(
      'Parent_Workstation',
      name: 'estacionTrabajoPadre',
      desc: '',
      args: [],
    );
  }

  /// `Parent_Registration_Date`
  String get fechaRegPadre {
    return Intl.message(
      'Parent_Registration_Date',
      name: 'fechaRegPadre',
      desc: '',
      args: [],
    );
  }

  /// `Account_Date`
  String get fechaCuenta {
    return Intl.message(
      'Account_Date',
      name: 'fechaCuenta',
      desc: '',
      args: [],
    );
  }

  /// `Start_Date`
  String get fechaInicial {
    return Intl.message(
      'Start_Date',
      name: 'fechaInicial',
      desc: '',
      args: [],
    );
  }

  /// `End_Date`
  String get fechaFinal {
    return Intl.message(
      'End_Date',
      name: 'fechaFinal',
      desc: '',
      args: [],
    );
  }

  /// `Generate_Check`
  String get generarCheque {
    return Intl.message(
      'Generate_Check',
      name: 'generarCheque',
      desc: '',
      args: [],
    );
  }

  /// `Process`
  String get proceso {
    return Intl.message(
      'Process',
      name: 'proceso',
      desc: '',
      args: [],
    );
  }

  /// `Bank Account`
  String get cuentaBancaria {
    return Intl.message(
      'Bank Account',
      name: 'cuentaBancaria',
      desc: '',
      args: [],
    );
  }

  /// `Document_ID_Reference`
  String get idDocumentoReferencia {
    return Intl.message(
      'Document_ID_Reference',
      name: 'idDocumentoReferencia',
      desc: '',
      args: [],
    );
  }

  /// `Currency_Balance`
  String get saldoMoneda {
    return Intl.message(
      'Currency_Balance',
      name: 'saldoMoneda',
      desc: '',
      args: [],
    );
  }

  /// `Account_Holder_Ref`
  String get cuentaCorrentistaRef {
    return Intl.message(
      'Account_Holder_Ref',
      name: 'cuentaCorrentistaRef',
      desc: '',
      args: [],
    );
  }

  /// `Document ID`
  String get idDocumento {
    return Intl.message(
      'Document ID',
      name: 'idDocumento',
      desc: '',
      args: [],
    );
  }

  /// `Document Date`
  String get fechaDocumento {
    return Intl.message(
      'Document Date',
      name: 'fechaDocumento',
      desc: '',
      args: [],
    );
  }

  /// `Document_Series_Description`
  String get desSerieDocumento {
    return Intl.message(
      'Document_Series_Description',
      name: 'desSerieDocumento',
      desc: '',
      args: [],
    );
  }

  /// `Currency_Name`
  String get nomMoneda {
    return Intl.message(
      'Currency_Name',
      name: 'nomMoneda',
      desc: '',
      args: [],
    );
  }

  /// `Currency_Description`
  String get desMoneda {
    return Intl.message(
      'Currency_Description',
      name: 'desMoneda',
      desc: '',
      args: [],
    );
  }

  /// `Symbol`
  String get simbolo {
    return Intl.message(
      'Symbol',
      name: 'simbolo',
      desc: '',
      args: [],
    );
  }

  /// `Invoice_Name`
  String get facturaNombre {
    return Intl.message(
      'Invoice_Name',
      name: 'facturaNombre',
      desc: '',
      args: [],
    );
  }

  /// `Account_CTA_Description`
  String get desCuentaCta {
    return Intl.message(
      'Account_CTA_Description',
      name: 'desCuentaCta',
      desc: '',
      args: [],
    );
  }

  /// `Document_Type_Description`
  String get desTipoDocumento {
    return Intl.message(
      'Document_Type_Description',
      name: 'desTipoDocumento',
      desc: '',
      args: [],
    );
  }

  /// `fDocument_Relation`
  String get fDocumentoRelacion {
    return Intl.message(
      'fDocument_Relation',
      name: 'fDocumentoRelacion',
      desc: '',
      args: [],
    );
  }

  /// `Current_Account_Description`
  String get desCuentaCorriente {
    return Intl.message(
      'Current_Account_Description',
      name: 'desCuentaCorriente',
      desc: '',
      args: [],
    );
  }

  /// `D_Document`
  String get dDocumento {
    return Intl.message(
      'D_Document',
      name: 'dDocumento',
      desc: '',
      args: [],
    );
  }

  /// `D_Document_Type`
  String get dTipoDocumento {
    return Intl.message(
      'D_Document_Type',
      name: 'dTipoDocumento',
      desc: '',
      args: [],
    );
  }

  /// `D_Document_Series`
  String get dSerieDocumento {
    return Intl.message(
      'D_Document_Series',
      name: 'dSerieDocumento',
      desc: '',
      args: [],
    );
  }

  /// `D_Company`
  String get dEmpresa {
    return Intl.message(
      'D_Company',
      name: 'dEmpresa',
      desc: '',
      args: [],
    );
  }

  /// `D_Location`
  String get dLocalizacion {
    return Intl.message(
      'D_Location',
      name: 'dLocalizacion',
      desc: '',
      args: [],
    );
  }

  /// `D_Workstation`
  String get dEstacionTrabajo {
    return Intl.message(
      'D_Workstation',
      name: 'dEstacionTrabajo',
      desc: '',
      args: [],
    );
  }

  /// `D_Registration_Date`
  String get dFechaReg {
    return Intl.message(
      'D_Registration_Date',
      name: 'dFechaReg',
      desc: '',
      args: [],
    );
  }

  /// `Reference`
  String get referencia {
    return Intl.message(
      'Reference',
      name: 'referencia',
      desc: '',
      args: [],
    );
  }

  /// `Ref_Document_ID`
  String get refIdDocumento {
    return Intl.message(
      'Ref_Document_ID',
      name: 'refIdDocumento',
      desc: '',
      args: [],
    );
  }

  /// `Ref_Series`
  String get refSerie {
    return Intl.message(
      'Ref_Series',
      name: 'refSerie',
      desc: '',
      args: [],
    );
  }

  /// `Document_Name`
  String get documentoNombre {
    return Intl.message(
      'Document_Name',
      name: 'documentoNombre',
      desc: '',
      args: [],
    );
  }

  /// `Account_ID`
  String get idCuenta {
    return Intl.message(
      'Account_ID',
      name: 'idCuenta',
      desc: '',
      args: [],
    );
  }

  /// `D_Reference`
  String get dReferencia {
    return Intl.message(
      'D_Reference',
      name: 'dReferencia',
      desc: '',
      args: [],
    );
  }

  /// `R_Reference_ID`
  String get rReferenciaId {
    return Intl.message(
      'R_Reference_ID',
      name: 'rReferenciaId',
      desc: '',
      args: [],
    );
  }

  /// `R_Origin_Document_ID`
  String get rIdDocumentoOrigen {
    return Intl.message(
      'R_Origin_Document_ID',
      name: 'rIdDocumentoOrigen',
      desc: '',
      args: [],
    );
  }

  /// `FE_CAE`
  String get feCae {
    return Intl.message(
      'FE_CAE',
      name: 'feCae',
      desc: '',
      args: [],
    );
  }

  /// `FE_DocumentNumber`
  String get feNumeroDocumento {
    return Intl.message(
      'FE_DocumentNumber',
      name: 'feNumeroDocumento',
      desc: '',
      args: [],
    );
  }

  /// `You cannot enter a number greater than `
  String get noSePuedeIngresarNumeroMayor {
    return Intl.message(
      'You cannot enter a number greater than ',
      name: 'noSePuedeIngresarNumeroMayor',
      desc: '',
      args: [],
    );
  }

  /// `No results`
  String get sinResultados {
    return Intl.message(
      'No results',
      name: 'sinResultados',
      desc: '',
      args: [],
    );
  }

  /// `There are no pending documents to pay`
  String get noHayDocumentosPendientesPorPagar {
    return Intl.message(
      'There are no pending documents to pay',
      name: 'noHayDocumentosPendientesPorPagar',
      desc: '',
      args: [],
    );
  }

  /// `Show Details`
  String get mostrarDetalles {
    return Intl.message(
      'Show Details',
      name: 'mostrarDetalles',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get detalles {
    return Intl.message(
      'Details',
      name: 'detalles',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get cerrar {
    return Intl.message(
      'Close',
      name: 'cerrar',
      desc: '',
      args: [],
    );
  }

  /// `Total Applying:`
  String get totalAplicando {
    return Intl.message(
      'Total Applying:',
      name: 'totalAplicando',
      desc: '',
      args: [],
    );
  }

  /// `Total Amounts:`
  String get totalMontos {
    return Intl.message(
      'Total Amounts:',
      name: 'totalMontos',
      desc: '',
      args: [],
    );
  }

  /// `Total Balances:`
  String get totalSaldos {
    return Intl.message(
      'Total Balances:',
      name: 'totalSaldos',
      desc: '',
      args: [],
    );
  }

  /// `Difference:`
  String get diferencia {
    return Intl.message(
      'Difference:',
      name: 'diferencia',
      desc: '',
      args: [],
    );
  }

  /// `RECEIPT CREATION`
  String get creacionReciboTitulo {
    return Intl.message(
      'RECEIPT CREATION',
      name: 'creacionReciboTitulo',
      desc: '',
      args: [],
    );
  }

  /// `Credit CxC`
  String get abonoCxC {
    return Intl.message(
      'Credit CxC',
      name: 'abonoCxC',
      desc: '',
      args: [],
    );
  }

  /// `Charge CxC`
  String get cargoCxC {
    return Intl.message(
      'Charge CxC',
      name: 'cargoCxC',
      desc: '',
      args: [],
    );
  }

  /// `Credit Note CxC`
  String get notaCreditoCxC {
    return Intl.message(
      'Credit Note CxC',
      name: 'notaCreditoCxC',
      desc: '',
      args: [],
    );
  }

  /// `Debit Note CxC`
  String get notaDebitoCxC {
    return Intl.message(
      'Debit Note CxC',
      name: 'notaDebitoCxC',
      desc: '',
      args: [],
    );
  }

  /// `Cash Receipt CxC`
  String get reciboCajaCxC {
    return Intl.message(
      'Cash Receipt CxC',
      name: 'reciboCajaCxC',
      desc: '',
      args: [],
    );
  }

  /// `Cash (CxC)`
  String get efectivoCxC {
    return Intl.message(
      'Cash (CxC)',
      name: 'efectivoCxC',
      desc: '',
      args: [],
    );
  }

  /// `Credit Card (CxC)`
  String get tarjetaCreditoCxC {
    return Intl.message(
      'Credit Card (CxC)',
      name: 'tarjetaCreditoCxC',
      desc: '',
      args: [],
    );
  }

  /// `Check (CxC)`
  String get chequeCxC {
    return Intl.message(
      'Check (CxC)',
      name: 'chequeCxC',
      desc: '',
      args: [],
    );
  }

  /// `VAT Exemptions`
  String get exencionesIVA {
    return Intl.message(
      'VAT Exemptions',
      name: 'exencionesIVA',
      desc: '',
      args: [],
    );
  }

  /// `Debit Note (CxP)`
  String get notaDebitoCP {
    return Intl.message(
      'Debit Note (CxP)',
      name: 'notaDebitoCP',
      desc: '',
      args: [],
    );
  }

  /// `Credit Note (CxC)`
  String get notaCreditoCxCPago {
    return Intl.message(
      'Credit Note (CxC)',
      name: 'notaCreditoCxCPago',
      desc: '',
      args: [],
    );
  }

  /// `VAT Withholdings`
  String get retencionesIVA {
    return Intl.message(
      'VAT Withholdings',
      name: 'retencionesIVA',
      desc: '',
      args: [],
    );
  }

  /// `Returns`
  String get devoluciones {
    return Intl.message(
      'Returns',
      name: 'devoluciones',
      desc: '',
      args: [],
    );
  }

  /// `Credit (CxC)`
  String get abonoCxCPago {
    return Intl.message(
      'Credit (CxC)',
      name: 'abonoCxCPago',
      desc: '',
      args: [],
    );
  }

  /// `Charge (CxC)`
  String get cargoCxCPago {
    return Intl.message(
      'Charge (CxC)',
      name: 'cargoCxCPago',
      desc: '',
      args: [],
    );
  }

  /// `No document type has been selected`
  String get noHayTipoDeDocumento {
    return Intl.message(
      'No document type has been selected',
      name: 'noHayTipoDeDocumento',
      desc: '',
      args: [],
    );
  }

  /// `No series has been selected`
  String get noHaySerie {
    return Intl.message(
      'No series has been selected',
      name: 'noHaySerie',
      desc: '',
      args: [],
    );
  }

  /// `No payment type has been selected`
  String get noHayTipoPago {
    return Intl.message(
      'No payment type has been selected',
      name: 'noHayTipoPago',
      desc: '',
      args: [],
    );
  }

  /// `You need to select a date`
  String get requiereFecha {
    return Intl.message(
      'You need to select a date',
      name: 'requiereFecha',
      desc: '',
      args: [],
    );
  }

  /// `Required to enter Authorization`
  String get requiereAutorizacion {
    return Intl.message(
      'Required to enter Authorization',
      name: 'requiereAutorizacion',
      desc: '',
      args: [],
    );
  }

  /// `Required to enter Reference`
  String get requiereReferencia {
    return Intl.message(
      'Required to enter Reference',
      name: 'requiereReferencia',
      desc: '',
      args: [],
    );
  }

  /// `No bank has been selected`
  String get noHayBanco {
    return Intl.message(
      'No bank has been selected',
      name: 'noHayBanco',
      desc: '',
      args: [],
    );
  }

  /// `No bank account has been selected`
  String get noHayCuentaBancaria {
    return Intl.message(
      'No bank account has been selected',
      name: 'noHayCuentaBancaria',
      desc: '',
      args: [],
    );
  }

  /// `You are required to enter the amount`
  String get noHayMonto {
    return Intl.message(
      'You are required to enter the amount',
      name: 'noHayMonto',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to create this document?`
  String get deseaCrearDocumento {
    return Intl.message(
      'Do you want to create this document?',
      name: 'deseaCrearDocumento',
      desc: '',
      args: [],
    );
  }

  /// `No other document has been selected to affect`
  String get seleccionarDocParaAfectar {
    return Intl.message(
      'No other document has been selected to affect',
      name: 'seleccionarDocParaAfectar',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get fecha {
    return Intl.message(
      'Date',
      name: 'fecha',
      desc: '',
      args: [],
    );
  }

  /// `Document Type`
  String get tipoDocumento {
    return Intl.message(
      'Document Type',
      name: 'tipoDocumento',
      desc: '',
      args: [],
    );
  }

  /// `Verify internet connection`
  String get conexionInternet {
    return Intl.message(
      'Verify internet connection',
      name: 'conexionInternet',
      desc: '',
      args: [],
    );
  }

  /// `Press a document type first`
  String get antesTipoDocumento {
    return Intl.message(
      'Press a document type first',
      name: 'antesTipoDocumento',
      desc: '',
      args: [],
    );
  }

  /// `Series`
  String get series {
    return Intl.message(
      'Series',
      name: 'series',
      desc: '',
      args: [],
    );
  }

  /// `Press one series before`
  String get antesSerie {
    return Intl.message(
      'Press one series before',
      name: 'antesSerie',
      desc: '',
      args: [],
    );
  }

  /// `Payment Type`
  String get tipodePago {
    return Intl.message(
      'Payment Type',
      name: 'tipodePago',
      desc: '',
      args: [],
    );
  }

  /// `Authorization`
  String get autorizacion {
    return Intl.message(
      'Authorization',
      name: 'autorizacion',
      desc: '',
      args: [],
    );
  }

  /// `Click on the Payment Type that requires the Bank selection.`
  String get requiereTipoPagoBanco {
    return Intl.message(
      'Click on the Payment Type that requires the Bank selection.',
      name: 'requiereTipoPagoBanco',
      desc: '',
      args: [],
    );
  }

  /// `Banks`
  String get bancos {
    return Intl.message(
      'Banks',
      name: 'bancos',
      desc: '',
      args: [],
    );
  }

  /// `Click on the Payment Type required by the Bank Account.`
  String get requiereTipoPagoCuentaBancaria {
    return Intl.message(
      'Click on the Payment Type required by the Bank Account.',
      name: 'requiereTipoPagoCuentaBancaria',
      desc: '',
      args: [],
    );
  }

  /// `No Bank Accounts Found`
  String get noSeEncuentranCuentasBancarias {
    return Intl.message(
      'No Bank Accounts Found',
      name: 'noSeEncuentranCuentasBancarias',
      desc: '',
      args: [],
    );
  }

  /// `Observations`
  String get observaciones {
    return Intl.message(
      'Observations',
      name: 'observaciones',
      desc: '',
      args: [],
    );
  }

  /// `Enter your observations`
  String get ingresarObservaciones {
    return Intl.message(
      'Enter your observations',
      name: 'ingresarObservaciones',
      desc: '',
      args: [],
    );
  }

  /// `Text copied to clipboard`
  String get textoCopiado {
    return Intl.message(
      'Text copied to clipboard',
      name: 'textoCopiado',
      desc: '',
      args: [],
    );
  }

  /// `Blocked`
  String get bloqueado {
    return Intl.message(
      'Blocked',
      name: 'bloqueado',
      desc: '',
      args: [],
    );
  }

  /// `Selected Options`
  String get observacionesSeleccionadas {
    return Intl.message(
      'Selected Options',
      name: 'observacionesSeleccionadas',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get tipo {
    return Intl.message(
      'Type',
      name: 'tipo',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get pago {
    return Intl.message(
      'Payment',
      name: 'pago',
      desc: '',
      args: [],
    );
  }

  /// `Payment $`
  String get pago2 {
    return Intl.message(
      'Payment \$',
      name: 'pago2',
      desc: '',
      args: [],
    );
  }

  /// `Id Reference`
  String get idReferencia {
    return Intl.message(
      'Id Reference',
      name: 'idReferencia',
      desc: '',
      args: [],
    );
  }

  /// `Id Authorization`
  String get idAutorizacion {
    return Intl.message(
      'Id Authorization',
      name: 'idAutorizacion',
      desc: '',
      args: [],
    );
  }

  /// `Bank`
  String get banco {
    return Intl.message(
      'Bank',
      name: 'banco',
      desc: '',
      args: [],
    );
  }

  /// `UserName`
  String get usuario {
    return Intl.message(
      'UserName',
      name: 'usuario',
      desc: '',
      args: [],
    );
  }

  /// `Affect CxC`
  String get afectarCxC {
    return Intl.message(
      'Affect CxC',
      name: 'afectarCxC',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to insert another payment(debit_credit) to the created document?`
  String get otroCargoAbono {
    return Intl.message(
      'Do you want to insert another payment(debit_credit) to the created document?',
      name: 'otroCargoAbono',
      desc: '',
      args: [],
    );
  }

  /// `Orphan`
  String get huerfano {
    return Intl.message(
      'Orphan',
      name: 'huerfano',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get imprimir {
    return Intl.message(
      'Print',
      name: 'imprimir',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to print the document?`
  String get seguroImprimir {
    return Intl.message(
      'Are you sure you want to print the document?',
      name: 'seguroImprimir',
      desc: '',
      args: [],
    );
  }

  /// `PDF Preview`
  String get vistaPreviaPdf {
    return Intl.message(
      'PDF Preview',
      name: 'vistaPreviaPdf',
      desc: '',
      args: [],
    );
  }

  /// `Notice`
  String get aviso {
    return Intl.message(
      'Notice',
      name: 'aviso',
      desc: '',
      args: [],
    );
  }

  /// `Be sure to print or share the PDF before returning to the screen`
  String get asegurateDeImprimir {
    return Intl.message(
      'Be sure to print or share the PDF before returning to the screen',
      name: 'asegurateDeImprimir',
      desc: '',
      args: [],
    );
  }

  /// `Back to Save or Share`
  String get regresarGuardarCompartir {
    return Intl.message(
      'Back to Save or Share',
      name: 'regresarGuardarCompartir',
      desc: '',
      args: [],
    );
  }

  /// `Back to Screen`
  String get regresarPantalla {
    return Intl.message(
      'Back to Screen',
      name: 'regresarPantalla',
      desc: '',
      args: [],
    );
  }

  /// `Confirm creation:`
  String get confirmarCreacion {
    return Intl.message(
      'Confirm creation:',
      name: 'confirmarCreacion',
      desc: '',
      args: [],
    );
  }

  /// `Series`
  String get serie {
    return Intl.message(
      'Series',
      name: 'serie',
      desc: '',
      args: [],
    );
  }

  /// `Document No`
  String get documentoNo {
    return Intl.message(
      'Document No',
      name: 'documentoNo',
      desc: '',
      args: [],
    );
  }

  /// `Nit`
  String get nit {
    return Intl.message(
      'Nit',
      name: 'nit',
      desc: '',
      args: [],
    );
  }

  /// `Received From`
  String get recibiDe {
    return Intl.message(
      'Received From',
      name: 'recibiDe',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Applied Documents`
  String get documentosAplicados {
    return Intl.message(
      'Applied Documents',
      name: 'documentosAplicados',
      desc: '',
      args: [],
    );
  }

  /// `Document Series`
  String get serieDocumento {
    return Intl.message(
      'Document Series',
      name: 'serieDocumento',
      desc: '',
      args: [],
    );
  }

  /// `Applied`
  String get aplicado {
    return Intl.message(
      'Applied',
      name: 'aplicado',
      desc: '',
      args: [],
    );
  }

  /// `Total in Letters`
  String get totalLetras {
    return Intl.message(
      'Total in Letters',
      name: 'totalLetras',
      desc: '',
      args: [],
    );
  }

  /// `Observation`
  String get observacion {
    return Intl.message(
      'Observation',
      name: 'observacion',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get recibido {
    return Intl.message(
      'Received',
      name: 'recibido',
      desc: '',
      args: [],
    );
  }

  /// `Change Image Template`
  String get cambiarPlantilla {
    return Intl.message(
      'Change Image Template',
      name: 'cambiarPlantilla',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get ingresar {
    return Intl.message(
      'Join',
      name: 'ingresar',
      desc: '',
      args: [],
    );
  }

  /// `You must enter the user`
  String get debeIngresarElUsuario {
    return Intl.message(
      'You must enter the user',
      name: 'debeIngresarElUsuario',
      desc: '',
      args: [],
    );
  }

  /// `You must enter the password`
  String get debeIngresarLaContrasena {
    return Intl.message(
      'You must enter the password',
      name: 'debeIngresarLaContrasena',
      desc: '',
      args: [],
    );
  }

  /// `Save Session`
  String get guardarSesion {
    return Intl.message(
      'Save Session',
      name: 'guardarSesion',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get cerrarSesion {
    return Intl.message(
      'Log out',
      name: 'cerrarSesion',
      desc: '',
      args: [],
    );
  }

  /// `Session saved on`
  String get sesionGuardadaEl {
    return Intl.message(
      'Session saved on',
      name: 'sesionGuardadaEl',
      desc: '',
      args: [],
    );
  }

  /// `Session expires on`
  String get sesionExpiraEl {
    return Intl.message(
      'Session expires on',
      name: 'sesionExpiraEl',
      desc: '',
      args: [],
    );
  }

  /// `Select Background`
  String get seleccionarFondo {
    return Intl.message(
      'Select Background',
      name: 'seleccionarFondo',
      desc: '',
      args: [],
    );
  }

  /// `Remove Background`
  String get quitarFondo {
    return Intl.message(
      'Remove Background',
      name: 'quitarFondo',
      desc: '',
      args: [],
    );
  }

  /// `YOUR LOGO\nHERE`
  String get logoAqui {
    return Intl.message(
      'YOUR LOGO\nHERE',
      name: 'logoAqui',
      desc: '',
      args: [],
    );
  }

  /// `Amount for orphan`
  String get montoParaHuerfano {
    return Intl.message(
      'Amount for orphan',
      name: 'montoParaHuerfano',
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
