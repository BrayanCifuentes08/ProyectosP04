import 'dart:convert';
import 'dart:ui'; // Importa el paquete necesario para ImageFilter
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:migrar_sql/common/ThemeNotifier.dart';
import 'package:migrar_sql/components/MenuAutenticacion.dart';
import 'package:migrar_sql/components/Plantillas/PlantillaImagen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:migrar_sql/common/Animaciones.dart';
import 'package:migrar_sql/common/Loading.dart';
import 'package:migrar_sql/common/Mensajes.dart';
import 'package:migrar_sql/models/PaBscUser2M.dart';
import 'package:http/http.dart' as http;
import 'package:migrar_sql/generated/l10n.dart';
import 'package:migrar_sql/services/LoginService.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  final Function(Locale) changeLanguage;
  final Locale seleccionarIdioma;
  Locale idiomaDropDown;
  final String imagePath;
  final bool isBackgroundSet;

  LoginScreen(
      {required this.changeLanguage,
      required this.seleccionarIdioma,
      required this.idiomaDropDown,
      required this.imagePath,
      required this.isBackgroundSet});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late Locale _idiomaDropDown;
  String baseUrl = 'http://192.168.10.43:9094/api/';
  String token = "";
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusNode _focusUrl = FocusNode();
  FocusNode _focusUser = FocusNode();
  FocusNode _focusPass = FocusNode();

  bool _isChecking = false;
  String? _checkResult;

  bool temaClaro = true;

  //variables de carga:
  bool _cargandoUser2 = false;

  //models
  List<PaBscUser2M> _user2 = [];

  final LoginService _loginService = LoginService();
  DateTime? fechaExpiracion = null;
  late AnimationController _controllerAnimated;
  int _backGestureCount = 0;

  @override
  void initState() {
    super.initState();
    _idiomaDropDown = widget.idiomaDropDown;
    _controllerAnimated = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    // Asegúrate de liberar el FocusNode cuando el widget se elimine
    _focusUrl.dispose();
    _focusUser.dispose();
    _focusPass.dispose();

    super.dispose();
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

  Future<void> _buscarUser2() async {
    setState(() {
      _cargandoUser2 = true;
    });

    String url = '${baseUrl}PaBscUser2Ctrl';
    Map<String, dynamic> queryParams = {
      "pOpcion": "1",
      "pUserName": _userController.text,
      "pPass": _passwordController.text,
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response =
          await http.get(uri, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        // Parsear la respuesta JSON
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Obtener los datos de la respuesta JSON
        token = jsonResponse['token'];
        bool continuar = jsonResponse['continuar'];
        String mensaje = jsonResponse['mensaje'];
        String userName = jsonResponse['userName'];

        if (continuar) {
          if (token != null) {
            // Guardar el token en SharedPreferences para usarlo más tarde
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('jwtToken', token);

            // Convertir la respuesta en objetos de modelo si tienes una lista
            // Ajustar este paso dependiendo del formato real de tu respuesta de la API
            // Si hay una lista de objetos `PaBscUser2M` en la respuesta, conviértela aquí
            // Aquí supongo que el JSON solo devuelve un objeto en lugar de una lista
            List<PaBscUser2M> user2 = [PaBscUser2M.fromJson(jsonResponse)];

            _user2 = user2;

            // Utilizar los datos convertidos
            print("Bienvenido, $userName");

            _focusUser.unfocus();
            _focusPass.unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuAutenticacion(
                  changeLanguage: widget.changeLanguage,
                  imagePath: widget.imagePath,
                  isBackgroundSet: widget.isBackgroundSet,
                  idiomaDropDown: widget.idiomaDropDown,
                  temaClaro: temaClaro,
                  token: token,
                  baseUrl: baseUrl,
                  user2: _user2,
                  urlController: _urlController,
                  userController: _userController,
                  cargandoUser2: _cargandoUser2,
                  passwordController: _passwordController,
                ),
              ),
            );
          } else {
            // Mostrar el mensaje de advertencia si no hay token
            Mensajes.mensajeAdvertencia(
                context,
                mensaje,
                temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
                temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
                temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
          }
        } else {
          // Mostrar el mensaje de advertencia si continuar es false
          Mensajes.mensajeAdvertencia(
              context,
              mensaje,
              temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
              temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
              temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
        }
      } else {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Error User: ${response.statusCode}');
        print('${response.body}');
        List<PaBscUser2M> user2 = [PaBscUser2M.fromJson(jsonResponse)];
        _user2 = user2;
        // Mostrar un mensaje genérico si el estado de respuesta no es 200
        Mensajes.mensajeAdvertencia(
            context,
            _user2[0].mensaje,
            temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
            temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
            temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      }
    } catch (error) {
      print('Error: $error');
      // Mostrar un mensaje de error genérico en caso de excepción
      print("error aqui 2");
      Mensajes.mensajeAdvertencia(
          context,
          'Error de conexión: (Verificar Url o conexión a Internet)',
          temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
    } finally {
      setState(() {
        _cargandoUser2 = false;
      });
    }
  }

  void _verificarCampos() {
    if (_userController.text == "") {
      Mensajes.mensajeAdvertencia(
          context,
          S.of(context).loginDebeIngresarElUsuario,
          temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      _focusUser.requestFocus();
      return;
    }
    if (_passwordController.text == "") {
      Mensajes.mensajeAdvertencia(
          context,
          S.of(context).loginDebeIngresarLaContrasena,
          temaClaro ? Colors.white : Color.fromARGB(255, 73, 73, 73),
          temaClaro ? Color.fromARGB(255, 83, 83, 83) : Colors.white,
          temaClaro ? Color.fromARGB(255, 0, 0, 0) : Colors.white);
      _focusPass.requestFocus();
      return;
    }

    _buscarUser2();
  }

  //Mensaje para cambiar Url Api
  void mostrarDialogoBaseUrl() async {
    _urlController.text =
        baseUrl; // Inicializa el controlador con la baseUrl actual

    showDialog(
      barrierColor: temaClaro
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
              backgroundColor: temaClaro
                  ? Colors.white
                  : Color.fromARGB(255, 18, 32, 47).withOpacity(0.9),
              title: Text(
                'URL:',
                style:
                    TextStyle(color: temaClaro ? Colors.black : Colors.white),
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
                        labelText: '${S.of(context).loginIngresarURL}',
                        labelStyle: TextStyle(
                            color: temaClaro ? Colors.black : Colors.white),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link,
                            color: temaClaro
                                ? Color.fromARGB(255, 56, 125, 253)
                                : Color.fromARGB(255, 129, 181, 248)),
                        suffixIcon: IconButton(
                          highlightColor:
                              const Color.fromARGB(255, 97, 168, 201),
                          icon: Icon(Icons.paste,
                              color: temaClaro ? Colors.black : Colors.white),
                          onPressed: () async {
                            Clipboard.setData(
                                ClipboardData(text: _urlController.text));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(S.of(context).loginTextoCopiado),
                            ));
                          },
                        ),
                      ),
                      cursorColor:
                          temaClaro ? Color(0xFFDD952A) : Colors.blue.shade600,
                      style: TextStyle(
                        color: temaClaro
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
                          color:
                              _checkResult == '${S.of(context).loginURLvalida}'
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
                              ? '${S.of(context).loginURLvalida}'
                              : '${S.of(context).loginURLNoValida}';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: Text(
                        '${S.of(context).loginVerificar}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          baseUrl = _urlController.text;
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                      ),
                      child: Text(
                        '${S.of(context).loginConfirmar}',
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

  Future<bool> _onWillPop() async {
    if (_backGestureCount == 0) {
      _backGestureCount++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Si vuelves a deslizar, saldrás de la aplicación."),
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

  @override
  Widget build(BuildContext context) {
    // Verifica si el valor seleccionado está en la lista
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Stack(
            children: [
              if (!widget.isBackgroundSet)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF004964),
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              if (!widget.isBackgroundSet)
                AnimatedBackground(
                  behaviour: RandomParticleBehaviour(
                      options: ParticleOptions(
                          baseColor: Colors.white,
                          spawnMinRadius: 40,
                          spawnMaxRadius: 80,
                          spawnMinSpeed: 15,
                          particleCount: 6,
                          spawnMaxSpeed: 80,
                          spawnOpacity: 0.2,
                          image: Image.asset("assets/image.png"))),
                  vsync: this,
                  child: Container(),
                ),
              // Fondo animado con AnimatedBackground
              if (widget.isBackgroundSet)
                BackgroundImage(imagePath: widget.imagePath),
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimacionesIcons(
                              icon1: Icons.light_mode,
                              icon2: Icons.dark_mode,
                              condicion: temaClaro,
                              onPressed: () {
                                setState(() {
                                  temaClaro = !temaClaro;
                                });
                              },
                              colorIcon1: Colors.grey[200]!,
                              colorIcon2: Colors.grey[200]!,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.image,
                                color: temaClaro
                                    ? Colors.grey[200]
                                    : Colors.grey[200],
                              ),
                              onPressed: () {
                                setState(() {
                                  Navigator.pushNamed(
                                    context,
                                    '/selectBackground',
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(32.0),
                              child: Stack(
                                children: [
                                  // Contenedor principal
                                  Container(
                                    padding: EdgeInsets.all(32.0),
                                    decoration: BoxDecoration(
                                      color: temaClaro
                                          ? Color.fromARGB(255, 255, 255, 255)
                                              .withOpacity(0.9)
                                          : Color.fromARGB(255, 18, 32, 47)
                                              .withOpacity(
                                                  0.9), // Transparencia adicional para suavizar el fondo
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 4,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF5A38FD),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: AnimacionTextBarrido(
                                                  text:
                                                      '${S.of(context).loginIniciarSesion}',
                                                  colorClaro: Color(0xFF5A38FD),
                                                  colorOscuro:
                                                      Color(0xFF818CF8),
                                                  temaClaro:
                                                      themeNotifier.temaClaro,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                MdiIcons.earthPlus,
                                                color: temaClaro
                                                    ? Colors.blue
                                                    : Colors.cyan[300],
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                mostrarDialogoBaseUrl();
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 32),
                                        TextField(
                                          controller: _userController,
                                          focusNode: _focusUser,
                                          onEditingComplete: () {
                                            // Llama a unfocus() cuando el usuario completa la edición
                                            _focusUser.unfocus();
                                          },
                                          decoration: InputDecoration(
                                            labelText:
                                                '${S.of(context).loginUsuario}',
                                            labelStyle: TextStyle(
                                              color: temaClaro
                                                  ? Colors.grey[700]
                                                  : Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.blueGrey.shade200,
                                                width: 1.5,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Color(0xFF5A38FD),
                                                width: 2,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.blueGrey.shade200,
                                                width: 1.5,
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    horizontal: 12),
                                            hintText:
                                                '${S.of(context).loginIngresaUsuario}',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500]),
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: _focusUser.hasFocus
                                                  ? Color(0xFF5A38FD)
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                          cursorColor: temaClaro
                                              ? Color(0xFFDD952A)
                                              : Colors.blue.shade600,
                                          style: TextStyle(
                                            color: temaClaro
                                                ? Colors.black
                                                : Colors
                                                    .white, // Color del texto ingresado
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        TextField(
                                          controller: _passwordController,
                                          focusNode: _focusPass,
                                          onEditingComplete: () {
                                            // Llama a unfocus() cuando el usuario completa la edición
                                            _focusPass.unfocus();
                                          },
                                          decoration: InputDecoration(
                                            labelText:
                                                '${S.of(context).loginContrasena}',
                                            labelStyle: TextStyle(
                                              color: temaClaro
                                                  ? Colors.grey[700]
                                                  : Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.blueGrey.shade200,
                                                width: 1.5,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Color(0xFF5A38FD),
                                                width: 2,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.blueGrey.shade200,
                                                width: 1.5,
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    horizontal: 12),
                                            hintText:
                                                '${S.of(context).loginIngresaContrasena}',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500]),
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              color: _focusPass.hasFocus
                                                  ? Color(0xFF5A38FD)
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                          obscureText: true,
                                          obscuringCharacter: '●',
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          cursorColor: temaClaro
                                              ? Color(0xFFDD952A)
                                              : Colors.blue.shade600,
                                          style: TextStyle(
                                            color: temaClaro
                                                ? Colors.black
                                                : Colors
                                                    .white, // Color del texto ingresado
                                          ),
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                        ),
                                        SizedBox(height: 5),
                                        SizedBox(height: 10),
                                        // BOTON INICIAR SESIÓN
                                        ElevatedButton(
                                          onPressed: () {
                                            _focusPass.unfocus();
                                            _focusUser.unfocus();
                                            _verificarCampos();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                Size(double.infinity, 50),
                                            backgroundColor: Color(0xFF5A38FD),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            '${S.of(context).loginIniciarSesion}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        // COMPONENTE DE CARGA
                                        if (_cargandoUser2)
                                          LoadingComponent(
                                            color: Colors.blue[200]!,
                                            changeLanguage:
                                                widget.changeLanguage,
                                          ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        //Dropdown e icono de lenguaje
                                        Container(
                                          width: double
                                              .infinity, // Asegura que el Row ocupe todo el ancho disponible
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: temaClaro
                                                      ? Colors.blueAccent
                                                      : Color(0xFF5A38FD),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      offset: Offset(0, 2),
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(Icons.language,
                                                    color: Colors.white,
                                                    size: 24),
                                              ),
                                              SizedBox(width: 8.0),
                                              Expanded(
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0),
                                                    decoration: BoxDecoration(
                                                      color: temaClaro
                                                          ? Colors.grey[200]
                                                          : Color.fromARGB(
                                                              255, 25, 25, 25),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton<
                                                          Locale>(
                                                        isExpanded: true,
                                                        icon: Icon(
                                                          Icons.arrow_drop_down,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                        dropdownColor: temaClaro
                                                            ? Colors.grey[200]
                                                            : Colors.grey[800],
                                                        value: _idiomaDropDown,
                                                        onChanged: (Locale?
                                                            newLocale) {
                                                          if (newLocale !=
                                                              null) {
                                                            setState(() {
                                                              _idiomaDropDown =
                                                                  newLocale;
                                                            });
                                                            widget
                                                                .changeLanguage(
                                                                    newLocale);
                                                          }
                                                        },
                                                        items: [
                                                          DropdownMenuItem(
                                                            value: Locale(
                                                                'es', 'ES'),
                                                            child: Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Image
                                                                      .asset(
                                                                    'icons/flags/png100px/es.png',
                                                                    package:
                                                                        'country_icons',
                                                                    width: 24,
                                                                    height: 24,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 8),
                                                                Expanded(
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child:
                                                                        Tooltip(
                                                                      message:
                                                                          'Español',
                                                                      child:
                                                                          Text(
                                                                        'Español',
                                                                        style:
                                                                            TextStyle(
                                                                          color: temaClaro
                                                                              ? Colors.grey[800]
                                                                              : Colors.white,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: Locale(
                                                                'en', 'US'),
                                                            child: Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Image
                                                                      .asset(
                                                                    'icons/flags/png100px/us.png',
                                                                    package:
                                                                        'country_icons',
                                                                    width: 24,
                                                                    height: 24,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 8),
                                                                Expanded(
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child:
                                                                        Tooltip(
                                                                      message:
                                                                          'English',
                                                                      child:
                                                                          Text(
                                                                        'English',
                                                                        style:
                                                                            TextStyle(
                                                                          color: temaClaro
                                                                              ? Colors.grey[800]
                                                                              : Colors.white,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: Locale(
                                                                'fr', 'FR'),
                                                            child: Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Image
                                                                      .asset(
                                                                    'icons/flags/png100px/fr.png',
                                                                    package:
                                                                        'country_icons',
                                                                    width: 24,
                                                                    height: 24,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 8),
                                                                Expanded(
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child:
                                                                        Tooltip(
                                                                      message:
                                                                          'French',
                                                                      child:
                                                                          Text(
                                                                        'French',
                                                                        style:
                                                                            TextStyle(
                                                                          color: temaClaro
                                                                              ? Colors.grey[800]
                                                                              : Colors.white,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: Locale(
                                                                'de', 'DE'),
                                                            child: Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Image
                                                                      .asset(
                                                                    'icons/flags/png100px/de.png',
                                                                    package:
                                                                        'country_icons',
                                                                    width: 24,
                                                                    height: 24,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 8),
                                                                Expanded(
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child:
                                                                        Tooltip(
                                                                      message:
                                                                          'German',
                                                                      child:
                                                                          Text(
                                                                        'German',
                                                                        style:
                                                                            TextStyle(
                                                                          color: temaClaro
                                                                              ? Colors.grey[800]
                                                                              : Colors.white,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
