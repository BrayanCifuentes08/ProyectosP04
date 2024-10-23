import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:test_cuenta_corriente/common/Loading.dart';
import 'package:test_cuenta_corriente/Models/DocumentoAplicarParametros.dart';
import 'package:test_cuenta_corriente/Models/PaBscBanco1M.dart';
import 'package:test_cuenta_corriente/Models/PaBscCuentaBancaria1M.dart';
import 'package:test_cuenta_corriente/Models/PaBscCuentaCorriente1M.dart';
import 'package:test_cuenta_corriente/Models/PaBscSerieDocumento1M.dart';
import 'package:test_cuenta_corriente/Models/PaBscTipoCargoAbono1M.dart';
import 'package:test_cuenta_corriente/Models/PaBscTipoDocumentoMovilM.dart';
import 'package:test_cuenta_corriente/Models/PaCargoAbonoValidar1M.dart';
import 'package:test_cuenta_corriente/Models/PaDocumentoValidar1M.dart';
import 'package:test_cuenta_corriente/Models/PaTblCargoAbonoM.dart';
import 'package:test_cuenta_corriente/Models/PaTblDocumentoM.dart';
import 'package:test_cuenta_corriente/ImprimirDocumento.dart';
import 'package:test_cuenta_corriente/common/Mensajes.dart';
import 'package:test_cuenta_corriente/common/Utilidades.dart';
import 'package:test_cuenta_corriente/generated/l10n.dart';

class CreacionRecibo extends StatefulWidget {
  final int selectedOpc_Cuenta_Corriente;
  final int selectedCuenta_Corriente;
  final String selectedCuentaCta;
  final int selectedCuentaCorrentista;
  final int selectedEmpresa;
  final int selectedEstacionTrabajo;
  final String selectedUserName;
  final bool selectedpT_Filtro_6;
  final int selectedbGrupo;
  final bool selectedpDocumento_Conv;
  final bool selectedpFE_Tipo;
  final int selectedpPOS_Tipo;
  final bool selectedpVer_FE;
  final String selectedIdCuenta;
  final String pUserName;
  final int pEmpresa;
  final int pEstacion_Trabajo;
  final String facturaNombre;
  final String facturaNit;
  final String facturaDireccion;
  final String ccDireccion;
  final String telefono;
  final List<double> montosGuardados;
  final List<PaBscCuentaCorriente1M> documentosSeleccionados;
  final List<double> montosGuardadosAcumulados;
  final List<PaBscCuentaCorriente1M> documentosSeleccionadosAcumulados;
  final Function(Locale) changeLanguage;
  final Locale seleccionarIdioma;
  Locale idiomaDropDown;
  final String baseUrl;
  final String token;
  final bool temaClaro;
  final String imagePath;
  final String? imageLogo;
  final bool isBackgroundSet;
  final DateTime fechaSesion;
  final bool tokenSesionGuardada;
  final DateTime? fechaExpiracion;
  CreacionRecibo(
      {required this.selectedOpc_Cuenta_Corriente,
      required this.selectedCuenta_Corriente,
      required this.selectedCuentaCta,
      required this.selectedCuentaCorrentista,
      required this.selectedEmpresa,
      required this.selectedEstacionTrabajo,
      required this.selectedUserName,
      required this.selectedpT_Filtro_6,
      required this.selectedbGrupo,
      required this.selectedpDocumento_Conv,
      required this.selectedpFE_Tipo,
      required this.selectedpPOS_Tipo,
      required this.selectedpVer_FE,
      required this.selectedIdCuenta,
      required this.pUserName,
      required this.pEmpresa,
      required this.pEstacion_Trabajo,
      required this.facturaNombre,
      required this.facturaNit,
      required this.facturaDireccion,
      required this.montosGuardados,
      required this.documentosSeleccionados,
      required this.montosGuardadosAcumulados,
      required this.documentosSeleccionadosAcumulados,
      required this.ccDireccion,
      required this.telefono,
      required this.changeLanguage,
      required this.seleccionarIdioma,
      required this.idiomaDropDown,
      required this.baseUrl,
      required this.token,
      required this.temaClaro,
      required this.imagePath,
      required this.isBackgroundSet,
      required this.fechaSesion,
      this.fechaExpiracion,
      required this.tokenSesionGuardada,
      this.imageLogo});

  @override
  State<CreacionRecibo> createState() => _CreacionReciboState();
}

class _CreacionReciboState extends State<CreacionRecibo> {
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _referenciaController = TextEditingController();
  final TextEditingController _autorizacionController = TextEditingController();
  final TextEditingController _observacionController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isScrolledDown = false;

  FocusNode _focusId = FocusNode();
  FocusNode _focusFecha = FocusNode();
  FocusNode _focusMonto = FocusNode();
  FocusNode _focusReferencia = FocusNode();
  FocusNode _focusAutorizacion = FocusNode();
  FocusNode _focusObservacion = FocusNode();

  List<PaBscTipoDocumentoMovilM> _tiposD = [];
  List<PaBscSerieDocumento1M> _seriesD = [];
  List<PaBscTipoCargoAbono1M> _tipoCargoAbono = [];
  List<PaBscBanco1M> _banco = [];
  List<PaBscCuentaBancaria1M> _cuentaBancaria = [];
  List<PaDocumentoValidar1M> _validarD = [];
  List<PaTblDocumentoM> _documento = [];
  List<PaCargoAbonoValidar1M> _validarCargoA = [];
  List<PaTblCargoAbonoM> _cargoAbono = [];
  List<PaTblCargoAbonoM> registrosCargoAbono = [];
  List<PaTblCargoAbonoM> registrosCargoAbonoAfectar = [];
  List<PaTblCargoAbonoM> registrosCargoAbonoAfectarA = [];

  PaBscTipoDocumentoMovilM? _seleccionadoTipoDocumento;
  PaBscSerieDocumento1M? _seleccionadoSerieDocumento;
  PaBscTipoCargoAbono1M? _seleccionadoTipoCargoAbono;
  PaBscBanco1M? _seleccionadoBanco;
  PaBscCuentaBancaria1M? _seleccionadoCuentaBancaria;
  bool _isTipoPagoExpanded = true;
  bool _isSerieDocumentoExpanded = true;
  bool _isTipoDocumentoExpanded = true;
  bool _isBancoExpanded = true;
  bool _isCuentaBancariaExpanded = true;
  bool _mostrarTabla = false;
  bool _afectar = false;
  bool _cargandoAfectarCxC = false;
  bool _cargandoTipoDocumento = false;
  bool _cargandoSerieDocumento = false;
  bool _cargandoTipoCargoAbono = false;
  bool _cargandoBanco = false;
  bool _cargandoCuentaBancaria = false;
  bool _creadoAfectar = false;
  int _backGestureCount = 0;
  double _totalMontoAfectar = 0.0;
  TextEditingController _fechaController = TextEditingController();
  late DateTime _selectedDate;
  final DateTime minDate = DateTime.now();
  final DateTime maxDate = DateTime(9999, 12, 31);
  late Locale _idiomaActual;

  //al llamar el archivo:
  @override
  void initState() {
    super.initState();
    print(widget.selectedCuentaCta);
    _selectedDate = DateTime.now();
    _fechaController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    _mostrarTabla = false;
    _verTipoDocumentoMovil();
    print(widget.montosGuardados);
    _backGestureCount = 0;
    _idiomaActual = widget.idiomaDropDown;
  }

  @override
  void dispose() {
    // Asegúrate de liberar el FocusNode cuando el widget se elimine
    _focusId.dispose();
    _focusFecha.dispose();
    _focusMonto.dispose();
    _focusReferencia.dispose();
    _focusAutorizacion.dispose();
    _focusObservacion.dispose();
    super.dispose();
  }

  void _DesplazarScroll() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  Future<bool> _onWillPop() async {
    if (_backGestureCount == 0) {
      _backGestureCount++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).siVuelvesADeslizar),
          backgroundColor: Colors.grey,
        ),
      );
      // Resetea el contador después de unos segundos
      Future.delayed(Duration(seconds: 2), () {
        _backGestureCount = 0;
      });
      return false;
    } else {
      // Cierra la aplicación
      SystemNavigator.pop();
      return true;
    }
  }

  void _mostrarDialogoAdvertencia(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  size: 27, color: Color(0xFFDC9525)),
              SizedBox(width: 5),
              Text(
                S.of(context).advertencia,
                style: TextStyle(
                  color: Color.fromARGB(255, 83, 83, 83),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            mensaje,
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).aceptar,
                  style: TextStyle(color: Colors.cyan)),
              onPressed: () {
                Navigator.of(context).pop();
                _DesplazarScroll();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _verTipoDocumentoMovil() async {
    setState(() {
      _cargandoTipoDocumento =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaBscTipoDocumentoMovilCtrl';
    Map<String, dynamic> queryParams = {
      "pUserName": widget.pUserName.toString(),
      "pOpc_Cuenta_Corriente": "1",
      "pCuenta_Corriente": "1",
      "pEmpresa": widget.pEmpresa.toString(),
      "pIngreso": "0",
      "pCosto": "0",
      "pMensaje": "",
      "pResultado": "0"
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        // Imprimir la respuesta para depuración
        print('Respuesta de la API: ${response.body}');

        // Decodificar la respuesta JSON
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscTipoDocumentoMovilM> tiposD = jsonResponse
            .map((data) => PaBscTipoDocumentoMovilM.fromJson(data))
            .toList();

        tiposD.sort(
            (a, b) => a.ordenCuentaCorriente.compareTo(b.ordenCuentaCorriente));
        // Verificar si la respuesta es una lista
        // ignore: unnecessary_type_check
        if (jsonResponse is List) {
          // Convertir la respuesta en objetos de modelo si es una lista
          _tiposD = tiposD;
          // Actualizar el estado con los datos obtenidos
          setState(() {
            _isTipoDocumentoExpanded = true;
            _seleccionadoTipoDocumento = tiposD.firstWhere(
              (tipoDocumento) => tipoDocumento.tipoDocumento == 5,
            );
          });

          _verSerieDocumento();
        } else {
          print('Error: La respuesta no es una lista');
        }
      } else {
        print({response.body});
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoTipoDocumento = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> _verSerieDocumento() async {
    setState(() {
      _cargandoSerieDocumento =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaBscSerieDocumento1Ctrl';
    Map<String, dynamic> queryParams = {
      "pTipo_Documento": _seleccionadoTipoDocumento?.tipoDocumento.toString(),
      "pEmpresa": widget.pEmpresa.toString(),
      "pEstacion_Trabajo": widget.pEstacion_Trabajo.toString(),
      "pUserName": widget.pUserName.toString(),
      "pT_Filtro_6": "false",
      "pGrupo": "1",
      "pDocumento_Conv": "false",
      "pFE_Tipo": "false",
      "pPOS_Tipo": "0",
      "pVer_FE": "true",
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscSerieDocumento1M> seriesD = jsonResponse
            .map((data) => PaBscSerieDocumento1M.fromJson(data))
            .toList();
        // Verificar si la respuesta es una lista
        // ignore: unnecessary_type_check
        print('${response.body}');
        // ignore: unnecessary_type_check
        if (jsonResponse is List) {
          // Convertir la respuesta en objetos de modelo si es una lista
          _seriesD = seriesD;
          // Actualizar el estado con los datos obtenidos
          setState(() {
            _seleccionadoSerieDocumento = null;
            _seleccionadoTipoCargoAbono = null;
            _seleccionadoBanco = null;
            _seleccionadoCuentaBancaria = null;
            _fechaController.text = '';
            _referenciaController.text = "";
            _autorizacionController.text = "";
            _montoController.text = "";
          });
        } else {
          print('Error: La respuesta no es una lista');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoSerieDocumento = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> _verTipoCargoAbono() async {
    setState(() {
      _cargandoTipoCargoAbono =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaBscTipoCargoAbono1Ctrl';
    Map<String, dynamic> queryParams = {
      "pTipo_Documento": _seleccionadoSerieDocumento?.tipoDocumento.toString(),
      "pSerie_Documento":
          _seleccionadoSerieDocumento?.serieDocumento.toString(),
      "pEmpresa": _seleccionadoSerieDocumento?.empresa.toString(),
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscTipoCargoAbono1M> tipoCargoAbono = jsonResponse
            .map((data) => PaBscTipoCargoAbono1M.fromJson(data))
            .toList();
        // Verificar si la respuesta es una lista
        // ignore: unnecessary_type_check
        if (jsonResponse is List) {
          // Convertir la respuesta en objetos de modelo si es una lista
          _tipoCargoAbono = tipoCargoAbono;
          // Actualizar el estado con los datos obtenidos
          setState(() {
            _seleccionadoTipoCargoAbono = null;
            _seleccionadoBanco = null;
            _seleccionadoCuentaBancaria = null;
            _fechaController.text = '';
            _referenciaController.text = "";
            _autorizacionController.text = "";
            _montoController.text = "";
          });
        } else {
          print('Error: La respuesta no es una lista');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoTipoCargoAbono = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> _verBancos() async {
    setState(() {
      _cargandoBanco =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaBscBanco1Ctrl';
    Map<String, dynamic> queryParams = {
      "pUserName": widget.pUserName.toString(),
      "pOpcion": "4",
      "pEmpresa": widget.pEmpresa.toString(),
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscBanco1M> banco =
            jsonResponse.map((data) => PaBscBanco1M.fromJson(data)).toList();

        banco.sort((a, b) => a.orden.compareTo(b.orden));
        // Verificar si la respuesta es una lista
        // ignore: unnecessary_type_check
        if (jsonResponse is List) {
          // Convertir la respuesta en objetos de modelo si es una lista
          _banco = banco;
          // Actualizar el estado con los datos obtenidos
          setState(() {
            _seleccionadoBanco = null;
            _seleccionadoCuentaBancaria = null;
          });
        } else {
          print('Error: La respuesta no es una lista');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoBanco = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> _verCuentaBancaria() async {
    setState(() {
      _cargandoCuentaBancaria =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaBscCuentaBancaria1Ctrl';
    Map<String, dynamic> queryParams = {
      "pUserName": widget.pUserName.toString(),
      "pBanco": _seleccionadoBanco?.banco.toString(),
      "pEmpresa": widget.pEmpresa.toString(),
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscCuentaBancaria1M> cuentaBancaria = jsonResponse
            .map((data) => PaBscCuentaBancaria1M.fromJson(data))
            .toList();

        _cuentaBancaria.sort((a, b) => a.orden!.compareTo(b.orden!));
        // Verificar si la respuesta es una lista
        // ignore: unnecessary_type_check
        if (jsonResponse is List) {
          // Convertir la respuesta en objetos de modelo si es una lista
          _cuentaBancaria = cuentaBancaria;
          // Actualizar el estado con los datos obtenidos
          setState(() {
            _seleccionadoCuentaBancaria = null;
          });
        } else {
          print('Error: La respuesta no es una lista');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoCuentaBancaria = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> _validarDocumento() async {
    setState(() {
      _cargandoAfectarCxC =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaDocumentoValidar1Ctrl';

    String fechaTexto = _fechaController.text;
    DateTime? fecha;

    //FORMATO FECHA:
    if (fechaTexto.isEmpty) {
      fecha = null;
    } else {
      try {
        List<String> partes = fechaTexto.split('/');
        int dia = int.parse(partes[0]);
        int mes = int.parse(partes[1]);
        int anio = int.parse(partes[2]);
        fecha = DateTime(anio, mes, dia);
      } catch (e) {
        print('Error al parsear la fecha: $e');
        fecha = null;
      }
    }
    //PARAMETROS
    Map<String, dynamic> queryParams = {
      "pUserName": widget.pUserName,
      "pDocumento": "0",
      "pTipo_Documento": _seleccionadoTipoDocumento?.tipoDocumento.toString(),
      "pSerie_Documento":
          _seleccionadoSerieDocumento?.serieDocumento.toString(),
      "pEmpresa": widget.pEmpresa.toString(),
      "pLocalizacion": "1",
      "pEstacion_Trabajo": widget.pEstacion_Trabajo.toString(),
      "pFecha_Reg": "0",
      "pFecha_Documento":
          _fechaController.text.isEmpty ? null : fecha.toString(),
      "pCuenta_Correntista": widget.selectedCuentaCorrentista.toString(),
      "pCuenta_Cta": widget.selectedCuentaCta.toString(),
      "pBloqueado": "false",
      "pEstado_Objeto": "1",
      "pMensaje": "''",
      "pResultado": "true",
      "pElemento_Asignado": null,
      "pReferencia": null,
      "pId_Documento": "231321", //de donde viene?
      "pRef_Serie": null,
      "pFecha_Vencimiento": null,
      "pCuenta_Correntista_Ref": null,
      "pAccion": "0",
      "pIVA_Exento": null,
      "pRef_Id_Documento": null,
      "pResultado_Opcion": null,
      "pBodega_Origen": null,
      "pBodega_Destino": null,
      "pObservacion_1": null,
      "pObservacion_2": null,
      "pObservacion_3": null,
    };

    // Imprimir la URL generada y los parámetros
    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    //Mensaje si no se ha seleccionado un tipo de documento
    if (_seleccionadoTipoDocumento?.tipoDocumento == null) {
      Mensajes.mensajeAdvertencia(
          context,
          S.of(context).noHayTipoDeDocumento,
          widget.temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          widget.temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          widget.temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      _cargandoAfectarCxC = false;
      return;
    }

    //Mensaje si no se ha seleccionado una serie
    if (_seleccionadoSerieDocumento?.serieDocumento == null) {
      Mensajes.mensajeAdvertencia(
          context,
          S.of(context).noHaySerie,
          widget.temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          widget.temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          widget.temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      _cargandoAfectarCxC = false;
      return;
    }

    //Mensaje si no se ha seleccionado el tipo de pago
    if (_seleccionadoTipoCargoAbono?.tipoCargoAbono == null) {
      Mensajes.mensajeAdvertencia(
          context,
          S.of(context).noHayTipoPago,
          widget.temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          widget.temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          widget.temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      _cargandoAfectarCxC = false;
      return;
    }

    //Mensaje si no se ha seleccionado una fecha requerida
    if (_seleccionadoTipoCargoAbono?.reqFecha == 1 &&
        _fechaController.text == "") {
      setState(() {
        _focusFecha.requestFocus();
      });
      Mensajes.mensajeAdvertencia(
          context,
          S.of(context).requiereFecha,
          widget.temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          widget.temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          widget.temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      _cargandoAfectarCxC = false;
      return;
    }

    //Mensaje si no se ha ingresado autorizacion requerida
    if (_seleccionadoTipoCargoAbono?.autorizacion == 1 &&
        _autorizacionController.text == "") {
      setState(() {
        _focusAutorizacion.requestFocus();
      });
      Mensajes.mensajeAdvertencia(
          context,
          S.of(context).requiereAutorizacion,
          widget.temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          widget.temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          widget.temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      _cargandoAfectarCxC = false;
      return;
    }

    //Mensaje si no se ha ingresado referencia requerida
    if (_seleccionadoTipoCargoAbono?.referencia == 1 &&
        _referenciaController.text == "") {
      setState(() {
        _focusReferencia.requestFocus();
      });
      Mensajes.mensajeAdvertencia(
          context,
          S.of(context).requiereReferencia,
          widget.temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          widget.temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          widget.temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      _cargandoAfectarCxC = false;
      return;
    }

    //Mensaje si no se ha seleccionado banco requerido
    if (_seleccionadoTipoCargoAbono?.banco == true &&
        _seleccionadoBanco?.banco == null) {
      Mensajes.mensajeAdvertencia(
          context,
          S.of(context).noHayBanco,
          widget.temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          widget.temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          widget.temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      _cargandoAfectarCxC = false;
      return;
    }

    //Mensaje si no se ha seleccionado cuenta bancaria requerida
    if (_seleccionadoTipoCargoAbono?.reqCuentaBancaria == 1 &&
        _seleccionadoCuentaBancaria?.cuentaBancaria == null) {
      Mensajes.mensajeAdvertencia(
          context,
          S.of(context).noHayCuentaBancaria,
          widget.temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          widget.temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          widget.temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      _cargandoAfectarCxC = false;
      return;
    }

    //Mensaje si no se ha ingresado monto requerido
    if (_montoController.text.isEmpty && _afectar == false) {
      setState(() {
        _focusMonto.requestFocus();
      });
      Mensajes.mensajeAdvertencia(
          context,
          S.of(context).noHayMonto,
          widget.temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          widget.temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          widget.temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      _cargandoAfectarCxC = false;
      return;
    }

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });
      print('Response Status Code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaDocumentoValidar1M> validarD = jsonResponse
            .map((data) => PaDocumentoValidar1M.fromJson(data))
            .toList();

        // ignore: unnecessary_type_check
        if (jsonResponse is List) {
          _validarD = validarD;

          if (validarD.isNotEmpty && validarD[0].resultado == false) {
            // Mostrar mensaje de advertencia
            _mostrarDialogoAdvertencia(validarD[0].mensaje);
          } else {
            // Mostrar mensaje de confirmación
            Mensajes.mostrarDialogoConfirmacion(
                context,
                _crearEncabezadoDocumento,
                _DesplazarScroll,
                S.of(context).deseaCrearDocumento,
                widget.temaClaro
                    ? Colors.white
                    : Color.fromARGB(255, 73, 73, 73),
                widget.temaClaro
                    ? Color.fromARGB(255, 83, 83, 83)
                    : Colors.white,
                widget.temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
          }
        } else {
          print('Error: La respuesta no es una lista');
        }
      } else {
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error during HTTP request: $error');
    } finally {
      setState(() {
        _cargandoAfectarCxC = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> _crearEncabezadoDocumento() async {
    String url = '${widget.baseUrl}PaTblDocumentoCtrl';

    String fechaTexto = _fechaController.text;
    DateTime? pFecha_Documento;

    if (fechaTexto.isEmpty) {
      pFecha_Documento = null;
    } else {
      try {
        List<String> partes = fechaTexto.split('/');
        int dia = int.parse(partes[0]);
        int mes = int.parse(partes[1]);
        int anio = int.parse(partes[2]);
        pFecha_Documento = DateTime(anio, mes, dia);
      } catch (e) {
        print('Error al parsear la fecha: $e');
        pFecha_Documento = minDate;
      }
    }
    String fechaISO8601 = pFecha_Documento?.toIso8601String() ?? '';

    Map<String, dynamic> requestBody = {
      "TAccion": 1,
      "Documento": 0,
      "Tipo_Documento": _seleccionadoTipoDocumento?.tipoDocumento,
      "Serie_Documento": _seleccionadoSerieDocumento?.serieDocumento.toString(),
      "Empresa": widget.pEmpresa,
      "Localizacion": 1,
      "Estacion_Trabajo": widget.pEstacion_Trabajo,
      "Fecha_Reg": 0,
      "Fecha_Hora": minDate.toIso8601String(),
      "UserName": widget.pUserName,
      "M_Fecha_Hora": null,
      "M_UserName": null,
      "Cuenta_Correntista": widget.selectedCuentaCorrentista,
      "Cuenta_Cta": widget.selectedCuentaCta,
      "Id_Documento": "''",
      "Documento_Nombre": widget.facturaNombre,
      "Documento_NIT": widget.facturaNit,
      "Documento_Direccion": widget.facturaDireccion,
      "Id_Reservacion": null,
      "Bodega_Origen": null,
      "Bodega_Destino": null,
      "Observacion_1": _observacionController.text,
      "Fecha_Documento": _fechaController.text.isEmpty
          ? minDate.toIso8601String()
          : fechaISO8601,
      "Observacion_2": null,
      "Elemento_Asignado": null,
      "Estado_Documento": 1,
      "Impresion_Doc": null,
      "Referencia": null,
      "Doc_Det": null,
      "Fecha_Ini": null,
      "Fecha_Fin": null,
      "Fecha_Vencimiento": null,
      "Per_O_Cargos": null,
      "Clasificacion": null,
      "Cierre": null,
      "Fecha_Documento_Aux": null,
      "Ref_Serie": null,
      "Contabilizado": null,
      "Turno": null,
      "Observacion_3": null,
      "Cuenta_Correntista_Ref": null,
      "Cambio": null,
      "Cambio_Moneda": null,
      "Bloqueado": null,
      "Bloquear_Venta": null,
      "Razon": null,
      "Proceso": null,
      "Consecutivo_Interno": null,
      "Cuenta_Correntista_Ref_2": null,
      "Localizacion_Ref": null,
      "Tipo_Pago": null,
      "Campo_1": null,
      "Campo_2": null,
      "Campo_3": null,
      "Fecha_Hora_N": null,
      "Fecha_Documento_N": null,
      "Seccion": null,
      "Tipo_Actividad": null,
      "Cierre_Contable": null,
      "Id_Unc": null,
      "IVA_Exento": null,
      "TOpcion": 1,
      "Ref_Fecha_Documento": null,
      "Ref_Fecha_Vencimiento": null,
      "T_Tra_M": null,
      "T_Tra_MM": null,
      "T_Car_Abo_M": null,
      "T_Car_Abo_MM": null,
      "Propina_Monto": null,
      "Propina_Monto_Moneda": null,
      "Ref_Id_Documento": null,
      "T_Tra_M_NImp": null,
      "T_Tra_MM_NImp": null,
      "T_Tra_M_Imp_IVA": null,
      "T_Tra_MM_Imp_IVA": null,
      "T_Tra_M_Imp_ITU": null,
      "T_Tra_MM_Imp_ITU": null,
      "T_Tra_M_Propina": null,
      "T_Tra_MM_Propina": null,
      "T_Tra_M_Cargo": null,
      "T_Tra_MM_Cargo": null,
      "T_Tra_M_Descuento": null,
      "T_Tra_MM_Descuento": null,
      "T_Car_Abo_M_Por_Aplicar": null,
      "T_Car_Abo_MM_Por_Aplicar": null,
      "T_Tra_M_Sub": null,
      "T_Tra_MM_Sub": null,
      "Vehiculo_Marca": null,
      "Vehiculo_Modelo": null,
      "Vehiculo_Year": null,
      "Vehiculo_Color": null,
      "Survey_Record": null,
      "Periodo": null,
      "Adults": null,
      "Childrens": null,
      "Id_Doc_Alt": null,
      "ISR_Retener": null,
      "FE_Cae": null,
      "FE_numeroDocumento": null,
      "FE_numeroDte": null,
      "GPS_Latitud": null,
      "GPS_Longitud": null,
      "Consecutivo_Interno_Ref": null,
      "FEL_UUID_Anulacion": null,
      "FEL_Numero_Acceso": null,
      "FE_Fecha_Certificacion": null,
      "Id_Unc_Sync": null,
      "RecaptchaToken": "",
      "IsMobile": true
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}"
        },
        body: jsonEncode(requestBody),
      );
      print("se esta ejecutando el encabezado");
      if (response.statusCode == 200) {
        print("status: ${response.statusCode}");
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaTblDocumentoM> documento =
            jsonResponse.map((data) => PaTblDocumentoM.fromJson(data)).toList();
        print("se creo bien el encabezado");
        print('Response body: ${response.body}');
        _documento = documento;

        await _validarCargoAbono();
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Código de estado en el rango 400-499 (errores del cliente)
        print('Error del cliente: ${response.statusCode}');
        print('Respuesta del error: ${response.body}');
      } else if (response.statusCode >= 500) {
        // Código de estado en el rango 500-599 (errores del servidor)
        print('Error del servidor: ${response.statusCode}');
        print('Respuesta del error: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _validarCargoAbono() async {
    setState(() {
      _cargandoAfectarCxC =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaCargoAbonoValidar1Ctrl';

    String fechaTexto = _fechaController.text;
    DateTime? fecha;

    if (fechaTexto.isEmpty) {
      fecha = null;
    } else {
      try {
        List<String> partes = fechaTexto.split('/');
        int dia = int.parse(partes[0]);
        int mes = int.parse(partes[1]);
        int anio = int.parse(partes[2]);
        fecha = DateTime(anio, mes, dia);
      } catch (e) {
        print('Error al parsear la fecha: $e');
        fecha = null;
      }
    }

    String montoTexto = _montoController.text.trim();

    montoTexto = montoTexto.replaceAll(',', '.');

    double? monto;

    try {
      monto = double.parse(montoTexto);
    } catch (e) {
      print('Error al parsear el monto: $e');
      monto = 0.0;
    }

    List<double> montosValidos = widget.montosGuardados
        .where((monto) => monto != 0.0 && monto != null)
        .toList();
    montosValidos = montosValidos
        .map((monto) => double.parse(monto.toStringAsFixed(2)))
        .toList();

    Map<String, dynamic> queryParams = {
      "pUserName": widget.pUserName, //widget.pUserName
      "pCargo_Abono": "0",
      "pEmpresa": widget.pEmpresa.toString(),
      "pLocalizacion": "1",
      "pEstacion_Trabajo": widget.pEstacion_Trabajo.toString(),
      "pFecha_Reg": "0",
      "pD_Documento": _documento[0].Documento.toString(),
      "pD_Tipo_Documento": _documento[0].Tipo_Documento.toString(),
      "pD_Serie_Documento": _documento[0].Serie_Documento.toString(),
      "pD_Empresa": _documento[0].Empresa.toString(),
      "pD_Localizacion": _documento[0].Localizacion.toString(),
      "pD_Estacion_Trabajo": _documento[0].Estacion_Trabajo.toString(),
      "pD_Fecha_Reg": _documento[0].Fecha_Reg.toString(),
      "pTipo_Cargo_Abono":
          _seleccionadoTipoCargoAbono?.tipoCargoAbono.toString(),
      "pMonto": _afectar
          ? (montosValidos.length > 0 ? montosValidos[0].toString() : "0.0")
          : monto.toString(),
      "pMonto_Moneda": (monto / 7).toString(),
      "pTipo_Cambio": "7",
      "pMoneda": "1",
      "pMensaje": null,
      "pResultado": "true",
      "pRef_Documento": _referenciaController.text.isEmpty
          ? null
          : _referenciaController.text,
      "pCuenta_Bancaria": _seleccionadoCuentaBancaria?.cuentaBancaria == null
          ? null
          : _seleccionadoCuentaBancaria?.cuentaBancaria.toString(),
      "pReferencia": _referenciaController.text.isEmpty
          ? null
          : _referenciaController.text,
      "pAutorizacion": _autorizacionController.text.isEmpty
          ? null
          : _autorizacionController.text,
      "pTrigger_Ins": "true",
      "pVer_Tabla": "true",
      "pRef_Fecha": _fechaController.text.isEmpty ? null : fecha.toString(),
      "pResultado_Opcion": "1",
      "pBanco": _seleccionadoBanco?.banco == null
          ? null
          : _seleccionadoBanco?.banco.toString(),
    };

    print(queryParams);
    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);
    print("se esta ejecutando validacion CA");
    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaCargoAbonoValidar1M> validarCargoA = jsonResponse
            .map((data) => PaCargoAbonoValidar1M.fromJson(data))
            .toList();
        print("se ejecuto validacion CA");
        // Verificar si la respuesta es una lista
        // ignore: unnecessary_type_check
        if (jsonResponse is List) {
          // Convertir la respuesta en objetos de modelo si es una lista
          _validarCargoA = validarCargoA;

          if (_validarCargoA.isNotEmpty &&
              _validarCargoA[0].resultado == false) {
            // Mostrar mensaje de advertencia
            _mostrarDialogoAdvertencia(_validarCargoA[0].mensaje);
          } else {
            //Mensaje si no se ha seleccionado un tipo de documento
            if (_seleccionadoTipoDocumento?.tipoDocumento == null) {
              Mensajes.mensajeAdvertencia(
                  context,
                  S.of(context).noHayTipoDeDocumento,
                  widget.temaClaro
                      ? Colors.white
                      : Color.fromARGB(255, 73, 73, 73),
                  widget.temaClaro
                      ? Color.fromARGB(255, 83, 83, 83)
                      : Colors.white,
                  widget.temaClaro
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Colors.white);
              _cargandoAfectarCxC = false;
              return;
            }

            //Mensaje si no se ha seleccionado una serie
            if (_seleccionadoSerieDocumento?.serieDocumento == null) {
              Mensajes.mensajeAdvertencia(
                  context,
                  S.of(context).noHaySerie,
                  widget.temaClaro
                      ? Colors.white
                      : Color.fromARGB(255, 73, 73, 73),
                  widget.temaClaro
                      ? Color.fromARGB(255, 83, 83, 83)
                      : Colors.white,
                  widget.temaClaro
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Colors.white);
              _cargandoAfectarCxC = false;
              return;
            }

            //Mensaje si no se ha seleccionado el tipo de pago
            if (_seleccionadoTipoCargoAbono?.tipoCargoAbono == null) {
              Mensajes.mensajeAdvertencia(
                  context,
                  S.of(context).noHayTipoPago,
                  widget.temaClaro
                      ? Colors.white
                      : Color.fromARGB(255, 73, 73, 73),
                  widget.temaClaro
                      ? Color.fromARGB(255, 83, 83, 83)
                      : Colors.white,
                  widget.temaClaro
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Colors.white);
              _cargandoAfectarCxC = false;
              return;
            }

            //Mensaje si no se ha seleccionado una fecha requerida
            if (_seleccionadoTipoCargoAbono?.reqFecha == 1 &&
                _fechaController.text == "") {
              setState(() {
                _focusFecha.requestFocus();
              });
              Mensajes.mensajeAdvertencia(
                  context,
                  S.of(context).requiereFecha,
                  widget.temaClaro
                      ? Colors.white
                      : Color.fromARGB(255, 73, 73, 73),
                  widget.temaClaro
                      ? Color.fromARGB(255, 83, 83, 83)
                      : Colors.white,
                  widget.temaClaro
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Colors.white);
              _cargandoAfectarCxC = false;
              return;
            }

            //Mensaje si no se ha ingresado autorizacion requerida
            if (_seleccionadoTipoCargoAbono?.autorizacion == 1 &&
                _autorizacionController.text == "") {
              setState(() {
                _focusAutorizacion.requestFocus();
              });
              Mensajes.mensajeAdvertencia(
                  context,
                  S.of(context).requiereAutorizacion,
                  widget.temaClaro
                      ? Colors.white
                      : Color.fromARGB(255, 73, 73, 73),
                  widget.temaClaro
                      ? Color.fromARGB(255, 83, 83, 83)
                      : Colors.white,
                  widget.temaClaro
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Colors.white);
              _cargandoAfectarCxC = false;
              return;
            }

            //Mensaje si no se ha ingresado referencia requerida
            if (_seleccionadoTipoCargoAbono?.referencia == 1 &&
                _referenciaController.text == "") {
              setState(() {
                _focusReferencia.requestFocus();
              });
              Mensajes.mensajeAdvertencia(
                  context,
                  S.of(context).requiereReferencia,
                  widget.temaClaro
                      ? Colors.white
                      : Color.fromARGB(255, 73, 73, 73),
                  widget.temaClaro
                      ? Color.fromARGB(255, 83, 83, 83)
                      : Colors.white,
                  widget.temaClaro
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Colors.white);
              _cargandoAfectarCxC = false;
              return;
            }

            //Mensaje si no se ha seleccionado banco requerido
            if (_seleccionadoTipoCargoAbono?.banco == true &&
                _seleccionadoBanco?.banco == null) {
              Mensajes.mensajeAdvertencia(
                  context,
                  S.of(context).noHayBanco,
                  widget.temaClaro
                      ? Colors.white
                      : Color.fromARGB(255, 73, 73, 73),
                  widget.temaClaro
                      ? Color.fromARGB(255, 83, 83, 83)
                      : Colors.white,
                  widget.temaClaro
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Colors.white);
              _cargandoAfectarCxC = false;
              return;
            }

            //Mensaje si no se ha seleccionado cuenta bancaria requerida
            if (_seleccionadoTipoCargoAbono?.reqCuentaBancaria == 1 &&
                _seleccionadoCuentaBancaria?.cuentaBancaria == null) {
              Mensajes.mensajeAdvertencia(
                  context,
                  S.of(context).noHayCuentaBancaria,
                  widget.temaClaro
                      ? Colors.white
                      : Color.fromARGB(255, 73, 73, 73),
                  widget.temaClaro
                      ? Color.fromARGB(255, 83, 83, 83)
                      : Colors.white,
                  widget.temaClaro
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Colors.white);
              _cargandoAfectarCxC = false;
              return;
            }

            //Mensaje si no se ha ingresado monto requerido
            if (_montoController.text.isEmpty && _afectar == false) {
              setState(() {
                _focusMonto.requestFocus();
              });
              Mensajes.mensajeAdvertencia(
                  context,
                  S.of(context).noHayMonto,
                  widget.temaClaro
                      ? Colors.white
                      : Color.fromARGB(255, 73, 73, 73),
                  widget.temaClaro
                      ? Color.fromARGB(255, 83, 83, 83)
                      : Colors.white,
                  widget.temaClaro
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Colors.white);
              _cargandoAfectarCxC = false;
              return;
            }
            if (_afectar == false) {
              print("Se esta ejecutando el cargo abono");
              _crearCargoAbono();
              _DesplazarScroll();
            } else {
              _crearCargoAbonoAfectar();
            }
          }
          setState(() {});
        } else {
          print('Error: La respuesta no es una lista');
        }
      } else {
        print('Error: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoAfectarCxC = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> _crearCargoAbono() async {
    setState(() {
      _cargandoAfectarCxC =
          true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaTblCargoAbonoCtrl';
    String fechaTexto = _fechaController.text;
    DateTime? fecha;

    if (fechaTexto.isEmpty) {
      fecha = null;
    } else {
      try {
        List<String> partes = fechaTexto.split('/');
        int dia = int.parse(partes[0]);
        int mes = int.parse(partes[1]);
        int anio = int.parse(partes[2]);
        fecha = DateTime(anio, mes, dia);
      } catch (e) {
        print('Error al parsear la fecha: $e');
        fecha = null;
      }
    }

    // Mantén minDate como DateTime
    DateTime minDate = DateTime.now();
    String montoTexto = _montoController.text.trim();

    // Reemplazar comas por puntos
    montoTexto = montoTexto.replaceAll(',', '.');

    // Validar que el texto contiene solo números y un punto decimal
    if (!RegExp(r'^[0-9]*\.?[0-9]+$').hasMatch(montoTexto)) {
      print('Error: El texto de monto no es un número válido.');
      return; // Terminar la función si el texto no es válido
    }

    double? monto;

    try {
      monto = double.parse(montoTexto);
    } catch (e) {
      print('Error al parsear el monto: $e');
      monto = 0.0;
    }
    print("Se esta ejecutando el cargo abono");
    Map<String, dynamic> requestBody = {
      "TAccion": 1,
      "Cargo_Abono": 0,
      "Empresa": widget.pEmpresa,
      "Localizacion": 1,
      "Estacion_Trabajo": widget.pEstacion_Trabajo,
      "Fecha_Reg": 0,
      "Tipo_Cargo_Abono": _seleccionadoTipoCargoAbono?.tipoCargoAbono,
      "Estado": 1,
      "Fecha_Hora": minDate.toIso8601String(),
      "UserName": widget.pUserName,
      "M_Fecha_Hora": null,
      "M_UserName": null,
      "Monto": monto,
      "Tipo_Cambio": 7,
      "Moneda": 1,
      "Monto_Moneda": (monto / 7),
      "Referencia": _referenciaController.text.isEmpty
          ? null
          : _referenciaController.text,
      "Autorizacion": _autorizacionController.text.isEmpty
          ? null
          : _autorizacionController.text,
      "Banco":
          _seleccionadoBanco?.banco == null ? null : _seleccionadoBanco?.banco,
      "Observacion_1": _observacionController.text.isEmpty
          ? null
          : _observacionController.text,
      "Razon": null,
      "D_Documento": _documento[0].Documento,
      "D_Tipo_Documento": _documento[0].Tipo_Documento,
      "D_Serie_Documento": _documento[0].Serie_Documento,
      "D_Empresa": _documento[0].Empresa,
      "D_Localizacion": _documento[0].Localizacion,
      "D_Estacion_Trabajo": _documento[0].Estacion_Trabajo,
      "D_Fecha_Reg": _documento[0].Fecha_Reg,
      "Propina": null,
      "Propina_Moneda": null,
      "Monto_O": null,
      "Monto_O_Moneda": null,
      "F_Cuenta_Corriente_Padre": null,
      "F_Cobrar_Pagar_Padre": null,
      "F_Empresa_Padre": null,
      "F_Localizacion_Padre": null,
      "F_Estacion_Trabajo_Padre": null,
      "F_Fecha_Reg_Padre": null,
      "Ref_Documento": _referenciaController.text.isEmpty
          ? null
          : _referenciaController.text,
      "Cuenta_Bancaria": _seleccionadoCuentaBancaria?.cuentaBancaria == null
          ? null
          : _seleccionadoCuentaBancaria?.cuentaBancaria,
      "Propina_Monto": null,
      "Propina_Monto_Moneda": null,
      "Cuenta_PIN": null,
      "TOpcion": 1,
      "Fecha_Ref":
          _fechaController.text.isEmpty ? null : fecha?.toIso8601String(),
      "Consecutivo_Interno_Ref": null,
      "RecaptchaToken": "",
      "IsMobile": true
    };
    print("se esta creando CA");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}"
        },
        body: jsonEncode(requestBody), // Convertir el cuerpo a JSON
      );
      if (response.statusCode == 200) {
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaTblCargoAbonoM> cargoAbono = jsonResponse
            .map((data) => PaTblCargoAbonoM.fromJson(data))
            .toList();
        print("se esta creo CA");
        registrosCargoAbono = [];
        registrosCargoAbono.addAll(cargoAbono);
        setState(() {
          _creadoAfectar = false;
          _cargoAbono = cargoAbono;
          _mostrarTabla = cargoAbono
              .isNotEmpty; // Actualizar para mostrar la tabla si hay datos
          _focusId.unfocus();
          _focusFecha.unfocus();
          _focusMonto.unfocus();
          _focusReferencia.unfocus();
          _focusAutorizacion.unfocus();
          _focusObservacion.unfocus();
          _seleccionadoTipoCargoAbono = null;
          _seleccionadoBanco = null;
          _seleccionadoCuentaBancaria = null;
          _fechaController.text = '';
          _referenciaController.text = "";
          _autorizacionController.text = "";
          _montoController.text = "";
        });

        print(response.statusCode);
      } else {
        print('Error: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoAfectarCxC = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> _crearCargoAbonoAfectar() async {
    setState(() {
      _cargandoAfectarCxC =
          true; // Establecer isLoading a true al inicio de la carga
    });
    try {
      List<double> montosValidos =
          widget.montosGuardados.where((monto) => monto != 0.0).toList();

      String url = '${widget.baseUrl}PaTblCargoAbonoCtrl';
      String fechaTexto = _fechaController.text;
      DateTime? fecha;

      if (widget.montosGuardados.isEmpty) {
        print('La lista de montos guardados está vacía.');
        return;
      }

      if (fechaTexto.isEmpty) {
        fecha = null;
      } else {
        try {
          List<String> partes = fechaTexto.split('/');
          int dia = int.parse(partes[0]);
          int mes = int.parse(partes[1]);
          int anio = int.parse(partes[2]);
          fecha = DateTime(anio, mes, dia);
        } catch (e) {
          print('Error al parsear la fecha: $e');
          fecha = null;
        }
      }

      if (widget.documentosSeleccionados.isEmpty) {
        Mensajes.mensajeAdvertencia(
            context,
            S.of(context).seleccionarDocParaAfectar,
            widget.temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
            widget.temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
            widget.temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
        return;
      }

      for (int i = 0; i < montosValidos.length; i++) {
        double montoAplicando = montosValidos[i];
        Map<String, dynamic> requestBody = {
          "TAccion": 1,
          "Cargo_Abono": 0,
          "Empresa": widget.pEmpresa,
          "Localizacion": 1,
          "Estacion_Trabajo": widget.pEstacion_Trabajo,
          "Fecha_Reg": 0,
          "Tipo_Cargo_Abono": _seleccionadoTipoCargoAbono?.tipoCargoAbono,
          "Estado": 1,
          "Fecha_Hora": minDate.toIso8601String(),
          "UserName": widget.pUserName,
          "M_Fecha_Hora": null,
          "M_UserName": null,
          "Monto": montoAplicando,
          "Tipo_Cambio": 7,
          "Moneda": 1,
          "Monto_Moneda": montoAplicando,
          "Referencia": _referenciaController.text.isEmpty
              ? null
              : _referenciaController.text,
          "Autorizacion": _autorizacionController.text.isEmpty
              ? null
              : _autorizacionController.text,
          "Banco": _seleccionadoBanco?.banco == null
              ? null
              : _seleccionadoBanco?.banco,
          "Observacion_1": _observacionController.text.isEmpty
              ? null
              : _observacionController.text,
          "Razon": null,
          "D_Documento": _documento[0].Documento,
          "D_Tipo_Documento": _documento[0].Tipo_Documento,
          "D_Serie_Documento": _documento[0].Serie_Documento,
          "D_Empresa": _documento[0].Empresa,
          "D_Localizacion": _documento[0].Localizacion,
          "D_Estacion_Trabajo": _documento[0].Estacion_Trabajo,
          "D_Fecha_Reg": _documento[0].Fecha_Reg,
          "Propina": null,
          "Propina_Moneda": null,
          "Monto_O": null,
          "Monto_O_Moneda": null,
          "F_Cuenta_Corriente_Padre":
              widget.documentosSeleccionados[i].cuentaCorriente,
          "F_Cobrar_Pagar_Padre": widget.documentosSeleccionados[i].cobrarPagar,
          "F_Empresa_Padre": widget.documentosSeleccionados[i].empresa,
          "F_Localizacion_Padre":
              widget.documentosSeleccionados[i].localizacion,
          "F_Estacion_Trabajo_Padre":
              widget.documentosSeleccionados[i].estacionTrabajo,
          "F_Fecha_Reg_Padre": widget.documentosSeleccionados[i].fechaReg,
          "Ref_Documento": _referenciaController.text.isEmpty
              ? null
              : _referenciaController.text,
          "Cuenta_Bancaria": _seleccionadoCuentaBancaria?.cuentaBancaria == null
              ? null
              : _seleccionadoCuentaBancaria?.cuentaBancaria,
          "Propina_Monto": null,
          "Propina_Monto_Moneda": null,
          "Cuenta_PIN": null,
          "TOpcion": 1,
          "Fecha_Ref":
              _fechaController.text.isEmpty ? null : fecha?.toIso8601String(),
          "Consecutivo_Interno_Ref": null,
          "RecaptchaToken": "",
          "IsMobile": true
        };

        print("Parametros CAA: ${jsonEncode(requestBody)}");
        print("se esta creando CA AFECTAR CXC");

        final response = await http.post(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${widget.token}"
          },
          body: jsonEncode(requestBody), // Convertir el cuerpo a JSON
        );

        if (response.statusCode == 200) {
          // respuesta JSON a lista
          List<dynamic> jsonResponse = json.decode(response.body);
          List<PaTblCargoAbonoM> cargoAbono = jsonResponse
              .map((data) => PaTblCargoAbonoM.fromJson(data))
              .toList();
          print("se  creo CA AFECTAR CXC");
          print("CA: " + "${response.body}");
          registrosCargoAbonoAfectar.addAll(cargoAbono);
          registrosCargoAbonoAfectarA.addAll(cargoAbono);
          _totalMontoAfectar = registrosCargoAbonoAfectarA.fold(
              0.0, (sum, item) => sum + item.Monto);
          setState(() {
            _creadoAfectar = true;
            _cargoAbono = cargoAbono;
            _mostrarTabla = cargoAbono
                .isNotEmpty; // Actualizar para mostrar la tabla si hay datos
            _focusId.unfocus();
            _focusFecha.unfocus();
            _focusMonto.unfocus();
            _focusReferencia.unfocus();
            _focusAutorizacion.unfocus();
            _focusObservacion.unfocus();
          });

          print(response.statusCode);
        } else {
          print('Error: ${response.statusCode}');
          print('Error: ${response.body}');
        }
      }
      crearDocumentoAplicar(_totalMontoAfectar);
      registrosCargoAbonoAfectarA.clear();
      _seleccionadoTipoCargoAbono = null;
      _seleccionadoBanco = null;
      _seleccionadoCuentaBancaria = null;
      _fechaController.text = '';
      _referenciaController.text = "";
      _autorizacionController.text = "";
      _montoController.text = "";
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _cargandoAfectarCxC = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  Future<void> crearDocumentoAplicar(double pCAMontoTotal) async {
    String url = '${widget.baseUrl}PaDocumentoAplicar31Ctrl';
    List<CuentaCorriente> cuentaCorriente = [];
    List<double> montosValidos =
        widget.montosGuardados.where((monto) => monto != 0.0).toList();
    for (int i = 0; i < montosValidos.length; i++) {
      double montoAplicando = montosValidos[i];
      cuentaCorriente.add(CuentaCorriente(
        cCCuentaCorriente: widget.documentosSeleccionados[i].cuentaCorriente,
        cCCobrarPagar: widget.documentosSeleccionados[i].cobrarPagar,
        cCEmpresa: widget.documentosSeleccionados[i].empresa,
        cCLocalizacion: widget.documentosSeleccionados[i].localizacion,
        cCEstacionTrabajo: widget.documentosSeleccionados[i].estacionTrabajo,
        cCFechaReg: widget.documentosSeleccionados[i].fechaReg,
        cCDDocumento: _documento[0].Documento,
        cCDTipoDocumento: _documento[0].Tipo_Documento,
        cCDSerieDocumento: _documento[0].Serie_Documento,
        cCDEmpresa: _documento[0].Empresa,
        cCDLocalizacion: _documento[0].Localizacion,
        cCDEstacionTrabajo: _documento[0].Estacion_Trabajo,
        cCDFechaReg: _documento[0].Fecha_Reg,
        cCMonto: montoAplicando,
        cCMontoM: montoAplicando / 7,
        cCCuentaCorrentista: widget.selectedCuentaCorrentista,
        cCCuentaCta: widget.selectedCuentaCta,
      ));
    }

    DocumentoAplicarParametros parametros = DocumentoAplicarParametros(
        pOpcion: 1,
        pUserName: widget.pUserName,
        pTipoCambio: 7,
        pMoneda: 1,
        pMensaje: "",
        pResultado: true,
        pDocCCDocumento: _documento[0].Documento,
        pDocCCTipoDocumento: _documento[0].Tipo_Documento,
        pDocCCSerieDocumento: _documento[0].Serie_Documento,
        pDocCCEmpresa: _documento[0].Empresa,
        pDocCCLocalizacion: _documento[0].Localizacion,
        pDocCCEstacionTrabajo: _documento[0].Estacion_Trabajo,
        pDocCCFechaReg: _documento[0].Fecha_Reg,
        pDocCCCuentaCorrentista: _documento[0].Cuenta_Correntista,
        pDocCCCuentaCta: _documento[0].Cuenta_Cta,
        pDocCCFechaDocumento: _documento[0].Fecha_Documento,
        pCAMontoTotal: pCAMontoTotal,
        pTCAMonto: _seleccionadoTipoDocumento?.opcVerificar,
        pEstructura: Estructura(cuentaCorriente: cuentaCorriente),
        recaptchaToken: "",
        isMobile: true);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${widget.token}"
      },
      body: jsonEncode(parametros.toJson()),
    );

    if (response.statusCode == 200) {
      // Procesar la respuesta
      print('Éxito: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
      print(response.body);
    }
    widget.documentosSeleccionados.clear();
  }

  void _mostrarBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.temaClaro ? Colors.white : Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        final logoSize = screenSize.width * 0.2; // Ajuste dinámico del logo

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          decoration: BoxDecoration(
            color: widget.temaClaro
                ? Colors.white
                : const Color.fromARGB(221, 46, 46, 46),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Logo y Nombre de la Empresa
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: logoSize,
                        width: logoSize,
                        color: !widget.temaClaro
                            ? Colors.white
                            : null, // Logo blanco en modo oscuro
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Desarrollo Moderno de Software, S. A.",
                        style: TextStyle(
                          fontSize: screenSize.width * 0.04, // Texto responsive
                          color: !widget.temaClaro
                              ? Colors.white70
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0), // Espacio entre logo y contenido

                // Contenido de selección en la creación de documento
                if (_seleccionadoTipoDocumento != null)
                  _buildListTile(
                    context: context,
                    icon: Icons.description,
                    label: S.of(context).tipoDocumento,
                    value: DocumentoTraduccion.traducirTipoDocumento(
                        _seleccionadoTipoDocumento?.descripcion ?? '', context),
                    temaClaro: widget.temaClaro,
                    colorClaro: Colors.blue,
                  ),

                if (_seleccionadoSerieDocumento != null)
                  _buildListTile(
                    context: context,
                    icon: Icons.document_scanner_outlined,
                    label: S.of(context).serieDocumento,
                    value: _seleccionadoSerieDocumento?.descripcion ?? '',
                    temaClaro: widget.temaClaro,
                    colorClaro: Colors.blue,
                  ),

                if (_seleccionadoTipoCargoAbono != null)
                  _buildListTile(
                    context: context,
                    icon: FontAwesomeIcons.handHoldingDollar,
                    label: S.of(context).tipodePago,
                    value: DocumentoTraduccion.traducirTipoPago(
                        _seleccionadoTipoCargoAbono?.descripcion ?? '',
                        context),
                    temaClaro: widget.temaClaro,
                    colorClaro: Colors.green,
                  ),

                if (_seleccionadoBanco != null)
                  _buildListTile(
                    context: context,
                    icon: Icons.account_balance,
                    label: S.of(context).banco,
                    value: _seleccionadoBanco?.nombre ?? '',
                    temaClaro: widget.temaClaro,
                    colorClaro: Color.fromARGB(255, 249, 116, 22),
                  ),

                if (_seleccionadoCuentaBancaria != null)
                  _buildListTile(
                    context: context,
                    icon: FontAwesomeIcons.creditCard,
                    label: S.of(context).cuentaBancaria,
                    value: _seleccionadoCuentaBancaria?.descripcion ?? '',
                    temaClaro: widget.temaClaro,
                    colorClaro: Color.fromARGB(255, 90, 33, 182),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required bool temaClaro,
    required Color colorClaro,
  }) {
    return Column(
      children: [
        Divider(color: !temaClaro ? Colors.white24 : Colors.grey),
        ListTile(
          leading: Icon(icon, color: colorClaro),
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    color: !temaClaro ? Colors.white70 : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: !temaClaro ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.pop(context); // Cerrar BottomSheet
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: widget.temaClaro
                        ? Color.fromARGB(255, 236, 236, 236)
                        : Color.fromARGB(255, 0, 5, 44),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    //TITULO DE SECCIÓN CREACIÓN RECIBO:
                    Text(
                      S.of(context).creacionReciboTitulo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color:
                              widget.temaClaro ? Colors.black : Colors.white),
                    ),
                    SizedBox(height: 16),
                    //SECCIÓN TIPO DOCUMENTO
                    ExpansionTile(
                      backgroundColor: widget.temaClaro
                          ? Color.fromARGB(255, 230, 244, 245)
                          : Color.fromARGB(255, 61, 61, 61),
                      title: Text(
                        S.of(context).tipoDocumento,
                        style: TextStyle(
                          fontSize: 18,
                          color: widget.temaClaro ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      initiallyExpanded: _isTipoDocumentoExpanded,
                      collapsedIconColor: Colors.amber,
                      collapsedTextColor:
                          widget.temaClaro ? Color(0xFF154790) : Colors.grey,
                      onExpansionChanged: (expanded) {
                        if (expanded) {
                          _verTipoDocumentoMovil();
                          _seleccionadoTipoDocumento?.tipoDocumento == 15;
                        }
                        setState(() {
                          _isTipoDocumentoExpanded = !_isTipoDocumentoExpanded;

                          // Si el ExpansionTile de Tipo de documento no está expandido,
                          if (!_isTipoDocumentoExpanded) {}
                        });
                      },
                      children: [
                        if (_cargandoTipoDocumento)
                          LoadingComponent(
                            color: Colors.blue[200]!,
                            changeLanguage: widget.changeLanguage,
                          ),
                        SingleChildScrollView(
                          child: Container(
                            height: 200,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _tiposD.length,
                              itemBuilder: (context, index) {
                                final tipoDocumento = _tiposD[index];

                                return RadioListTile<PaBscTipoDocumentoMovilM>(
                                  title: Text(
                                    _tiposD.length > 0
                                        ? DocumentoTraduccion
                                            .traducirTipoDocumento(
                                                tipoDocumento.descripcion,
                                                context)
                                        : S.of(context).conexionInternet,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: widget.temaClaro
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  value: tipoDocumento,
                                  groupValue: _seleccionadoTipoDocumento,
                                  onChanged: (PaBscTipoDocumentoMovilM? value) {
                                    setState(() {
                                      _seleccionadoTipoDocumento = value;
                                      _verSerieDocumento();
                                      _seleccionadoSerieDocumento = null;
                                      _seleccionadoTipoCargoAbono = null;
                                      _seleccionadoBanco = null;
                                      _seleccionadoCuentaBancaria = null;
                                      _fechaController.text = '';
                                      _referenciaController.text = "";
                                      _autorizacionController.text = "";
                                      _montoController.text = "";
                                    });
                                    print(
                                        'Tipo de Documento seleccionado: ${value?.tipoDocumento}');
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    //SECCIÓN SERIE
                    GestureDetector(
                      onTap: () {
                        if (_seleccionadoTipoDocumento == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.cyan,
                              content: Text(
                                S.of(context).antesTipoDocumento,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                      },
                      child: AbsorbPointer(
                        absorbing: _seleccionadoTipoDocumento == null,
                        child: ExpansionTile(
                          backgroundColor: widget.temaClaro
                              ? Color.fromARGB(255, 230, 244, 245)
                              : Color.fromARGB(255, 61, 61, 61),
                          title: Text(
                            S.of(context).series,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.temaClaro
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          initiallyExpanded: _isSerieDocumentoExpanded,
                          collapsedIconColor: Colors.amber,
                          collapsedTextColor: widget.temaClaro
                              ? Color(0xFF154790)
                              : Colors.grey,
                          onExpansionChanged: (expanded) {
                            if (expanded &&
                                _seleccionadoTipoDocumento != null) {
                              _verSerieDocumento();
                            }
                            setState(() {
                              _isSerieDocumentoExpanded =
                                  !_isSerieDocumentoExpanded;
                              // Si el ExpansionTile de Serie no está expandido,
                              if (!_isSerieDocumentoExpanded) {}
                            });
                          },
                          children: [
                            if (_cargandoSerieDocumento)
                              LoadingComponent(
                                color: Colors.blue[200]!,
                                changeLanguage: widget.changeLanguage,
                              ),
                            SingleChildScrollView(
                              child: Container(
                                height: 200,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _seriesD.length,
                                  itemBuilder: (context, index) {
                                    final serie = _seriesD[index];
                                    return RadioListTile<PaBscSerieDocumento1M>(
                                      title: Text(
                                        serie.descripcion,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: widget.temaClaro
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      value: serie,
                                      groupValue: _seleccionadoSerieDocumento,
                                      onChanged:
                                          (PaBscSerieDocumento1M? value) {
                                        setState(() {
                                          _seleccionadoSerieDocumento = value;
                                          _seleccionadoTipoCargoAbono = null;
                                          _seleccionadoBanco = null;
                                          _seleccionadoCuentaBancaria = null;
                                          _fechaController.text = '';
                                          _referenciaController.text = "";
                                          _autorizacionController.text = "";
                                          _montoController.text = "";
                                          _verTipoCargoAbono();
                                        });
                                        print(
                                            'Tipo de Documento seleccionado: ${value?.tipoDocumento}');
                                        print(
                                            'Serie seleccionado: ${value?.serieDocumento}');
                                        print(
                                            'Empresa seleccionado: ${value?.empresa}');
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    //SECCIÓN TIPO PAGO
                    GestureDetector(
                      onTap: () {
                        if (_seleccionadoSerieDocumento == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.cyan,
                              content: Text(
                                S.of(context).antesSerie,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                      },
                      child: AbsorbPointer(
                        absorbing: _seleccionadoSerieDocumento == null,
                        child: ExpansionTile(
                          backgroundColor: widget.temaClaro
                              ? Color.fromARGB(255, 230, 244, 245)
                              : Color.fromARGB(255, 61, 61, 61),
                          title: Text(
                            S.of(context).tipodePago,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.temaClaro
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          initiallyExpanded: _isTipoPagoExpanded,
                          collapsedIconColor: Colors.amber,
                          collapsedTextColor: widget.temaClaro
                              ? Color(0xFF154790)
                              : Colors.grey,
                          onExpansionChanged: (expanded) {
                            if (expanded &&
                                _seleccionadoSerieDocumento != null) {
                              _verTipoCargoAbono();
                            }
                            setState(() {
                              _isTipoPagoExpanded = !_isTipoPagoExpanded;
                              // Si el ExpansionTile de Tipo de pago no está expandido, _selectedTipoCargoAbono es null
                              if (!_isTipoPagoExpanded) {}
                            });
                          },
                          children: [
                            if (_cargandoTipoCargoAbono)
                              LoadingComponent(
                                color: Colors.blue[200]!,
                                changeLanguage: widget.changeLanguage,
                              ),
                            SingleChildScrollView(
                              child: Container(
                                height: 200,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _tipoCargoAbono.length,
                                  itemBuilder: (context, index) {
                                    final tipoCargoAbono =
                                        _tipoCargoAbono[index];
                                    return RadioListTile<PaBscTipoCargoAbono1M>(
                                      title: Text(
                                        DocumentoTraduccion.traducirTipoPago(
                                            tipoCargoAbono.descripcion,
                                            context),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: widget.temaClaro
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      value: tipoCargoAbono,
                                      groupValue: _seleccionadoTipoCargoAbono,
                                      onChanged:
                                          (PaBscTipoCargoAbono1M? value) {
                                        setState(() {
                                          _seleccionadoTipoCargoAbono = value;
                                          _verBancos();
                                          _seleccionadoBanco = null;
                                          _seleccionadoCuentaBancaria = null;
                                          _fechaController.text = '';
                                          _autorizacionController.text = "";
                                          _referenciaController.text = "";
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_seleccionadoTipoCargoAbono?.banco == true)
                      SizedBox(height: 16),
                    //SECCIÓN BANCOS
                    if (_seleccionadoTipoCargoAbono?.banco == true)
                      GestureDetector(
                        onTap: () {
                          if (_seleccionadoTipoCargoAbono == null &&
                              _seleccionadoTipoCargoAbono?.banco == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.cyan,
                                content: Text(
                                  S.of(context).requiereTipoPagoBanco,
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            );
                          }
                        },
                        child: AbsorbPointer(
                          absorbing: _seleccionadoTipoCargoAbono == null,
                          child: ExpansionTile(
                            backgroundColor: widget.temaClaro
                                ? Color.fromARGB(255, 230, 244, 245)
                                : Color.fromARGB(255, 61, 61, 61),
                            title: Text(
                              S.of(context).bancos,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: widget.temaClaro
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            initiallyExpanded: _isBancoExpanded,
                            collapsedIconColor: Colors.amber,
                            collapsedTextColor: widget.temaClaro
                                ? Color(0xFF154790)
                                : Colors.grey,
                            onExpansionChanged: (expanded) {
                              if (expanded &&
                                  _seleccionadoTipoCargoAbono != null) {
                                _verBancos();
                              }
                              setState(() {
                                _isBancoExpanded = !_isBancoExpanded;
                                // Si el ExpansionTile de Banco no está expandido
                                if (!_isBancoExpanded) {}
                              });
                            },
                            children: [
                              if (_cargandoBanco)
                                LoadingComponent(
                                  color: Colors.blue[200]!,
                                  changeLanguage: widget.changeLanguage,
                                ),
                              SingleChildScrollView(
                                child: Container(
                                  height: 200,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _banco.length,
                                    itemBuilder: (context, index) {
                                      final banco = _banco[index];
                                      return RadioListTile<PaBscBanco1M>(
                                        title: Text(
                                          banco.nombre,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: widget.temaClaro
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                        value: banco,
                                        groupValue: _seleccionadoBanco,
                                        onChanged: (PaBscBanco1M? value) {
                                          setState(() {
                                            _seleccionadoBanco = value;
                                            _verCuentaBancaria();
                                            _seleccionadoCuentaBancaria = null;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    //SECCIÓN CUENTA BANCARIA
                    if (_seleccionadoTipoCargoAbono?.reqCuentaBancaria == 1 &&
                        _seleccionadoBanco != null)
                      SizedBox(
                        height: 16,
                      ),
                    if (_seleccionadoTipoCargoAbono?.reqCuentaBancaria == 1 &&
                        _seleccionadoBanco != null)
                      GestureDetector(
                        onTap: () {
                          if (_seleccionadoBanco == null &&
                              _seleccionadoTipoCargoAbono?.reqCuentaBancaria ==
                                  0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.cyan,
                                content: Text(
                                  S.of(context).requiereTipoPagoCuentaBancaria,
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            );
                          }
                        },
                        child: AbsorbPointer(
                          absorbing: _seleccionadoTipoCargoAbono == null,
                          child: ExpansionTile(
                            backgroundColor: widget.temaClaro
                                ? Color.fromARGB(255, 230, 244, 245)
                                : Color.fromARGB(255, 61, 61, 61),
                            title: Text(
                              S.of(context).cuentaBancaria,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: widget.temaClaro
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            initiallyExpanded: _isCuentaBancariaExpanded,
                            collapsedIconColor: Colors.amber,
                            collapsedTextColor: widget.temaClaro
                                ? Color(0xFF154790)
                                : Colors.grey,
                            onExpansionChanged: (expanded) {
                              if (expanded && _seleccionadoBanco != null) {
                                _verCuentaBancaria();
                              }
                            },
                            children: [
                              if (_cargandoCuentaBancaria)
                                LoadingComponent(
                                  color: Colors.blue[200]!,
                                  changeLanguage: widget.changeLanguage,
                                ),
                              SingleChildScrollView(
                                child: Container(
                                  height: 200,
                                  child: _cuentaBancaria.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _cuentaBancaria.length,
                                          itemBuilder: (context, index) {
                                            final cuentaBancaria =
                                                _cuentaBancaria[index];
                                            return RadioListTile<
                                                PaBscCuentaBancaria1M>(
                                              title: Text(
                                                cuentaBancaria.descripcion!,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: widget.temaClaro
                                                      ? Colors.black
                                                      : Colors.white,
                                                ),
                                              ),
                                              value: cuentaBancaria,
                                              groupValue:
                                                  _seleccionadoCuentaBancaria,
                                              onChanged: (PaBscCuentaBancaria1M?
                                                  value) {
                                                setState(() {
                                                  _seleccionadoCuentaBancaria =
                                                      value;
                                                });
                                              },
                                            );
                                          },
                                        )
                                      : Center(
                                          child: ListTile(
                                            title: Text(
                                              S
                                                  .of(context)
                                                  .noSeEncuentranCuentasBancarias,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: widget.temaClaro
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 16,
                    ),
                    //INPUTS, OBSERVCIONES, BOTONES Y OPCIONES SELECCIONADAS
                    if (_seleccionadoTipoDocumento != null)
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: widget.temaClaro
                              ? Color.fromARGB(255, 236, 236, 236)
                              : Color.fromARGB(255, 0, 5, 44),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            //OPCIONES SELECCIONADAS
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: TextButton(
                                  onPressed: () {
                                    _mostrarBottomSheet(
                                        context); // Mostrar BottomSheet al presionar el botón
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: widget.temaClaro
                                        ? Colors.blue.withOpacity(0.1)
                                        : Colors.teal.withOpacity(0.1),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // Bordes ligeramente redondeados
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        color: widget.temaClaro
                                            ? Colors.blueAccent
                                            : Colors.tealAccent,
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          S
                                              .of(context)
                                              .observacionesSeleccionadas,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            color: widget.temaClaro
                                                ? Colors.blueAccent
                                                : Colors.tealAccent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            if (_seleccionadoTipoCargoAbono != null)
                              SizedBox(
                                height: 16,
                              ),
                            //INPUTS CRECIÓN RECIBO
                            if (_seleccionadoTipoCargoAbono != null)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: widget.temaClaro
                                      ? Color.fromARGB(255, 230, 244, 245)
                                      : Color.fromARGB(255, 61, 61, 61),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      //INPUT MONTO A PAGAR
                                      TextField(
                                        focusNode: _focusMonto,
                                        onEditingComplete: () {
                                          // Llama a unfocus() cuando el usuario completa la edición
                                          _focusMonto.unfocus();
                                        },
                                        controller: _montoController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText:
                                                S.of(context).montoParaHuerfano,
                                            labelStyle: TextStyle(
                                              color: widget.temaClaro
                                                  ? Color(0X0FF144FAB)
                                                  : Colors.white,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: widget.temaClaro
                                                    ? Color(0X0FF144FAB)
                                                    : Colors.white,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: widget.temaClaro
                                                    ? Color(0X0FF144FAB)
                                                    : Colors.white,
                                              ),
                                            ),
                                            icon: Icon(MdiIcons.cash),
                                            iconColor: Color(0xFFDD952A)),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: widget.temaClaro
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      //INPUT REFERENCIA
                                      if (_seleccionadoTipoCargoAbono
                                              ?.referencia ==
                                          1)
                                        TextField(
                                          focusNode: _focusReferencia,
                                          onEditingComplete: () {
                                            // Llama a unfocus() cuando el usuario completa la edición
                                            _focusReferencia.unfocus();
                                          },
                                          controller: _referenciaController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                              labelText:
                                                  S.of(context).referencia,
                                              labelStyle: TextStyle(
                                                color: widget.temaClaro
                                                    ? Color(0X0FF144FAB)
                                                    : Colors.white,
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: widget.temaClaro
                                                      ? Color(0X0FF144FAB)
                                                      : Colors.white,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: widget.temaClaro
                                                      ? Color(0X0FF144FAB)
                                                      : Colors.white,
                                                ),
                                              ),
                                              icon: Icon(
                                                  MdiIcons.commentTextOutline),
                                              iconColor: Color(0xFFDD952A)),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: widget.temaClaro
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      SizedBox(height: 16),
                                      //INPUT AUTORIZACIÓN
                                      if (_seleccionadoTipoCargoAbono
                                              ?.autorizacion ==
                                          1)
                                        TextField(
                                          focusNode: _focusAutorizacion,
                                          onEditingComplete: () {
                                            // Llama a unfocus() cuando el usuario completa la edición
                                            _focusAutorizacion.unfocus();
                                          },
                                          controller: _autorizacionController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                              labelText:
                                                  S.of(context).autorizacion,
                                              labelStyle: TextStyle(
                                                color: widget.temaClaro
                                                    ? Color(0X0FF144FAB)
                                                    : Colors.white,
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: widget.temaClaro
                                                      ? Color(0X0FF144FAB)
                                                      : Colors.white,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: widget.temaClaro
                                                      ? Color(0X0FF144FAB)
                                                      : Colors.white,
                                                ),
                                              ),
                                              icon: Icon(MdiIcons
                                                  .cardAccountDetailsStarOutline),
                                              iconColor: Color(0xFFDD952A)),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: widget.temaClaro
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      SizedBox(height: 16),
                                      //INPUT FECHA
                                      if (_seleccionadoTipoCargoAbono
                                              ?.reqFecha ==
                                          1)
                                        TextField(
                                          focusNode: _focusFecha,
                                          onEditingComplete: () {
                                            // Llama a unfocus() cuando el usuario completa la edición
                                            _focusFecha.unfocus();
                                          },
                                          readOnly: true,
                                          controller: _fechaController,
                                          onTap: () async {
                                            if (_fechaController.text.isEmpty) {
                                              _fechaController.text =
                                                  DateFormat('dd/MM/yyyy',
                                                          S.of(context).locale)
                                                      .format(DateTime.now());
                                            }
                                            DateTime initialDate =
                                                DateTime.now();
                                            if (_fechaController
                                                .text.isNotEmpty) {
                                              try {
                                                initialDate = DateFormat(
                                                        'dd/MM/yyyy',
                                                        S.of(context).locale)
                                                    .parseStrict(
                                                        _fechaController.text);
                                              } catch (e) {
                                                // Si no se puede parsear, mantén la fecha inicial como la actual
                                                print(
                                                    'Formato de fecha inválido, usando la fecha actual: $e');
                                              }
                                            }
                                            final DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: initialDate,
                                              firstDate: DateTime.now()
                                                  .subtract(Duration(
                                                      days:
                                                          180)), // Permite seleccionar hasta 6 meses antes
                                              lastDate: DateTime(9999, 12, 31),
                                              locale: Localizations.localeOf(
                                                  context),
                                              cancelText: '',
                                              confirmText:
                                                  S.of(context).aceptar,
                                              keyboardType: TextInputType.text,
                                            );
                                            if (pickedDate != null) {
                                              setState(() {
                                                _selectedDate = pickedDate;
                                                _fechaController
                                                    .text = DateFormat(
                                                        'dd/MM/yyyy',
                                                        S.of(context).locale)
                                                    .format(_selectedDate);
                                              });
                                            }
                                          },
                                          decoration: InputDecoration(
                                              labelText: S.of(context).fecha,
                                              labelStyle: TextStyle(
                                                color: widget.temaClaro
                                                    ? Color(0X0FF144FAB)
                                                    : Colors.white,
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: widget.temaClaro
                                                      ? Color(0X0FF144FAB)
                                                      : Colors.white,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: widget.temaClaro
                                                      ? Color(0X0FF144FAB)
                                                      : Colors.white,
                                                ),
                                              ),
                                              icon: Icon(Icons.calendar_today),
                                              iconColor: Color(0xFFDD952A)),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: widget.temaClaro
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(height: 16),
                            //OBSERVACIONES
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: widget.temaClaro
                                    ? Color.fromARGB(255, 230, 244, 245)
                                    : Color.fromARGB(255, 61, 61, 61),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 5),
                                  TextField(
                                    focusNode: _focusObservacion,
                                    onEditingComplete: () {
                                      // Llama a unfocus() cuando el usuario completa la edición
                                      _focusObservacion.unfocus();
                                    },
                                    controller: _observacionController,
                                    decoration: InputDecoration(
                                      labelText: S.of(context).observaciones,
                                      labelStyle: TextStyle(
                                          color: widget.temaClaro
                                              ? Colors.black
                                              : Colors.white),
                                      hintText:
                                          S.of(context).ingresarObservaciones,
                                      hintStyle: TextStyle(
                                          color: widget.temaClaro
                                              ? Colors.grey
                                              : Colors.white),
                                      suffixIcon: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.content_copy,
                                                    color: widget.temaClaro
                                                        ? Colors.black
                                                        : Colors
                                                            .white), // Icono para copiar
                                                onPressed: () {
                                                  Clipboard.setData(ClipboardData(
                                                      text:
                                                          _observacionController
                                                              .text));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(S
                                                        .of(context)
                                                        .textoCopiado),
                                                  ));
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.content_paste,
                                                    color: widget.temaClaro
                                                        ? Colors.black
                                                        : Colors
                                                            .white), // Icono para pegar
                                                onPressed: () async {
                                                  ClipboardData? data =
                                                      await Clipboard.getData(
                                                          'text/plain');
                                                  if (data != null) {
                                                    _observacionController
                                                        .text = data.text ?? '';
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          if (_seleccionadoTipoCargoAbono !=
                                              null)
                                            Column(
                                              children: [
                                                Checkbox(
                                                    value: _seleccionadoTipoCargoAbono
                                                            ?.bloquearDocumento ==
                                                        true,
                                                    onChanged: null,
                                                    activeColor: Colors.grey,
                                                    hoverColor:
                                                        Colors.transparent),
                                                Text(
                                                  S.of(context).bloqueado,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: widget.temaClaro
                                                          ? Colors.black
                                                          : Colors.white),
                                                ),
                                              ],
                                            ),
                                          SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: widget.temaClaro
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    maxLines: 3,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ), // Espacio entre el TextField y el borde del Container
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            //contador de cargos abonos creados:
                            if (_cargoAbono.isNotEmpty)
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Tooltip(
                                        message:
                                            '${S.of(context).numeroRegistro}${_cargoAbono.length}',
                                        child: Text(
                                          '${S.of(context).numeroRegistro}${_cargoAbono.length}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: widget.temaClaro
                                                  ? Colors.black
                                                  : Colors.white),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ]),
                            if (_cargandoAfectarCxC)
                              LoadingComponent(
                                color: Colors.blue[200]!,
                                changeLanguage: widget.changeLanguage,
                              ),
                            //tabla de cargo abono creado:
                            if (_cargoAbono.isNotEmpty)
                              Material(
                                elevation:
                                    5, // Define la elevación del contenedor
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: widget.temaClaro
                                        ? Colors.white
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: widget.temaClaro
                                          ? Colors.grey[300]!
                                          : Color.fromARGB(
                                              255, 0, 5, 44), // Color del borde
                                      width: 1, // Ancho del borde
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: DataTable(
                                          headingRowColor:
                                              MaterialStateColor.resolveWith(
                                            (states) => Colors.grey.shade800,
                                          ),
                                          //NOMBRES DE COLUMNAS TABLA CARGO ABONO:
                                          columns: <DataColumn>[
                                            DataColumn(
                                              label: Text(S.of(context).tipo,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(S.of(context).moneda,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).tipoCambio,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(S.of(context).pago,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(S.of(context).pago2,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).idReferencia,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).idAutorizacion,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(S.of(context).banco,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).cuentaBancaria,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(S.of(context).usuario,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).fechaHora,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .cuentaCorrientePadre,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .cobrarPagarPadre,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).empresaPadre,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .estacionTrabajoPadre,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .localizacionPadre,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).fechaRegPadre,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                            // Agregar más columnas según sea necesario
                                          ],
                                          //FILAS DE TABLA CARGO ABONO:
                                          rows: _cargoAbono.isNotEmpty
                                              ? List.generate(
                                                  _cargoAbono.length, (index) {
                                                  List<DataCell> cells = [
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].Tipo_Cargo_Abono}')),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].Moneda}')),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].Tipo_Cambio}')),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].Monto}')),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].Monto_Moneda}')),
                                                    DataCell(Text(
                                                        ' ')), //de donde viene?
                                                    DataCell(Text(
                                                        ' ')), //de donde viene?
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].Banco}')),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].Cuenta_Bancaria}')),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].UserName}')),
                                                    DataCell(Text(DateFormat(
                                                            'dd/MM/yyyy')
                                                        .format(DateTime.parse(
                                                            _cargoAbono[index]
                                                                .Fecha_Hora
                                                                .toString())))),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].F_Cuenta_Corriente_Padre}')),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].F_Cobrar_Pagar_Padre}')),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].F_Empresa_Padre}')),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].F_Estacion_Trabajo_Padre}')),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].F_Localizacion_Padre}')),
                                                    DataCell(Text(
                                                        '${_cargoAbono[index].F_Fecha_Reg_Padre}')),

                                                    // Agregar más celdas según sea necesario
                                                  ];
                                                  return DataRow(cells: cells);
                                                })
                                              : []),
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 16,
                            ),
                            //SECCIÓN BOTONES CREACIÓN RECIBO
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                //BOTÓN AFECTAR CXC
                                Flexible(
                                  child: Tooltip(
                                    message: S.of(context).afectarCxC,
                                    child: TextButton.icon(
                                      icon: Icon(
                                        MdiIcons.fileDocumentArrowRightOutline,
                                        color: Colors.cyan,
                                      ),
                                      label: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          S.of(context).afectarCxC,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.cyan.shade800,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        // Acción para el botón Aceptar
                                        setState(() {
                                          _focusId.unfocus();
                                          _focusFecha.unfocus();
                                          _focusMonto.unfocus();
                                          _focusReferencia.unfocus();
                                          _focusAutorizacion.unfocus();
                                          _focusObservacion.unfocus();
                                          _afectar = true;
                                        });
                                        if (_cargoAbono.isEmpty &&
                                            _mostrarTabla == false) {
                                          _validarDocumento();
                                        } else if (_cargoAbono.isNotEmpty &&
                                            _mostrarTabla == true) {
                                          if (_creadoAfectar == true) {
                                            Mensajes.mostrarDialogoConfirmacion(
                                                context,
                                                _validarCargoAbono,
                                                _DesplazarScroll,
                                                S.of(context).otroCargoAbono,
                                                widget.temaClaro
                                                    ? Colors.white
                                                    : Color.fromARGB(
                                                        255, 73, 73, 73),
                                                widget.temaClaro
                                                    ? Color.fromARGB(
                                                        255, 83, 83, 83)
                                                    : Colors.white,
                                                widget.temaClaro
                                                    ? Color.fromARGB(
                                                        255, 0, 0, 0)
                                                    : Colors.white);
                                          } else {
                                            _validarDocumento();
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                //BOTÓN HUERFANO
                                Flexible(
                                  child: Tooltip(
                                    message: S.of(context).huerfano,
                                    child: TextButton.icon(
                                      icon: Icon(
                                        MdiIcons.fileDocumentOutline,
                                        color: Color(0xFFF16A34A),
                                      ),
                                      label: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          S.of(context).huerfano,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Color(0xFFF15803D),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _focusId.unfocus();
                                          _focusFecha.unfocus();
                                          _focusMonto.unfocus();
                                          _focusReferencia.unfocus();
                                          _focusAutorizacion.unfocus();
                                          _focusObservacion.unfocus();
                                          _afectar = false;
                                        });
                                        if (_cargoAbono.isEmpty &&
                                            _mostrarTabla == false) {
                                          _validarDocumento();
                                        } else if (_cargoAbono.isNotEmpty &&
                                            _mostrarTabla == true) {
                                          _validarDocumento();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                //BOTON IMPRIMIR
                                if (_cargoAbono.isNotEmpty &&
                                    _mostrarTabla == true &&
                                    _cargandoAfectarCxC == false)
                                  Flexible(
                                    child: Tooltip(
                                      message: S.of(context).imprimir,
                                      child: TextButton.icon(
                                        icon: Icon(
                                          Icons.print,
                                          color: Color(0xFFFEA580C),
                                        ),
                                        label: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            S.of(context).imprimir,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.orange.shade800,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          print(widget
                                              .documentosSeleccionados.length);
                                          final imprimir = ImprimirDocumento(
                                            documento: _documento,
                                            selectedTipoDocumento:
                                                _seleccionadoTipoDocumento,
                                            selectedSerieDocumento:
                                                _seleccionadoSerieDocumento,
                                            selectedTipoCargoAbono:
                                                _seleccionadoTipoCargoAbono,
                                            selectedBanco: _seleccionadoBanco,
                                            selectedCuentaBancaria:
                                                _seleccionadoCuentaBancaria,
                                            selectedCuentaCta:
                                                widget.selectedCuentaCta,
                                            selectedCuentaCorrentista: widget
                                                .selectedCuentaCorrentista,
                                            pUserName: widget.pUserName,
                                            pEmpresa: widget.pEmpresa,
                                            pEstacion_Trabajo:
                                                widget.pEstacion_Trabajo,
                                            facturaNombre: widget.facturaNombre,
                                            facturaNit: widget.facturaNit,
                                            facturaDireccion:
                                                widget.facturaDireccion,
                                            montosGuardados: widget
                                                .montosGuardadosAcumulados,
                                            documentosSeleccionados: widget
                                                .documentosSeleccionadosAcumulados,
                                            afectar: _creadoAfectar,
                                            registrosCargoAbono:
                                                List.unmodifiable(
                                                    registrosCargoAbono),
                                            registrosCargoAbonoAfectar:
                                                List.unmodifiable(
                                                    registrosCargoAbonoAfectar),
                                            ccDireccion: widget.ccDireccion,
                                            telefono: widget.telefono,
                                            context: context,
                                            changeLanguage:
                                                widget.changeLanguage,
                                            seleccionarIdioma:
                                                widget.seleccionarIdioma,
                                            idiomaDropDown: _idiomaActual,
                                            baseUrl: widget.baseUrl,
                                            token: widget.token,
                                            temaClaro: widget.temaClaro,
                                            imagePath: widget.imagePath,
                                            isBackgroundSet:
                                                widget.isBackgroundSet,
                                            fechaSesion: widget.fechaSesion,
                                            tokenSesionGuardada:
                                                widget.tokenSesionGuardada,
                                            imageLogo: widget.imageLogo,
                                            fechaExpiracion:
                                                widget.fechaExpiracion,
                                          );
                                          print(_idiomaActual);
                                          Mensajes.mostrarDialogoConfirmacion(
                                              context,
                                              imprimir.initialize,
                                              _DesplazarScroll,
                                              S.of(context).seguroImprimir,
                                              widget.temaClaro
                                                  ? Colors.white
                                                  : Color.fromARGB(
                                                      255, 73, 73, 73),
                                              widget.temaClaro
                                                  ? Color.fromARGB(
                                                      255, 83, 83, 83)
                                                  : Colors.white,
                                              widget.temaClaro
                                                  ? Color.fromARGB(255, 0, 0, 0)
                                                  : Colors.white);
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ])));
  }
}

// //SECCIÓN ESTADO
// GestureDetector(
//   onTap: () {},
//   child: AbsorbPointer(
//     absorbing: _seleccionadoTipoDocumento == null,
//     child: ExpansionTile(
//       backgroundColor: widget.temaClaro
//           ? Color.fromARGB(255, 230, 244, 245)
//           : Color.fromARGB(255, 61, 61, 61),
//       title: Text(
//         S.of(context).estado,
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: widget.temaClaro
//               ? Colors.black
//               : Colors.white,
//         ),
//       ),
//       collapsedIconColor: Colors.amber,
//       collapsedTextColor: widget.temaClaro
//           ? Color(0xFF154790)
//           : Colors.grey,
//       onExpansionChanged: (expanded) {
//         if (expanded && _seleccionadoBanco != null) {
//           // _verCuentaBancaria();
//         }
//       },
//       children: [
//         SingleChildScrollView(
//           child: Container(
//               height: 200,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: _cuentaBancaria.length,
//                 itemBuilder: (context, index) {
//                   final cuentaBancaria =
//                       _cuentaBancaria[index];
//                   return RadioListTile<
//                       PaBscCuentaBancaria1M>(
//                     title: Text(
//                       "Activo",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: widget.temaClaro
//                             ? Colors.black
//                             : Colors.white,
//                       ),
//                     ),
//                     value: cuentaBancaria,
//                     groupValue: _seleccionadoCuentaBancaria,
//                     onChanged:
//                         (PaBscCuentaBancaria1M? value) {
//                       setState(() {
//                         print(_seleccionadoCuentaBancaria);
//                       });
//                     },
//                   );
//                 },
//               )),
//         ),
//       ],
//     ),
//   ),
// ),
// SizedBox(
//   height: 16,
// ),
