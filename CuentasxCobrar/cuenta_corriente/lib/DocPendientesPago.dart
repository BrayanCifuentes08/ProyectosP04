import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_cuenta_corriente/common/Animaciones.dart';
import 'package:test_cuenta_corriente/common/IndicadorRefresh.dart';
import 'package:test_cuenta_corriente/common/Mensajes.dart';
import 'package:test_cuenta_corriente/Models/PaBscCuentaCorriente1M.dart';
import 'package:test_cuenta_corriente/CreacionRecibo.dart';
import 'package:test_cuenta_corriente/common/Loading.dart';
import 'package:http/http.dart' as http;
import 'package:test_cuenta_corriente/PlantillaImagen.dart';
import 'package:test_cuenta_corriente/TablaCliente.dart';
import 'package:test_cuenta_corriente/common/Transiciones.dart';
import 'package:test_cuenta_corriente/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class TablaDocsPendientes extends StatefulWidget {
  final int seleccionadoCuentaCorrentista;
  final String seleccionadoCuentaCta;
  final String facturaNombre;
  final String facturaNit;
  final String facturaDireccion;
  final String ccDireccion;
  final String telefono;
  final String pUserName;
  final int pEmpresa;
  final int pEstacion_Trabajo;
  final Function(Locale) changeLanguage;
  final Locale seleccionarIdioma;
  Locale idiomaDropDown;
  final String baseUrl;
  final String token;
  bool temaClaro;
  final String imagePath;
  String? imageLogo;
  final bool isBackgroundSet;
  final DateTime fechaSesion;
  final DateTime? fechaExpiracion;
  final bool tokenSesionGuardada;
  final bool verificarCaptcha;

  TablaDocsPendientes({
    required this.seleccionadoCuentaCorrentista,
    required this.seleccionadoCuentaCta,
    required this.facturaNombre,
    required this.facturaNit,
    required this.facturaDireccion,
    required this.ccDireccion,
    required this.telefono,
    required this.pUserName,
    required this.pEmpresa,
    required this.pEstacion_Trabajo,
    required this.changeLanguage,
    required this.seleccionarIdioma,
    required this.idiomaDropDown,
    required this.baseUrl,
    required this.token,
    required this.temaClaro,
    required this.imagePath,
    required this.isBackgroundSet,
    required this.fechaSesion,
    required this.tokenSesionGuardada,
    this.imageLogo,
    required this.verificarCaptcha,
    this.fechaExpiracion,
  });

  @override
  State<TablaDocsPendientes> createState() => _TablaDocsPendientesState();
}

class _TablaDocsPendientesState extends State<TablaDocsPendientes> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NumberFormat formatter = NumberFormat('#,##0.00');
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledDown = false;
  List<TextEditingController> _montoController = [];
  List<TextEditingController> montosGuardadosController = [];
  final TextEditingController _urlController = TextEditingController();

  TextEditingController montoCronologicoController = TextEditingController();
  String montoCronologicoRestante = "";
  List<double> montosGuardados = [];
  List<double> montosGuardadosAcumulados = [];
  List<bool> _seleccionado = [];

  FocusNode _focusmontoCronologico = FocusNode();
  bool _mostrarMontoCronologico = false;
  //model
  List<PaBscCuentaCorriente1M> _docs = [];
  List<PaBscCuentaCorriente1M> _docsAplicar = [];
  List<PaBscCuentaCorriente1M> _docsAplicarAcumulados = [];

  Color _defaultColor = Colors.transparent;
  bool _mostrarAplicar = false;
  bool _mostrarDetalles = false;
  bool _presionarAplicar = false;
  bool _cargando = false;
  bool _isChecking = false;
  String? _checkResult;
  int _selectedRowIndex = -1;
  int _backGestureCount = 0;
  List<bool> _expandirRows = [];

  double _diferenciaSaldoMonto = 0.0;
  double _totalAplicando = 0.0;
  double _totalMonto = 0.0;
  double _totalSaldo = 0.0;
  String _formattedTotalAplicando = '';
  String _formattedTotalMonto = '';
  String _formattedTotalSaldo = '';
  String _formattedDiferencia = '';

  //Inicialización de parametros para pantalla Creación Recibo
  int seleccionadoOpc_Cuenta_Corriente = 0;
  int seleccionadoCuenta_Corriente = 0;
  int seleccionadoEmpresa = 0;
  int seleccionadoTipoDocumento = 0;
  int seleccionadoEstacionTrabajo = 0;
  String seleccionadoUserName = "";
  bool seleccionadopT_Filtro_6 = false;
  int seleccionadobGrupo = 0;
  bool seleccionadopDocumento_Conv = false;
  bool seleccionadopFE_Tipo = false;
  int seleccionadopPOS_Tipo = 0;
  bool seleccionadopVer_FE = false;
  String seleccionadopIdCuenta = "";
  bool orden = false;
  late Locale _idiomaActual;

  //al llamar el archivo:
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _expandirRows = List.generate(_docs.length, (index) => false);

    _BuscarDocumentosPendientes();
    _loadImagePath();
    _backGestureCount = 0;
    _idiomaActual = widget.idiomaDropDown;

    for (var doc in _docs) {
      var controller = TextEditingController(text: doc.aplicar.toString());
      controller.addListener(() {
        _ActualizarTotalSuma();
      });
      _montoController.add(controller);
      _seleccionado.add(false);
    }
    montosGuardados = List.generate(_docs.length, (index) => 0.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _scrollListener() {
    if (_scrollController.offset >= 200) {
      // Si scrollea más de 200 píxeles, aparece el botón
      if (!_isScrolledDown) {
        setState(() {
          _isScrolledDown = true;
        });
      }
    } else {
      if (_isScrolledDown) {
        setState(() {
          _isScrolledDown = false;
        });
      }
    }
  }

  Future<void> _loadImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.imageLogo = prefs.getString('logo_image_path');
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Cambia a pickImage

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logo_image_path', pickedFile.path);

      setState(() {
        widget.imageLogo = pickedFile.path;
      });
    }
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

  Future<void> _BuscarDocumentosPendientes() async {
    setState(() {
      _cargando = true; // Establecer isLoading a true al inicio de la carga
    });
    String url = '${widget.baseUrl}PaBscCuentaCorriente1Ctrl';
    Map<String, dynamic> queryParams = {
      "pCuenta_Correntista": widget.seleccionadoCuentaCorrentista,
      "pCuenta_Cta": widget.seleccionadoCuentaCta,
      "pEmpresa": widget.pEmpresa.toString(),
      "pCobrar_Pagar": "1",
      "pSaldo": "true",
      "pFil_Documento_Relacion": "",
      "pUserName": widget.pUserName.toString(),
      "pOpcion_Orden": "1",
      "pSQL_str": "",
    };

    Map<String, String> parametrosString =
        queryParams.map((key, value) => MapEntry(key, value!.toString()))
          // ignore: unnecessary_null_comparison
          ..removeWhere((key, value) => value == null);

    Uri uri = Uri.parse(url).replace(queryParameters: parametrosString);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        // Verificar si la respuesta es una lista
        // ignore: unnecessary_type_check
        if (jsonResponse is List) {
          List<dynamic> jsonResponse = json.decode(response.body);
          List<PaBscCuentaCorriente1M> docs = jsonResponse
              .map((data) => PaBscCuentaCorriente1M.fromJson(data))
              .toList();

          setState(() {
            _docs = docs;
            _expandirRows = List.generate(_docs.length, (index) => false);
            _seleccionado = List.generate(_docs.length, (index) => false);
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
        _cargando = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  void _ActualizarTotalSuma() {
    double suma = 0.0;
    for (int i = 0; i < _montoController.length; i++) {
      if (_seleccionado[i]) {
        suma += double.tryParse(_montoController[i].text) ?? 0.0;
      }
    }
    double totalMonto =
        _docs.fold(0.0, (previousValue, doc) => previousValue + doc.monto);
    double totalSaldo =
        _docs.fold(0.0, (previousValue, doc) => previousValue + doc.aplicar);

    double diferenciaSaldoMonto = totalMonto - totalSaldo;

    String formattedTotalAplicando = formatter.format(suma);
    String formattedTotalMonto = formatter.format(totalMonto);
    String formattedTotalSaldo = formatter.format(totalSaldo);
    String formattedTotalDiferencia = formatter.format(diferenciaSaldoMonto);
    setState(() {
      _totalAplicando = suma;
      _totalMonto = totalMonto;
      _totalSaldo = totalSaldo;
      _diferenciaSaldoMonto = diferenciaSaldoMonto;
      _formattedTotalAplicando = formattedTotalAplicando;
      _formattedTotalMonto = formattedTotalMonto;
      _formattedTotalSaldo = formattedTotalSaldo;
      _formattedDiferencia = formattedTotalDiferencia;
    });
  }

  void _ActualizarSaldosNuevos() {
    setState(() {
      double sumaMontosAplicar = 0.00;
      double sumaSaldosAplicar = 0.00;

      // Calcular la suma de los montos a aplicar y la suma de los saldos a los que se aplicarán los montos
      for (int i = 0; i < _montoController.length; i++) {
        if (_seleccionado[i]) {
          sumaMontosAplicar += double.tryParse(_montoController[i].text) ?? 0.0;
          sumaSaldosAplicar += _docs[i].aplicar;
        }
      }

      // Formatear los valores sumaMontosAplicar y sumaSaldosAplicar
      String formattedSumaMontosAplicar = formatter.format(sumaMontosAplicar);
      String formattedSumaSaldosAplicar = formatter.format(sumaSaldosAplicar);
      // Mostrar el diálogo de confirmación
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: widget.temaClaro
                ? Colors.white
                : Color.fromARGB(255, 73, 73, 73),
            title: Row(
              children: [
                Icon(
                  MdiIcons.check,
                  color: Color(0xFFDC9525),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    S.of(context).confirmarAplicacion,
                    style: TextStyle(
                      color: widget.temaClaro
                          ? Color.fromARGB(255, 83, 83, 83)
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            content: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: S.of(context).esteMonto,
                  style: TextStyle(
                    color: widget.temaClaro
                        ? Color.fromARGB(255, 0, 0, 0)
                        : Colors.white,
                  )),
              TextSpan(
                  text: "${_docs[0].simbolo}$formattedSumaMontosAplicar ",
                  style: TextStyle(
                    color: widget.temaClaro
                        ? Color.fromARGB(255, 0, 0, 0)
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(
                  text: S.of(context).seVaAplicarASaldo,
                  style: TextStyle(
                      color: widget.temaClaro
                          ? Color.fromARGB(255, 0, 0, 0)
                          : Colors.white)),
              TextSpan(
                  text: "${_docs[0].simbolo}$formattedSumaSaldosAplicar .",
                  style: TextStyle(
                    color: widget.temaClaro
                        ? Color.fromARGB(255, 0, 0, 0)
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(
                  text: S.of(context).confirmacionCambios,
                  style: TextStyle(
                      color: widget.temaClaro
                          ? Color.fromARGB(255, 0, 0, 0)
                          : Colors.white)),
            ])),
            actions: <Widget>[
              TextButton(
                child: Text(
                  S.of(context).confirmar,
                  style: TextStyle(color: Colors.cyan),
                ),
                onPressed: () {
                  // Guardar los valores actuales antes de cualquier otra acción
                  montosGuardadosController = _montoController
                      .asMap()
                      .entries
                      .where((entry) => _seleccionado[entry
                          .key]) // Filtrar por los checkboxes seleccionados
                      .map((entry) =>
                          TextEditingController(text: entry.value.text))
                      .toList();

                  setState(() {
                    montosGuardados = montosGuardadosController
                        .map((controller) =>
                            double.tryParse(controller.text) ?? 0.0)
                        .toList();
                    montosGuardadosAcumulados.addAll(montosGuardados);
                  });

                  montoCronologicoController.text = montoCronologicoRestante;
                  _docsAplicar.clear();
                  for (var i = 0; i < _seleccionado.length; i++) {
                    if (_seleccionado[i]) {
                      _docsAplicar.add(_docs[i]);
                      _docsAplicarAcumulados.add(_docs[i]);
                    }
                  }

                  // Realizar las operaciones de actualización de saldos
                  for (int i = 0; i < _montoController.length; i++) {
                    if (_seleccionado[i]) {
                      double aplicarValue =
                          double.tryParse(_montoController[i].text) ?? 0.0;
                      if (aplicarValue != 0) {
                        _docs[i].aplicar -= aplicarValue;
                        _montoController[i].text = _docs[i].aplicar.toString();
                      }
                    }
                  }

                  _presionarAplicar = true;
                  print(montosGuardados);
                  print(montosGuardadosAcumulados);
                  _DesplazarScroll();
                  // Actualizar el total suma
                  _ActualizarTotalSuma();
                  _deshabilitarCheckboxes();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  S.of(context).cancelar,
                  style: TextStyle(color: Colors.cyan),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void _deshabilitarCheckboxes() {
    setState(() {
      for (int i = 0; i < _seleccionado.length; i++) {
        _seleccionado[i] = false;
      }
    });
  }

  void _DesplazarScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
  }

  void _OrdenarDocumentos() {
    setState(() {
      // Crea una lista de índices para realizar un seguimiento de los elementos
      List<int> indices = List<int>.generate(_docs.length, (index) => index);
      // Ordena los índices en función del campo fecha de vencimiento
      indices.sort((a, b) {
        if (orden) {
          return _docs[a]
              .dFechaVencimiento
              .compareTo(_docs[b].dFechaVencimiento);
        } else {
          return _docs[b]
              .dFechaVencimiento
              .compareTo(_docs[a].dFechaVencimiento);
        }
      });

      // Reorganiza los documentos y otros arrays según los índices ordenados
      _docs = [for (var index in indices) _docs[index]];
      _seleccionado = [for (var index in indices) _seleccionado[index]];
      _montoController = [for (var index in indices) _montoController[index]];

      _expandirRows = [for (var index in indices) _expandirRows[index]];
      _expandirRows = [for (var index in indices) _expandirRows[index]];

      // Crea una nueva lista de detalles para mantener el estado de cada fila
      if (_selectedRowIndex != -1) {
        _selectedRowIndex = indices.indexOf(_selectedRowIndex);
      } // Reinicia el índice de la fila seleccionada
    });
  }

  void distribuirPagoCronologico(double monto) {
    for (int i = 0; i < _seleccionado.length; i++) {
      _seleccionado[i] = false;
    }
    // Ordenar los documentos por fecha de vencimiento (ascendente)
    _docs.sort((a, b) => a.dFechaVencimiento.compareTo(b.dFechaVencimiento));

    // Iterar sobre los documentos ordenados y distribuir el monto
    for (int i = 0; i < _docs.length; i++) {
      double saldoDisponible = _docs[i].aplicar;

      // Verificar si hay saldo disponible en el documento actual
      if (saldoDisponible > 0) {
        // Calcular el monto a distribuir en este documento
        double montoAAplicar = monto;
        if (montoAAplicar > saldoDisponible) {
          montoAAplicar = saldoDisponible;
        }
        // Asignar el monto al _montoController correspondiente
        _montoController[i].text = montoAAplicar.toString();
        monto -= montoAAplicar; // Restar el monto distribuido del monto global

        setState(() {
          _seleccionado[i] = true;
        });
        // Si ya no queda monto por distribuir, salir del bucle
        if (monto <= 0) {
          break;
        }
      }
    }
    montoCronologicoRestante = monto.toStringAsFixed(2);
    // Actualizar la interfaz después de distribuir los montos
    setState(() {});
  }

  Future<bool> verificarBaseUrl(String baseUrl) async {
    String testEndpoint = 'VerificarUrlCtrl/estado';
    final url = '${baseUrl}$testEndpoint';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return true; // La URL base responde correctamente
      } else {
        return false; // La URL base no responde como se esperaba
      }
    } catch (e) {
      print('Error: $e'); // Error al intentar hacer la solicitud
      return false; // Error al intentar hacer la solicitud
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              gradient: widget.temaClaro
                  ? LinearGradient(
                      colors: [
                        Color.fromARGB(255, 192, 215, 255),
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 33, 150, 243),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 0, 0),
                        Color.fromARGB(255, 21, 45, 90),
                        Color.fromARGB(255, 0, 55, 100),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
          ),
          Scaffold(
              backgroundColor: widget.temaClaro
                  ? Color.fromARGB(0, 255, 255, 255)
                  : Color.fromARGB(255, 65, 65, 65),
              key: _scaffoldKey,
              floatingActionButton: AnimatedOpacity(
                opacity: _isScrolledDown ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: _isScrolledDown
                    ? FloatingActionButton(
                        onPressed: _scrollToTop,
                        backgroundColor: widget.temaClaro
                            ? Colors.black
                                .withOpacity(0.7) // Fondo oscuro con opacidad
                            : Colors.white
                                .withOpacity(0.7), // Fondo claro con opacidad
                        child: Icon(
                          MdiIcons.arrowCollapseUp,
                          color: widget.temaClaro
                              ? Colors.white
                              : Colors.black, // Contraste de color del ícono
                          size: 20, // Tamaño más pequeño del ícono
                        ),
                        elevation:
                            0, // Sin sombra para un estilo plano y limpio
                        mini: true, // Hacer el botón flotante más pequeño
                      )
                    : null,
              ),
              //LÓGICA MENÚ LATERAL
              drawer: Container(
                decoration: BoxDecoration(
                  color: widget.temaClaro
                      ? Color(0x0F0929292) // Color de fondo en modo claro
                      : Color.fromARGB(
                          255, 85, 85, 85), // Color de fondo en modo oscuro
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.5), // Ajusta la opacidad de la sombra
                      spreadRadius: 20, // Ajusta el tamaño de la sombra
                      blurRadius: 20, // Ajusta el difuminado de la sombra
                      offset: Offset(0, 0), // Desplaza la sombra
                    ),
                  ],
                ),
                child: Drawer(
                  backgroundColor: widget.temaClaro
                      ? Color(0x0F0929292) // Fondo del drawer en modo claro
                      : Color.fromARGB(255, 65, 65, 65),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: widget.temaClaro
                              ? Color(
                                  0x0F0929292) // Color del encabezado en modo claro
                              : Color.fromARGB(255, 65, 65,
                                  65), // Color del encabezado en modo oscuro
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: Draggable(
                                      feedback: widget.imageLogo != null
                                          ? Image.file(File(widget.imageLogo!),
                                              height: 60)
                                          : Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    S.of(context).logoAqui,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      childWhenDragging: Opacity(
                                        opacity: 0.5,
                                        child: widget.imageLogo != null
                                            ? Image.file(
                                                File(widget.imageLogo!),
                                                height: 60)
                                            : Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      S.of(context).logoAqui,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      child: widget.imageLogo != null
                                          ? Image.file(File(widget.imageLogo!),
                                              height: 60)
                                          : Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    S.of(context).logoAqui,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      onDragEnd: (details) {
                                        // Manejar el final del drag si es necesario
                                        print(
                                            'El ícono ha sido arrastrado a: ${details.offset}');
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                      width: 5), // Espacio entre los elementos
                                  Container(
                                    width: 2,
                                    height: 60,
                                    color: widget.temaClaro
                                        ? Colors.grey[600]
                                        : Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Draggable(
                                    feedback: Image.asset(
                                      'assets/logo.png',
                                      height: 60,
                                      color: widget.temaClaro
                                          ? null
                                          : Colors.white,
                                    ),
                                    childWhenDragging: Opacity(
                                      opacity: 0.5,
                                      child: Image.asset(
                                        'assets/logo.png',
                                        height: 60,
                                        color: widget.temaClaro
                                            ? null
                                            : Colors.white,
                                      ),
                                    ),
                                    child: Image.asset(
                                      'assets/logo.png',
                                      height: 60,
                                      color: widget.temaClaro
                                          ? null
                                          : Colors.white,
                                    ),
                                    onDragEnd: (details) {
                                      // Manejar el final del drag si es necesario
                                      print(
                                          'El ícono ha sido arrastrado a: ${details.offset}');
                                    },
                                  ),
                                  Spacer(), // Esto empuja el ícono a la derecha
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            widget.temaClaro =
                                                !widget.temaClaro;
                                          });
                                        },
                                        child: AnimacionesIcons(
                                          icon1: Icons.light_mode,
                                          icon2: Icons.dark_mode,
                                          condicion: widget.temaClaro,
                                          onPressed: () {
                                            setState(() {
                                              widget.temaClaro =
                                                  !widget.temaClaro;
                                            });
                                          },
                                          colorIcon1: Colors.grey[200]!,
                                          colorIcon2: Colors.grey[200]!,
                                          duration: Duration(milliseconds: 600),
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    S.of(context).tituloMenu,
                                    style: TextStyle(
                                      color: widget.temaClaro
                                          ? Colors
                                              .white // Color del texto en modo claro
                                          : Colors.grey[
                                              300], // Color del texto en modo oscuro
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  if (widget.tokenSesionGuardada)
                                    GestureDetector(
                                      onTap: () {
                                        Mensajes.cerrarSesionUsuario(
                                            widget.temaClaro,
                                            context,
                                            widget.pUserName,
                                            widget.fechaSesion,
                                            widget.fechaExpiracion!);
                                      },
                                      child: Initicon(
                                        text: widget.pUserName,
                                        backgroundColor: widget.temaClaro
                                            ? Colors.lightBlue[800]
                                            : Colors.cyan[300],
                                        style: TextStyle(color: Colors.white),
                                        size: 30,
                                      ),
                                    ),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TablaCliente(
                                    pUserName: widget.pUserName,
                                    pEmpresa: widget.pEmpresa,
                                    pEstacion_Trabajo: widget.pEstacion_Trabajo,
                                    changeLanguage: widget.changeLanguage,
                                    seleccionarIdioma: widget.seleccionarIdioma,
                                    idiomaDropDown: _idiomaActual,
                                    baseUrl: widget.baseUrl,
                                    token: widget.token,
                                    temaClaro: widget.temaClaro,
                                    imagePath: widget.imagePath,
                                    isBackgroundSet: widget.isBackgroundSet,
                                    fechaSesion: widget.fechaSesion,
                                    fechaExpiracion: widget.fechaExpiracion,
                                    imageLogo: widget.imageLogo),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _defaultColor,
                            ),
                            child: Text(
                              S.of(context).busquedaClienteMenu,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Acción al presionar TABLA DOCUMENTOS PENDIENTES
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _defaultColor,
                            ),
                            child: Text(
                              S.of(context).documentosPendientesTitulo,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 150),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: widget.temaClaro
                                        ? Colors
                                            .blueAccent // Color del icono en modo claro
                                        : Colors
                                            .blueAccent, // Color del icono en modo oscuro
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.language,
                                      color: Colors.white, size: 24),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  S.of(context).idiomaMenu,
                                  style: TextStyle(
                                    color: widget.temaClaro
                                        ? Colors
                                            .white // Color del texto en modo claro
                                        : Colors.grey[300],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Locale>(
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors.white),
                                  dropdownColor: Colors.grey[800],
                                  value: _idiomaActual,
                                  onChanged: (Locale? newLocale) {
                                    if (newLocale != null) {
                                      setState(() {
                                        _idiomaActual = newLocale;
                                      });
                                      widget.changeLanguage(newLocale);
                                    }
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: Locale('es', 'ES'),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'icons/flags/png/es.png', // Path to Spanish flag
                                            package: 'country_icons',
                                            width: 24,
                                            height: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Español',
                                              style: TextStyle(
                                                color: Colors.white,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: Locale('en', 'US'),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'icons/flags/png/us.png', // Path to US flag
                                            package: 'country_icons',
                                            width: 24,
                                            height: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'English',
                                              style: TextStyle(
                                                color: Colors.white,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: Locale('fr', 'FR'),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'icons/flags/png/fr.png', // Ruta a la bandera francesa
                                            package: 'country_icons',
                                            width: 24,
                                            height: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'French',
                                              style: TextStyle(
                                                color: Colors.white,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: Locale('de', 'DE'),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'icons/flags/png/de.png', // Ruta a la bandera alemana
                                            package: 'country_icons',
                                            width: 24,
                                            height: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'German',
                                              style: TextStyle(
                                                color: Colors.white,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      // ListTile(
                      //   leading: Icon(MdiIcons.helpCircle,
                      //       color: widget.temaClaro
                      //           ? Color(
                      //               0xFFeab308) // Color del icono de ayuda en modo claro
                      //           : Color(
                      //               0xFFfbbf24)), // Color del icono de ayuda en modo oscuro
                      //   title: Text(
                      //     S.of(context).ayudaMenu,
                      //     style: TextStyle(
                      //       color: widget.temaClaro
                      //           ? Colors
                      //               .white // Color del texto de ayuda en modo claro
                      //           : Colors.grey[
                      //               300], // Color del texto de ayuda en modo oscuro
                      //       fontSize: 16,
                      //     ),
                      //   ),
                      //   onTap: () async {
                      //     const testUrl =
                      //         'https://docs.google.com/document/d/1qFOl2g9CmsSMGxZ2xaeH2grh_uphFJGdI2FVvf_hu54/edit?usp=sharing';
                      //     final uri = Uri.parse(testUrl);
                      //     if (!await launchUrl(uri,
                      //         mode: LaunchMode.externalApplication)) {
                      //       throw 'No se pudo abrir el enlace $testUrl';
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
              body: CustomRefreshIndicator(
                onRefresh: () async {
                  // Simula una carga y luego navega a otra pantalla
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TablaDocsPendientes(
                              seleccionadoCuentaCorrentista:
                                  widget.seleccionadoCuentaCorrentista,
                              seleccionadoCuentaCta:
                                  widget.seleccionadoCuentaCta,
                              facturaNombre: widget.facturaNombre,
                              facturaNit: widget.facturaNit,
                              facturaDireccion: widget.facturaDireccion,
                              ccDireccion: widget.ccDireccion,
                              telefono: widget.telefono,
                              pUserName: widget.pUserName,
                              pEmpresa: widget.pEmpresa,
                              pEstacion_Trabajo: widget.pEstacion_Trabajo,
                              changeLanguage: widget.changeLanguage,
                              seleccionarIdioma: widget.seleccionarIdioma,
                              idiomaDropDown: _idiomaActual,
                              baseUrl: widget.baseUrl,
                              token: widget.token,
                              temaClaro: widget.temaClaro,
                              imagePath: widget.imagePath,
                              isBackgroundSet: widget.isBackgroundSet,
                              fechaSesion: widget.fechaSesion,
                              tokenSesionGuardada: widget.tokenSesionGuardada,
                              imageLogo: widget.imageLogo,
                              verificarCaptcha: false,
                              fechaExpiracion: widget.fechaExpiracion,
                            )),
                  );
                },
                builder: (context, child, controller) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      EnvelopRefreshIndicator(
                        controller: controller,
                        onRefresh: () async {},
                        child: child,
                      ),
                    ],
                  );
                },
                child: Stack(children: [
                  if (widget.isBackgroundSet)
                    BackgroundImage(imagePath: widget.imagePath),
                  CustomScrollView(controller: _scrollController, slivers: [
                    SliverAppBar(
                      expandedHeight: 220.0,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: Color.fromARGB(255, 14, 48, 100),
                      flexibleSpace: FlexibleSpaceBar(
                        background: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 2, 32, 87),
                                Color.fromARGB(255, 0, 48, 135),
                                Color.fromARGB(255, 33, 150, 243),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 80),
                                Text(
                                  S.of(context).datosDelCliente,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Flexible(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return CarouselSlider(
                                        options: CarouselOptions(
                                          height: constraints.maxHeight,
                                          enlargeCenterPage: true,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              Duration(seconds: 3),
                                          scrollDirection: Axis.horizontal,
                                        ),
                                        items: [
                                          _buildDataCard(
                                            S.of(context).ctaCliente,
                                            widget.seleccionadoCuentaCta
                                                    .isNotEmpty
                                                ? widget.seleccionadoCuentaCta
                                                : S
                                                    .of(context)
                                                    .nombreCtaNoRegistrado,
                                          ),
                                          _buildDataCard(
                                            S.of(context).facturaNombreCliente,
                                            widget.facturaNombre.isNotEmpty
                                                ? widget.facturaNombre
                                                : S
                                                    .of(context)
                                                    .nombreFacturaNoRegistrada,
                                          ),
                                          _buildDataCard(
                                            S.of(context).facturaNitCliente,
                                            widget.facturaNit.isNotEmpty
                                                ? widget.facturaNit
                                                : S.of(context).nitNoRegistrado,
                                          ),
                                          _buildDataCard(
                                            S
                                                .of(context)
                                                .facturaDireccionCliente,
                                            widget.facturaDireccion.isNotEmpty
                                                ? widget.facturaDireccion
                                                : S
                                                    .of(context)
                                                    .direccionNoRegistrada,
                                          ),
                                          _buildDataCard(
                                            S.of(context).ccDireccionCliente,
                                            widget.ccDireccion.isNotEmpty
                                                ? widget.ccDireccion
                                                : S
                                                    .of(context)
                                                    .direccionNoRegistrada,
                                          ),
                                          _buildDataCard(
                                            S.of(context).telefonoCliente,
                                            widget.telefono.isNotEmpty
                                                ? widget.telefono
                                                : S.of(context).noRegistrado,
                                          ),
                                        ]
                                            .map((card) => Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          4.0), // Margen ajustado
                                                  width: constraints.maxWidth *
                                                      0.75,
                                                  // Ajusta el ancho de las tarjetas
                                                  child: card,
                                                ))
                                            .toList(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: IconButton(
                            padding: EdgeInsets.only(left: 20.0, top: 10.0),
                            icon: Icon(
                              Icons.menu_open_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                        )
                      ],
                      leading: IconButton(
                        icon: Icon(MdiIcons.arrowULeftTopBold,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TablaCliente(
                                  pUserName: widget.pUserName,
                                  pEmpresa: widget.pEmpresa,
                                  pEstacion_Trabajo: widget.pEstacion_Trabajo,
                                  changeLanguage: widget.changeLanguage,
                                  seleccionarIdioma: widget.seleccionarIdioma,
                                  idiomaDropDown: _idiomaActual,
                                  baseUrl: widget.baseUrl,
                                  token: widget.token,
                                  temaClaro: widget.temaClaro,
                                  imagePath: widget.imagePath,
                                  isBackgroundSet: widget.isBackgroundSet,
                                  fechaSesion: widget.fechaSesion,
                                  fechaExpiracion: widget.fechaExpiracion,
                                  imageLogo: widget.imageLogo),
                            ),
                          );
                        },
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(30.0),
                        ),
                      ),
                    ),
                    // Puedes ajustar el borderRadius aquí si lo necesitas, o eliminarlo
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(23.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                S
                                    .of(context)
                                    .documentosPendientesTituloMultilinea,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: widget.temaClaro
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              if (_cargando)
                                LoadingComponent(
                                  color: widget.temaClaro
                                      ? Colors.blue[800]!
                                      : Colors.white,
                                  changeLanguage: widget.changeLanguage,
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              //BOTÓN E INPUT PAGO CRONOLÓGICO
                              if (_docs.isNotEmpty)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //BOTÓN PARA PAGO CRONOLÓGICO
                                    Flexible(
                                      child: ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxWidth: 190),
                                        child: Tooltip(
                                          message:
                                              S.of(context).pagoCronologico,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: widget.temaClaro
                                                  ? Colors.blue.shade400
                                                  : Colors.blue.shade500,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _mostrarMontoCronologico = true;
                                              });
                                            },
                                            child: Text(
                                              S.of(context).pagoCronologico,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //INPUT MONTO CRONOLÓGICO
                                    if (_mostrarMontoCronologico)
                                      Flexible(
                                        child: Tooltip(
                                          message: '',
                                          child: TextField(
                                              focusNode: _focusmontoCronologico,
                                              onEditingComplete: () {
                                                // Llama a unfocus() cuando el usuario completa la edición
                                                _focusmontoCronologico
                                                    .unfocus();
                                              },
                                              controller:
                                                  montoCronologicoController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                labelText:
                                                    S.of(context).ingresarMonto,
                                                labelStyle: TextStyle(
                                                    color: widget.temaClaro
                                                        ? Color.fromARGB(
                                                            255, 0, 0, 0)
                                                        : Colors.white,
                                                    fontSize: 13),
                                                border: OutlineInputBorder(),
                                                prefixIcon: Icon(
                                                    MdiIcons.cashClock,
                                                    color: Color(0xFFDD952A)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: widget.temaClaro
                                                        ? Color(0xFFD0FDFF)
                                                        : Color(0xFFDD952A),
                                                  ),
                                                ),
                                              ),
                                              style: TextStyle(
                                                  color: widget.temaClaro
                                                      ? Colors.black
                                                      : Colors.white)),
                                        ),
                                      ),
                                  ],
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              //BOTÓN ASCENDENTE - NÚMERO DE REGISTROS - BOTÓN APLICAR
                              if (_docs.isNotEmpty)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //NÚMERO DE REGISTROS TABLA DOCUMENTOS PENDIENTES DE PAGO
                                    Flexible(
                                      child: Tooltip(
                                        message:
                                            '${S.of(context).numeroRegistro}${_docs.length}',
                                        child: Text(
                                          '${S.of(context).numeroRegistro}${_docs.length}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: widget.temaClaro
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    //BOTÓN ASCENDENTE/DESCENDENTE
                                    Flexible(
                                      child: ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxWidth: 150),
                                        child: Tooltip(
                                          message: orden == false
                                              ? S.of(context).ascendente
                                              : S.of(context).descendente,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.indigo.shade400,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                orden = !orden;
                                                _OrdenarDocumentos();
                                              });
                                            },
                                            child: Text(
                                              orden == false
                                                  ? S.of(context).ascendente
                                                  : S.of(context).descendente,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //BOTÓN APLICAR
                                    if (_mostrarAplicar ||
                                        _mostrarMontoCronologico)
                                      Flexible(
                                        child: ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxWidth: 100),
                                          child: Tooltip(
                                            message: S.of(context).aplicar,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFFF0d9488),
                                              ),
                                              onPressed: () {
                                                if (montoCronologicoController
                                                            .text.isEmpty &&
                                                        _mostrarMontoCronologico ==
                                                            true ||
                                                    montoCronologicoController
                                                            .text ==
                                                        "0") {
                                                  setState(() {
                                                    _focusmontoCronologico
                                                        .requestFocus();
                                                  });
                                                  Mensajes.mensajeAdvertencia(
                                                      context,
                                                      S
                                                          .of(context)
                                                          .seRequiereIngresarMonto,
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
                                                  return;
                                                }
                                                if (_mostrarMontoCronologico) {
                                                  distribuirPagoCronologico(
                                                      double.parse(
                                                          montoCronologicoController
                                                              .text));
                                                  _ActualizarSaldosNuevos();
                                                } else {
                                                  _ActualizarSaldosNuevos();
                                                }
                                                _ActualizarTotalSuma();
                                                for (int index = 0;
                                                    index < _docs.length;
                                                    index++) {
                                                  if (_seleccionado[index] &&
                                                      _mostrarAplicar) {
                                                    setState(() {
                                                      seleccionadoOpc_Cuenta_Corriente =
                                                          _docs[index]
                                                              .cobrarPagar;
                                                      seleccionadoCuenta_Corriente =
                                                          _docs[index]
                                                              .cuentaCorriente;
                                                      seleccionadoEmpresa =
                                                          _docs[index].empresa;
                                                      seleccionadoTipoDocumento =
                                                          _docs[index]
                                                              .dTipoDocumento;
                                                      seleccionadoEstacionTrabajo =
                                                          _docs[index]
                                                              .estacionTrabajo;
                                                      seleccionadoUserName =
                                                          _docs[index].userName;
                                                      seleccionadopT_Filtro_6 =
                                                          false;
                                                      seleccionadobGrupo = 0;
                                                      seleccionadopDocumento_Conv =
                                                          false;
                                                      seleccionadopFE_Tipo =
                                                          false;
                                                      seleccionadopPOS_Tipo = 0;
                                                      seleccionadopVer_FE =
                                                          false;
                                                      seleccionadopIdCuenta =
                                                          _docs[index].idCuenta;
                                                      // _presionarAplicar = false;
                                                    });
                                                  }
                                                }
                                              },
                                              child: Text(
                                                S.of(context).aplicar,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              //TABLA DOCS PENDIENTES DE PAGO
                              if (_docs.isNotEmpty)
                                Material(
                                  elevation:
                                      5, // Define la elevación del contenedor
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: widget.temaClaro
                                          ? Colors.white
                                          : Colors.grey[400]!,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height:
                                        400, // Define la altura del contenedor
                                    width: double.infinity,
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: DataTable(
                                                //COLOR DE ENCABEZADO TABLA DOCUMENTOS PENDIENTES DE PAGO
                                                headingRowColor:
                                                    MaterialStateColor
                                                        .resolveWith(
                                                  (states) => widget.temaClaro
                                                      ? Color(0xFFDD952A)
                                                      : Colors.grey[800]!,
                                                ),
                                                columnSpacing: 20,
                                                //NOMBRES DE COLUMNAS DE TABLA DOCUMENTOS PENDIENTES DE PAGO
                                                columns: [
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .selectCliente,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S.of(context).monto,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S.of(context).aplicar,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S.of(context).saldo,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .valorAplicado,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .consecutivoInterno,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .rUserName,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .tipoCambio,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S.of(context).moneda,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .montoMoneda,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .valorAplicadoMoneda,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .dfechaVencimiento,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .username,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .desEstadoDocumento,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .cuentaCorriente,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .cobrarPagar,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S.of(context).empresa,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .localizacion,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .estacionTrabajo,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .fechaReg,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S.of(context).estado,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .fechaHora,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .mFechaHora,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .mUsername,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .cuentaCorrentista,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .cuentaCta,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .cuentaCorrientePadre,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .cobrarPagarPadre,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .empresaPadre,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .localizacionPadre,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .estacionTrabajoPadre,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .fechaRegPadre,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .fechaCuenta,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .fechaInicial,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .fechaFinal,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .generarCheque,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S.of(context).proceso,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .cuentaBancaria,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .idDocumentoReferencia,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .saldoMoneda,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .cuentaCorrentistaRef,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .idDocumento,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .fechaDocumento,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .desSerieDocumento,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .nomMoneda,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .desMoneda,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S.of(context).simbolo,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .facturaNombre,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .desCuentaCta,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .desTipoDocumento,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .fDocumentoRelacion,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .desCuentaCorriente,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .dDocumento,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .dTipoDocumento,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .dSerieDocumento,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .dEmpresa,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .dLocalizacion,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .dEstacionTrabajo,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .dFechaReg,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .referencia,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .refIdDocumento,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .refSerie,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .documentoNombre,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .idCuenta,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .dReferencia,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .rReferenciaId,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .rIdDocumentoOrigen,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S.of(context).feCae,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(
                                                      label: Text(
                                                          S
                                                              .of(context)
                                                              .feNumeroDocumento,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: widget
                                                                      .temaClaro
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFFDD952A)))),
                                                  DataColumn(label: Text('')),
                                                ],
                                                //FILAS DE TABLA DOCUMENTOS PENDIENTES DE PAGO
                                                rows: _docs.isNotEmpty
                                                    ? List.generate(
                                                        _docs.length, (index) {
                                                        _seleccionado
                                                            .add(false);
                                                        _ActualizarTotalSuma();
                                                        _montoController.add(
                                                            TextEditingController());

                                                        Color rowColor = _seleccionado[
                                                                index]
                                                            ? (widget.temaClaro
                                                                ? Colors.grey
                                                                    .shade200
                                                                : Colors
                                                                    .grey[500]!)
                                                            : (widget.temaClaro
                                                                ? Colors.white
                                                                : Colors.grey[
                                                                    400]!);

                                                        return DataRow(
                                                          color:
                                                              MaterialStateProperty
                                                                  .resolveWith<
                                                                      Color?>(
                                                            (Set<MaterialState>
                                                                states) {
                                                              // Si la fila está seleccionada, cambiar el color
                                                              if (states.contains(
                                                                  MaterialState
                                                                      .selected)) {
                                                                return Colors
                                                                    .blue
                                                                    .shade100;
                                                              }
                                                              return rowColor; // Color base de la fila
                                                            },
                                                          ),
                                                          cells: [
                                                            DataCell(
                                                              Checkbox(
                                                                value:
                                                                    _seleccionado[
                                                                        index],
                                                                onChanged:
                                                                    (bool?
                                                                        value) {
                                                                  if (value !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      montoCronologicoController
                                                                          .clear();
                                                                      _mostrarMontoCronologico =
                                                                          false;
                                                                      _seleccionado[
                                                                              index] =
                                                                          value;

                                                                      if (montosGuardadosController
                                                                              .length >
                                                                          0)
                                                                        montosGuardadosController =
                                                                            _montoController.map((controller) {
                                                                          return TextEditingController(
                                                                              text: controller.text);
                                                                        }).toList();

                                                                      _ActualizarTotalSuma();
                                                                      _mostrarAplicar =
                                                                          _seleccionado
                                                                              .contains(true);
                                                                      // _presionarAplicar = false;
                                                                      // ignore: unused_label
                                                                      controller:
                                                                      _montoController[
                                                                          index]
                                                                        ..text = _docs[index]
                                                                            .aplicar
                                                                            .toString();
                                                                    });
                                                                    print(
                                                                        'Montos guardados: $montosGuardados');
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            DataCell(Text(
                                                                '${_docs[index].monto}')),
                                                            DataCell(
                                                              _seleccionado[
                                                                      index]
                                                                  ? TextField(
                                                                      controller:
                                                                          _montoController[
                                                                              index],
                                                                      keyboardType:
                                                                          TextInputType.numberWithOptions(
                                                                              decimal: true),
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter.allow(
                                                                            RegExp(r'^\d*\.?\d{0,2}')),
                                                                        TextInputFormatter
                                                                            .withFunction(
                                                                          (oldValue,
                                                                              newValue) {
                                                                            final String
                                                                                newText =
                                                                                newValue.text;
                                                                            final double?
                                                                                value =
                                                                                double.tryParse(newValue.text);

                                                                            if (newText.isEmpty) {
                                                                              return TextEditingValue(
                                                                                text: '0',
                                                                                selection: TextSelection.collapsed(offset: 1),
                                                                              );
                                                                            }
                                                                            if (value == null ||
                                                                                value < 0 ||
                                                                                value > _docs[index].aplicar) {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                  backgroundColor: Colors.cyan,
                                                                                  content: Text('${S.of(context).noSePuedeIngresarNumeroMayor}${_docs[index].aplicar}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                                                ),
                                                                              );
                                                                              return oldValue;
                                                                            }
                                                                            return newValue;
                                                                          },
                                                                        ), //dejar vacio
                                                                      ],
                                                                      onChanged:
                                                                          (text) {
                                                                        if (text
                                                                            .isEmpty) {
                                                                          _montoController[index].text =
                                                                              '0';
                                                                          _montoController[index].selection =
                                                                              TextSelection.collapsed(offset: 1);
                                                                        }
                                                                        _ActualizarTotalSuma();
                                                                      },
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: widget.temaClaro
                                                                              ? Colors.blue
                                                                              : Colors.blue[900],
                                                                          fontWeight: FontWeight.bold),
                                                                      autofocus:
                                                                          false,
                                                                    )
                                                                  : Container(),
                                                            ),
                                                            DataCell(Text(
                                                                '${_docs[index].saldo}')),
                                                            DataCell(Text(
                                                                '${_docs[index].valorAplicado}')),
                                                            DataCell(Text(
                                                                '${_docs[index].consecutivoInterno}')),
                                                            DataCell(Text(
                                                                '${_docs[index].rUserName}')),
                                                            DataCell(Text(
                                                                '${_docs[index].tipoCambio}')),
                                                            DataCell(Text(
                                                                '${_docs[index].moneda}')),
                                                            DataCell(Text(
                                                                '${_docs[index].montoMoneda}')),
                                                            DataCell(Text(
                                                                '${_docs[index].valorAplicadoMoneda}')),
                                                            DataCell(Text(
                                                                '${_docs[index].dFechaVencimiento}')),
                                                            DataCell(Text(
                                                                '${_docs[index].userName}')),
                                                            DataCell(Text(
                                                                '${_docs[index].desEstadoDocumento}')),
                                                            DataCell(Text(
                                                                '${_docs[index].cuentaCorriente}')),
                                                            DataCell(Text(
                                                                '${_docs[index].cobrarPagar}')),
                                                            DataCell(Text(
                                                                '${_docs[index].empresa}')),
                                                            DataCell(Text(
                                                                '${_docs[index].localizacion}')),
                                                            DataCell(Text(
                                                                '${_docs[index].estacionTrabajo}')),
                                                            DataCell(Text(
                                                                '${_docs[index].fechaReg}')),
                                                            DataCell(Text(
                                                                '${_docs[index].estado}')),
                                                            DataCell(Text(
                                                                '${_docs[index].fechaHora}')),
                                                            DataCell(Text(
                                                                '${_docs[index].mFechaHora}')),
                                                            DataCell(Text(
                                                                '${_docs[index].mUserName}')),
                                                            DataCell(Text(
                                                                '${_docs[index].cuentaCorrentista}')),
                                                            DataCell(Text(
                                                                '${_docs[index].cuentaCta}')),
                                                            DataCell(Text(
                                                                '${_docs[index].cuentaCorrientePadre}')),
                                                            DataCell(Text(
                                                                '${_docs[index].cobrarPagarPadre}')),
                                                            DataCell(Text(
                                                                '${_docs[index].empresaPadre}')),
                                                            DataCell(Text(
                                                                '${_docs[index].localizacionPadre}')),
                                                            DataCell(Text(
                                                                '${_docs[index].estacionTrabajoPadre}')),
                                                            DataCell(Text(
                                                                '${_docs[index].fechaRegPadre}')),
                                                            DataCell(Text(
                                                                '${_docs[index].fechaCuenta}')),
                                                            DataCell(Text(
                                                                '${_docs[index].fechaInicial}')),
                                                            DataCell(Text(
                                                                '${_docs[index].fechaFinal}')),
                                                            DataCell(Text(
                                                                '${_docs[index].generarCheque}')),
                                                            DataCell(Text(
                                                                '${_docs[index].proceso}')),
                                                            DataCell(Text(
                                                                '${_docs[index].cuentaBancaria}')),
                                                            DataCell(Text(
                                                                '${_docs[index].idDocumentoReferencia}')),
                                                            DataCell(Text(
                                                                '${_docs[index].saldoMoneda}')),
                                                            DataCell(Text(
                                                                '${_docs[index].cuentaCorrentistaRef}')),
                                                            DataCell(Text(
                                                                '${_docs[index].idDocumento}')),
                                                            DataCell(Text(
                                                                '${_docs[index].fechaDocumento}')),
                                                            DataCell(Text(
                                                                '${_docs[index].desSerieDocumento}')),
                                                            DataCell(Text(
                                                                '${_docs[index].nomMoneda}')),
                                                            DataCell(Text(
                                                                '${_docs[index].desMoneda}')),
                                                            DataCell(Text(
                                                                '${_docs[index].simbolo}')),
                                                            DataCell(Text(
                                                                '${_docs[index].facturaNombre}')),
                                                            DataCell(Text(
                                                                '${_docs[index].desCuentaCta}')),
                                                            DataCell(Text(
                                                                '${_docs[index].desTipoDocumento}')),
                                                            DataCell(Text(
                                                                '${_docs[index].fDocumentoRelacion}')),
                                                            DataCell(Text(
                                                                '${_docs[index].desCuentaCorriente}')),
                                                            DataCell(Text(
                                                                '${_docs[index].dDocumento}')),
                                                            DataCell(Text(
                                                                '${_docs[index].dTipoDocumento}')),
                                                            DataCell(Text(
                                                                '${_docs[index].dSerieDocumento}')),
                                                            DataCell(Text(
                                                                '${_docs[index].dEmpresa}')),
                                                            DataCell(Text(
                                                                '${_docs[index].dLocalizacion}')),
                                                            DataCell(Text(
                                                                '${_docs[index].dEstacionTrabajo}')),
                                                            DataCell(Text(
                                                                '${_docs[index].dFechaReg}')),
                                                            DataCell(Text(
                                                                '${_docs[index].referencia}')),
                                                            DataCell(Text(
                                                                '${_docs[index].refIdDocumento}')),
                                                            DataCell(Text(
                                                                '${_docs[index].refSerie}')),
                                                            DataCell(Text(
                                                                '${_docs[index].documentoNombre}')),
                                                            DataCell(Text(
                                                                '${_docs[index].idCuenta}')),
                                                            DataCell(Text(
                                                                '${_docs[index].dReferencia}')),
                                                            DataCell(Text(
                                                                '${_docs[index].rReferenciaId}')),
                                                            DataCell(Text(
                                                                '${_docs[index].rIdDocumentoOrigen}')),
                                                            DataCell(Text(
                                                                '${_docs[index].feCae}')),
                                                            DataCell(Text(
                                                                '${_docs[index].feNumeroDocumento}')),
                                                            //BOTÓN MOSTRAR DETALLES:
                                                            DataCell(
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              MdiIcons.textBoxSearchOutline,
                                                                              color: Color(0xFFDD952A),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 8,
                                                                            ),
                                                                            Text(
                                                                              S.of(context).detalles,
                                                                              style: TextStyle(color: Color(0xFFDD952A), fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        content:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "${S.of(context).saldo}:",
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF154790),
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 8),
                                                                                  Text(
                                                                                    '${_docs[index].saldo}',
                                                                                    style: TextStyle(color: Color(0xFF154790)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "${S.of(context).saldoMoneda}:",
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF154790),
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 8),
                                                                                  Text(
                                                                                    '${_docs[index].saldoMoneda}',
                                                                                    style: TextStyle(color: Color(0xFF154790)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: <Widget>[
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              S.of(context).cerrar,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Text(_mostrarDetalles &&
                                                                        _selectedRowIndex ==
                                                                            index
                                                                    ? S
                                                                        .of(
                                                                            context)
                                                                        .mostrarDetalles
                                                                    : S
                                                                        .of(context)
                                                                        .mostrarDetalles),
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      })
                                                    : []))),
                                  ),
                                ),
                              if (!_cargando && _docs.isEmpty)
                                SizedBox(
                                  width: 300,
                                  //MOSTRAR MENSAJE "NO HAY DOCUMENTOS PENDIENTES DE PAGO"
                                  child: Card(
                                    elevation: 5,
                                    margin: EdgeInsets.all(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            MdiIcons.fileDocumentAlert,
                                            color: Colors.amber[300],
                                            size: 50,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            S.of(context).sinResultados,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            S
                                                .of(context)
                                                .noHayDocumentosPendientesPorPagar,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              //TARJETAS DE TOTALES APLICANDO, MONTOS, SALDOS Y DIFERENCIA
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _docs.isNotEmpty
                                    ? [
                                        //TOTAL APLICANDO
                                        _buildCard(
                                          S.of(context).totalAplicando,
                                          '${_docs[0].simbolo}$_formattedTotalAplicando',
                                          widget.temaClaro
                                              ? Colors.black
                                              : Colors.white,
                                          widget.temaClaro
                                              ? Colors.black
                                              : Colors.white,
                                          widget.temaClaro
                                              ? Colors.white
                                              : Color.fromARGB(255, 0, 5, 44),
                                        ),
                                        //TOTAL MONTOS
                                        _buildCard(
                                          S.of(context).totalMontos,
                                          '${_docs[0].simbolo}$_formattedTotalMonto',
                                          widget.temaClaro
                                              ? Colors.black
                                              : Colors.white,
                                          widget.temaClaro
                                              ? Colors.black
                                              : Colors.white,
                                          widget.temaClaro
                                              ? Colors.white
                                              : Color.fromARGB(255, 0, 5, 44),
                                        ),
                                        //TOTAL SALDOS
                                        _buildCard(
                                          S.of(context).totalSaldos,
                                          '${_docs[0].simbolo}$_formattedTotalSaldo',
                                          widget.temaClaro
                                              ? Colors.black
                                              : Colors.white,
                                          widget.temaClaro
                                              ? Colors.black
                                              : Colors.white,
                                          widget.temaClaro
                                              ? Colors.white
                                              : Color.fromARGB(255, 0, 5, 44),
                                        ),
                                        //DIFERENCIA
                                        _buildCard(
                                          S.of(context).diferencia,
                                          '${_docs[0].simbolo}$_formattedDiferencia',
                                          widget.temaClaro
                                              ? Colors.orange
                                              : Colors.orange[500]!,
                                          widget.temaClaro
                                              ? Colors.black
                                              : Colors.white,
                                          widget.temaClaro
                                              ? Colors.white
                                              : Color.fromARGB(255, 0, 5, 44),
                                        ),
                                      ]
                                    : [],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              //LLAMADA A WIDGET CREACIÓN RECIBO
                              Visibility(
                                visible: _presionarAplicar &&
                                    // ignore: unnecessary_null_comparison
                                    seleccionadoCuenta_Corriente != null &&
                                    // ignore: unnecessary_null_comparison
                                    seleccionadoEmpresa != null &&
                                    // ignore: unnecessary_null_comparison
                                    seleccionadoOpc_Cuenta_Corriente != null,
                                child: CreacionRecibo(
                                  selectedOpc_Cuenta_Corriente:
                                      seleccionadoOpc_Cuenta_Corriente,
                                  selectedCuenta_Corriente:
                                      seleccionadoCuenta_Corriente,
                                  selectedEmpresa: seleccionadoEmpresa,
                                  selectedEstacionTrabajo:
                                      seleccionadoEstacionTrabajo,
                                  selectedUserName: seleccionadoUserName,
                                  selectedpT_Filtro_6: seleccionadopT_Filtro_6,
                                  selectedbGrupo: seleccionadobGrupo,
                                  selectedpDocumento_Conv:
                                      seleccionadopDocumento_Conv,
                                  selectedpFE_Tipo: seleccionadopFE_Tipo,
                                  selectedpPOS_Tipo: seleccionadopPOS_Tipo,
                                  selectedpVer_FE: seleccionadopVer_FE,
                                  selectedIdCuenta: seleccionadopIdCuenta,
                                  pUserName: widget.pUserName,
                                  pEmpresa: widget.pEmpresa,
                                  pEstacion_Trabajo: widget.pEstacion_Trabajo,
                                  selectedCuentaCta:
                                      widget.seleccionadoCuentaCta,
                                  selectedCuentaCorrentista:
                                      widget.seleccionadoCuentaCorrentista,
                                  facturaNombre: widget.facturaNombre,
                                  facturaNit: widget.facturaNit,
                                  facturaDireccion: widget.facturaDireccion,
                                  montosGuardados: montosGuardados,
                                  documentosSeleccionados: _docsAplicar,
                                  montosGuardadosAcumulados:
                                      montosGuardadosAcumulados,
                                  documentosSeleccionadosAcumulados:
                                      _docsAplicarAcumulados,
                                  ccDireccion: widget.ccDireccion,
                                  telefono: widget.telefono,
                                  changeLanguage: widget.changeLanguage,
                                  seleccionarIdioma: widget.seleccionarIdioma,
                                  idiomaDropDown: _idiomaActual,
                                  baseUrl: widget.baseUrl,
                                  token: widget.token,
                                  temaClaro: widget.temaClaro,
                                  imagePath: widget.imagePath,
                                  isBackgroundSet: widget.isBackgroundSet,
                                  fechaSesion: widget.fechaSesion,
                                  tokenSesionGuardada:
                                      widget.tokenSesionGuardada,
                                  imageLogo: widget.imageLogo,
                                  fechaExpiracion: widget.fechaExpiracion,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ])
                ]),
              ))
        ]));
  }

  Widget _buildDataCard(String label, String value) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Obtener dimensiones de la pantalla
        double cardWidth =
            constraints.maxWidth * 0.4; // Ajusta el ancho de la tarjeta
        double fontSizeLabel = MediaQuery.of(context).size.width *
            0.04; // 4% del ancho de la pantalla
        double fontSizeValue = MediaQuery.of(context).size.width *
            0.030; // 3.5% del ancho de la pantalla
        double spacing =
            MediaQuery.of(context).size.width * 0.01; // Espaciado proporcional

        return Container(
          margin: EdgeInsets.only(right: 12.0),
          padding: EdgeInsets.all(16.0),
          width: cardWidth, // Ancho ajustado
          decoration: BoxDecoration(
            color: const Color.fromARGB(
                178, 255, 255, 255), // Fondo translúcido blanco
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2), // Cambia la posición de la sombra
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Tooltip(
                  message:
                      label, // Texto completo que se mostrará en el tooltip
                  child: Text(
                    label,
                    overflow: TextOverflow
                        .ellipsis, // Muestra "..." si el texto es demasiado largo
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                      fontSize: fontSizeLabel,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              Flexible(
                child: Tooltip(
                  message: value,
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontSize: fontSizeValue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //WIDGET DISEÑO CARTAS DE TOTALES
  Widget _buildCard(String title, String value, Color textColor,
      Color numberColor, Color backgroundColor) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: backgroundColor, // Establece el color de fondo de la tarjeta
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(8.0), // Mantiene las esquinas redondeadas
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4, // Ancho de la línea
              decoration: BoxDecoration(
                color: Colors.orange, // Color de la línea
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: numberColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
