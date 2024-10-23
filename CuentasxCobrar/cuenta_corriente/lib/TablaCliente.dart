import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_cuenta_corriente/common/Animaciones.dart';
import 'package:test_cuenta_corriente/common/Mensajes.dart';
import 'package:test_cuenta_corriente/Models/PaBscCuentaCorrentistaMovilM.dart';
import 'package:test_cuenta_corriente/DocPendientesPago.dart';
import 'package:test_cuenta_corriente/common/Loading.dart';
import 'package:http/http.dart' as http;
import 'package:test_cuenta_corriente/PlantillaImagen.dart';
import 'package:test_cuenta_corriente/common/Transiciones.dart';
import 'package:test_cuenta_corriente/generated/l10n.dart';
import 'package:test_cuenta_corriente/services/LoginService.dart';
import 'package:url_launcher/url_launcher.dart';

class TablaCliente extends StatefulWidget {
  final String pUserName;
  final int pEmpresa;
  final int pEstacion_Trabajo;
  final Function(Locale) changeLanguage;
  final Locale seleccionarIdioma;
  Locale idiomaDropDown;
  String baseUrl;
  final String token;
  bool temaClaro;
  final String imagePath;
  final bool isBackgroundSet;
  final DateTime fechaSesion;
  final DateTime? fechaExpiracion;
  final String? imageLogo;

  TablaCliente({
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
    this.imageLogo,
    this.fechaExpiracion,
  });

  @override
  _TablaClienteState createState() => _TablaClienteState();
}

class _TablaClienteState extends State<TablaCliente>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _buscarController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  bool _isChecking = false;
  String? _checkResult;
  List<PaBscCuentaCorrentistaMovilM> _clientes = [];
  Color _defaultColor = Colors.transparent;
  bool _cargando = false;
  bool _mostrarWarningCard = false;
  List<bool> _isChecked = [];
  bool _hayCheckboxSeleccionado = false;
  int _backGestureCount = 0;
  //Parametros que se van a necesitar para otros archivos:
  int _seleccionadoCuentaCorrentista = 0;
  String? _seleccionadoCuentaCta;
  String? _seleccionadofacturaNombre;
  String? _seleccionadofacturaNit;
  String? _seleccionadofacturaDireccion;
  String? _seleccionadoccDireccion;
  String? _seleccionadotelefono;
  bool tokenSesionGuardada = false;
  String? _imageLogo;
  late Locale _idiomaActual;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _backGestureCount = 0;
    _idiomaActual = widget.idiomaDropDown;
    if (_imageLogo == null) {
      _imageLogo == widget.imageLogo;
    }
    _checkToken();
    _loadImagePath();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageLogo = prefs.getString('logo_image_path');
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
        _imageLogo = pickedFile.path;
      });
    }
  }

  Future<void> _checkToken() async {
    final loginService = LoginService();
    String? token = await loginService.getToken();
    setState(() {
      tokenSesionGuardada = token != null && token.isNotEmpty;
    });
  }

  Future<void> _BuscarCliente() async {
    setState(() {
      _cargando = true; // Establecer isLoading a true al inicio de la carga
    });

    String url = '${widget.baseUrl}PaBscCuentaCorrentistaMovilCtrl';

    Map<String, dynamic> queryParams = {
      "pUserName": widget.pUserName.toString(),
      "pCriterio_Busqueda": _buscarController.text,
      "pEmpresa": widget.pEmpresa.toString()
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
        List<PaBscCuentaCorrentistaMovilM> clientes = jsonResponse
            .map((data) => PaBscCuentaCorrentistaMovilM.fromJson(data))
            .toList();
        setState(() {
          _clientes = clientes;
          _isChecked = List<bool>.filled(clientes.length, false);
        });
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

  void mostrarDialogoBaseUrl() async {
    _urlController.text =
        widget.baseUrl; // Inicializa el controlador con la baseUrl actual

    showDialog(
      barrierColor: widget.temaClaro
          ? Color.fromARGB(193, 0, 0, 0)
          : Color.fromARGB(193, 0, 0, 0),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _urlController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _urlController.text.length,
              );
            });
            return AlertDialog(
              backgroundColor: widget.temaClaro
                  ? Colors.white
                  : Color.fromARGB(255, 18, 32, 47).withOpacity(0.9),
              title: Text(
                'URL:',
                style: TextStyle(
                    color: widget.temaClaro ? Colors.black : Colors.white),
              ),
              content: Container(
                width: double
                    .maxFinite, // Permite que el diálogo se adapte a la pantalla
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: '${S.of(context).ingresarURL}',
                        labelStyle: TextStyle(
                            color:
                                widget.temaClaro ? Colors.black : Colors.white),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link,
                            color:
                                widget.temaClaro ? Colors.black : Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.paste,
                              color: widget.temaClaro
                                  ? Colors.black
                                  : Colors.white),
                          onPressed: () async {
                            Clipboard.setData(
                                ClipboardData(text: _urlController.text));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(S.of(context).textoCopiado),
                            ));
                          },
                        ),
                      ),
                      cursorColor: widget.temaClaro
                          ? Color(0xFFDD952A)
                          : Colors.blue.shade600,
                      style: TextStyle(
                        color: widget.temaClaro
                            ? Colors.black
                            : Colors.white, // Color del texto ingresado
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                    ),
                    if (_isChecking)
                      CircularProgressIndicator(), // Indicador de carga mientras se verifica la URL
                    if (_checkResult != null)
                      Text(
                        _checkResult!,
                        style: TextStyle(
                          fontSize: 14,
                          color: _checkResult == '${S.of(context).URLvalida}'
                              ? Colors.green // Verde para URL válida
                              : Colors.red, // Rojo para URL no válida
                        ),
                      ), // Muestra el resultado de la verificación
                  ],
                ),
              ),
              actions: [
                Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isChecking = true;
                        });

                        final isValid =
                            await verificarBaseUrl(_urlController.text);
                        setState(() {
                          _isChecking = false;
                          _checkResult = isValid
                              ? '${S.of(context).URLvalida}'
                              : '${S.of(context).URLNoValida}';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: Text(
                        '${S.of(context).verificar}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.baseUrl = _urlController.text;
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                      ),
                      child: Text(
                        '${S.of(context).confirmar}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
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
                  : Color.fromARGB(0, 0, 0, 0),
              key: _scaffoldKey,

              //LÓGICA PARA MENÚ LATERAL:
              drawer: Container(
                decoration: BoxDecoration(
                  color: widget.temaClaro
                      ? Color(0x0F0929292) // Color de fondo en modo claro
                      : Color.fromARGB(
                          255, 65, 65, 65), // Color de fondo en modo oscuro
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
                      : Color.fromARGB(
                          255, 65, 65, 65), // Fondo del drawer en modo oscuro
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
                                      feedback: _imageLogo != null
                                          ? Image.file(File(_imageLogo!),
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
                                        child: _imageLogo != null
                                            ? Image.file(File(_imageLogo!),
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
                                      child: _imageLogo != null
                                          ? Image.file(File(_imageLogo!),
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
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          mostrarDialogoBaseUrl();
                                        },
                                        child: Icon(
                                          MdiIcons.earthPlus,
                                          color: widget.temaClaro
                                              ? Colors.lightBlue[800]
                                              : Colors.cyan[300],
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                  if (tokenSesionGuardada)
                                    GestureDetector(
                                      onTap: () {
                                        Mensajes.cerrarSesionUsuario(
                                            widget.temaClaro,
                                            context,
                                            widget.pUserName,
                                            widget.fechaSesion,
                                            widget.fechaExpiracion);
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
                              customPageRoute(
                                TablaCliente(
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
                                ),
                                Duration(milliseconds: 400),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(0, 68, 137,
                                    255) // Color del botón en modo claro

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
                      if (_seleccionadoCuentaCorrentista != null &&
                          _seleccionadoCuentaCta != null &&
                          _hayCheckboxSeleccionado)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                customPageRoute(
                                  TablaDocsPendientes(
                                    seleccionadoCuentaCorrentista:
                                        _seleccionadoCuentaCorrentista,
                                    seleccionadoCuentaCta:
                                        _seleccionadoCuentaCta.toString(),
                                    facturaNombre:
                                        _seleccionadofacturaNombre.toString(),
                                    facturaNit:
                                        _seleccionadofacturaNit.toString(),
                                    facturaDireccion:
                                        _seleccionadofacturaDireccion
                                            .toString(),
                                    ccDireccion:
                                        _seleccionadoccDireccion.toString(),
                                    telefono: _seleccionadotelefono.toString(),
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
                                    tokenSesionGuardada: tokenSesionGuardada,
                                    imageLogo: _imageLogo,
                                    verificarCaptcha: false,
                                  ),
                                  Duration(milliseconds: 400),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(0, 68, 137, 255),
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
                      SizedBox(height: 95),
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
                                SizedBox(width: 10),
                                Text(
                                  S.of(context).idiomaMenu,
                                  style: TextStyle(
                                    color: widget.temaClaro
                                        ? Colors
                                            .white // Color del texto en modo claro
                                        : Colors.grey[
                                            300], // Color del texto en modo oscuro
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
                                color: widget.temaClaro
                                    ? Colors.grey[
                                        800] // Color del contenedor en modo claro
                                    : Colors
                                        .black, // Color del contenedor en modo oscuro
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Locale>(
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: widget.temaClaro
                                          ? Colors
                                              .white // Color del ícono del dropdown en modo claro
                                          : Colors
                                              .black), // Color del ícono del dropdown en modo oscuro
                                  dropdownColor: widget.temaClaro
                                      ? Colors.grey[
                                          800] // Color del dropdown en modo claro
                                      : Colors
                                          .black, // Color del dropdown en modo oscuro
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
                      ListTile(
                        leading: Container(
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
                          child: Icon(
                              Icons.image, // Icono representando una imagen
                              color: widget.temaClaro
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              size: 22),
                        ),
                        title: Text(
                          S.of(context).cambiarPlantilla,
                          style: TextStyle(
                            color: widget.temaClaro
                                ? Colors.white
                                : Colors.grey[300],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/selectBackground',
                          );
                        },
                      ),
                      SizedBox(
                        height: 150,
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
              body: Stack(children: [
                if (widget.isBackgroundSet)
                  BackgroundImage(imagePath: widget.imagePath),
                CustomScrollView(slivers: [
                  SliverAppBar(
                    expandedHeight: 180.0,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
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
                          padding: const EdgeInsets.only(
                              top: 90.0, left: 20.0, right: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _buscarController,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).ingresarCriterio,
                                    hintStyle: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 119, 119, 119),
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 15.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        if (_buscarController.text.isEmpty) {
                                          setState(() {
                                            _cargando = true;
                                            _mostrarWarningCard = true;
                                            _timer =
                                                Timer(Duration(seconds: 5), () {
                                              if (mounted) {
                                                setState(() {
                                                  _cargando = false;
                                                });
                                              }
                                            });
                                          });
                                        } else {
                                          _BuscarCliente();
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        padding: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.search,
                                                color: Colors.blueAccent),
                                            SizedBox(width: 6),
                                            Text(
                                              S.of(context).buscar,
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    leading: IconButton(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0),
                      icon: Icon(Icons.menu_open_outlined,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: 10.0, top: 10.0, bottom: 5.0),
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: _cargando
                              ? 0.5
                              : 1.0, // Cambia la opacidad según el estado
                          child: Image.asset(
                            'assets/logo.png',
                            height: 40.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (_cargando)
                                LoadingComponent(
                                  color: widget.temaClaro
                                      ? Colors.blue[800]!
                                      : Colors.white,
                                  changeLanguage: widget.changeLanguage,
                                ),
                              //TÍTULO TABLA CLIENTES:
                              if (_clientes.isNotEmpty)
                                Text(
                                  S.of(context).tablaClientes,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: widget.temaClaro
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              //TABLA CLIENTES
                              if (_clientes.isNotEmpty)
                                Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: widget.temaClaro
                                          ? Colors.white
                                          : Colors.grey[400]!,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 700,
                                    width: double.infinity,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: DataTable(
                                          //COLOR DE COLUMNAS TABLA CLIENTES:
                                          headingRowColor:
                                              MaterialStateColor.resolveWith(
                                            (states) => widget.temaClaro
                                                ? Color(0xFFDD952A)
                                                : Colors.grey[800]!,
                                          ),
                                          dataRowColor:
                                              MaterialStateColor.resolveWith(
                                            (states) => widget.temaClaro
                                                ? Colors.white
                                                : Colors.grey[600]!,
                                          ),
                                          columnSpacing: 20,
                                          //NOMBRE DE COLUMNAS TABLA CLIENTES:
                                          columns: [
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).selectCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .facturaNombreCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).cuentaCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).ctaCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .facturaNitCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .facturaDireccionCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .ccDireccionCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .descripcionCuentaCtaCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .direccion1CuentaCtaCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).emailCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).telefonoCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S.of(context).celularCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .limiteCreditoCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .permitirCxCCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .grupoCuentaCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                  S
                                                      .of(context)
                                                      .descripcionGrupoCuentaCliente,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: widget.temaClaro
                                                          ? Colors.white
                                                          : Color(0xFFDD952A))),
                                            ),
                                          ],
                                          //FILAS TABLA CLIENTES:
                                          rows: List.generate(
                                            _clientes.length,
                                            (index) => DataRow(
                                              color: MaterialStateColor
                                                  .resolveWith(
                                                (states) => index % 2 == 0
                                                    ? (widget.temaClaro
                                                        ? Colors.white
                                                        : Colors.grey[400]!)
                                                    : (widget.temaClaro
                                                        ? Colors.grey[200]!
                                                        : Colors.grey[
                                                            500]!), // Alternar colores de fila para mejor legibilidad
                                              ),
                                              cells: [
                                                DataCell(
                                                  Checkbox(
                                                    value: _isChecked[index],
                                                    activeColor:
                                                        widget.temaClaro
                                                            ? null
                                                            : Color(0xFFDD952A),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        // Desactivar todos los demás checkboxes
                                                        for (int i = 0;
                                                            i <
                                                                _isChecked
                                                                    .length;
                                                            i++) {
                                                          if (i != index) {
                                                            _isChecked[i] =
                                                                false;
                                                          }
                                                        }
                                                        // Activar el checkbox seleccionado
                                                        _isChecked[index] =
                                                            value!;
                                                        _hayCheckboxSeleccionado =
                                                            _isChecked.any(
                                                                (isChecked) =>
                                                                    isChecked);
                                                        // Guardar los valores seleccionados
                                                        if (value) {
                                                          _seleccionadoCuentaCorrentista =
                                                              _clientes[index]
                                                                  .cuenta_Correntista;
                                                          _seleccionadoCuentaCta =
                                                              _clientes[index]
                                                                  .cuentaCta;
                                                          _seleccionadofacturaNombre =
                                                              _clientes[index]
                                                                  .facturaNombre;
                                                          _seleccionadofacturaNit =
                                                              _clientes[index]
                                                                  .facturaNit;
                                                          _seleccionadofacturaDireccion =
                                                              _clientes[index]
                                                                  .facturaDireccion;
                                                          _seleccionadoccDireccion =
                                                              _clientes[index]
                                                                  .ccDireccion;
                                                          _seleccionadotelefono =
                                                              _clientes[index]
                                                                  .telefono;
                                                          Navigator.push(
                                                            context,
                                                            customPageRoute(
                                                              TablaDocsPendientes(
                                                                seleccionadoCuentaCorrentista:
                                                                    _seleccionadoCuentaCorrentista,
                                                                seleccionadoCuentaCta:
                                                                    _seleccionadoCuentaCta
                                                                        .toString(),
                                                                facturaNombre:
                                                                    _seleccionadofacturaNombre
                                                                        .toString(),
                                                                facturaNit:
                                                                    _seleccionadofacturaNit
                                                                        .toString(),
                                                                facturaDireccion:
                                                                    _seleccionadofacturaDireccion
                                                                        .toString(),
                                                                ccDireccion:
                                                                    _seleccionadoccDireccion
                                                                        .toString(),
                                                                telefono:
                                                                    _seleccionadotelefono
                                                                        .toString(),
                                                                pUserName: widget
                                                                    .pUserName,
                                                                pEmpresa: widget
                                                                    .pEmpresa,
                                                                pEstacion_Trabajo:
                                                                    widget
                                                                        .pEstacion_Trabajo,
                                                                changeLanguage:
                                                                    widget
                                                                        .changeLanguage,
                                                                seleccionarIdioma:
                                                                    widget
                                                                        .seleccionarIdioma,
                                                                idiomaDropDown:
                                                                    _idiomaActual,
                                                                baseUrl: widget
                                                                    .baseUrl,
                                                                token: widget
                                                                    .token,
                                                                temaClaro: widget
                                                                    .temaClaro,
                                                                imagePath: widget
                                                                    .imagePath,
                                                                isBackgroundSet:
                                                                    widget
                                                                        .isBackgroundSet,
                                                                fechaSesion: widget
                                                                    .fechaSesion,
                                                                fechaExpiracion:
                                                                    widget
                                                                        .fechaExpiracion,
                                                                tokenSesionGuardada:
                                                                    tokenSesionGuardada,
                                                                imageLogo:
                                                                    _imageLogo,
                                                                verificarCaptcha:
                                                                    false,
                                                              ),
                                                              Duration(
                                                                  milliseconds:
                                                                      400),
                                                            ),
                                                          );
                                                        } else {}
                                                      });
                                                    },
                                                  ),
                                                ),
                                                DataCell(Text(
                                                  '${_clientes[index].facturaNombre}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].cuenta_Correntista}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].cuentaCta}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].facturaNit}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].facturaDireccion}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].ccDireccion}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].desCuentaCta}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].direccion1CuentaCta}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].email}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].telefono}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].celular}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].limiteCredito}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].permitirCxC}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].grupoCuenta}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                                DataCell(Text(
                                                  '${_clientes[index].desGrupoCuenta}',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              //NO HAY DATOS QUE COINCIDAN CON EL CRITERIO DE BUSQUEDA:
                              if (!_cargando &&
                                  _clientes.isEmpty &&
                                  _buscarController.text.isNotEmpty)
                                SizedBox(
                                  width: 300,
                                  child: Card(
                                    elevation: 5,
                                    margin: EdgeInsets.all(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            MdiIcons.accountAlert,
                                            color: Colors.amber[300],
                                            size: 50,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            S.of(context).noSeLocalizaronDatos,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            S
                                                .of(context)
                                                .noHayDatosQueCoincidanConElCriterioDeBusqueda,
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
                              //SE DEBE INGRESAR  UN CRITERIO DE BUSQUEDA OBLIGATORIAMENTE:
                              if (!_cargando &&
                                  _clientes.isEmpty &&
                                  _mostrarWarningCard &&
                                  _buscarController.text.isEmpty)
                                SizedBox(
                                  width: 300,
                                  child: Card(
                                    elevation: 5,
                                    margin: EdgeInsets.all(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.amber[300],
                                            size: 50,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            S.of(context).advertencia,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            S
                                                .of(context)
                                                .debeIngresarCriterioBusqueda,
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
                            ],
                          ),
                        ),
                      ),
                    ]),
                  )
                ])
              ]))
        ]));
  }
}
