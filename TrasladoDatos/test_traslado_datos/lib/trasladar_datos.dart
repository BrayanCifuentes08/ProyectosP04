import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;

class TrasladarDatosScreen extends StatefulWidget {
  @override
  _TrasladarDatosScreenState createState() => _TrasladarDatosScreenState();
}

class _TrasladarDatosScreenState extends State<TrasladarDatosScreen> {
  String baseUrl = 'http://192.168.10.39:9091/api/';
  // ignore: unused_field
  bool _expandir = false;
  TextEditingController _serverController = TextEditingController();
  TextEditingController _databaseController = TextEditingController();
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  PlatformFile? _archivoSeleccionado;
  String? _tablaSeleccionada;
  Dio _dio = Dio();
  List<String> _nombresHojas = [];
  String? _nombreHojaSeleccionada;
  final TextEditingController _urlController = TextEditingController();
  bool _isChecking = false;
  String? _checkResult;

  @override
  void initState() {
    super.initState();
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
        baseUrl; // Inicializa el controlador con la baseUrl actual

    showDialog(
      barrierColor: Color.fromARGB(193, 0, 0, 0),
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
              backgroundColor: Colors.white,
              title: Text(
                'URL:',
                style: TextStyle(color: Colors.black),
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
                        labelText: 'Ingresar Url',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link,
                            color: Color.fromARGB(255, 56, 125, 253)),
                        suffixIcon: IconButton(
                          highlightColor:
                              const Color.fromARGB(255, 97, 168, 201),
                          icon: Icon(Icons.paste, color: Colors.black),
                          onPressed: () async {
                            Clipboard.setData(
                                ClipboardData(text: _urlController.text));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "Url copiada",
                            )));
                          },
                        ),
                      ),
                      cursorColor: Color(0xFFDD952A),
                      style: TextStyle(
                        color: Colors.black, // Color del texto ingresado
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
                          color: _checkResult == 'URL válida'
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
                          _checkResult =
                              isValid ? 'Url válida' : 'Url no válida';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: Text(
                        'Verificar',
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
                        'Confirmar',
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

  void _msgSeleccionarTablaSQL() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Color.fromARGB(255, 255, 16, 16),
              ),
              SizedBox(width: 10),
              Text(
                'Input vacío',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 16, 16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Por favor, seleccione antes el nombre de una tabla SQL.',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Color.fromARGB(255, 255, 16, 16)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _msgPosiblesInconvenientes() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Icon(
              Icons.warning,
              color: Color(0xFFDC9525),
            ),
            SizedBox(width: 10),
            Text(
              'Inconveniente',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFDC9525),
              ),
            ),
          ]),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Posibles inconvenientes:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF154790),
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  children: [
                    Text(
                      '  - Hoja Excel seleccionada incorrecta\n',
                      style: TextStyle(color: Color(0xFF154790)),
                    ),
                    Text(
                      '  - Archivo Excel incorrecto',
                      style: TextStyle(color: Color(0xFF154790)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC9525),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _msgSeleccionarArchivo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF154790),
            ),
          ),
          content: Text(
            'No se ha seleccionado un archivo',
            style: TextStyle(color: Color(0xFF154790)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFDC9525)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _msgConfirmar() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  MdiIcons.checkUnderline,
                  color: Color(0xFFDC9525),
                ),
                SizedBox(width: 10),
                Text(
                  'Confirmar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC9525),
                  ),
                ),
              ],
            ),
            content: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: '¿Desea insertar los datos de la hoja ',
                      style: TextStyle(color: Color(0xFF154790))),
                  TextSpan(
                    text: '$_nombreHojaSeleccionada',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF154790)),
                  ),
                  TextSpan(
                      text: ' a la tabla ',
                      style: TextStyle(color: Color(0xFF154790))),
                  TextSpan(
                    text: '$_tablaSeleccionada',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF154790)),
                  ),
                  TextSpan(
                      text: '?', style: TextStyle(color: Color(0xFF154790))),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Regresar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC9525),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  switch (_tablaSeleccionada) {
                    case "Bodega":
                      _insertBodega();
                    case "Clase_Producto":
                      _insertClaseProducto();
                    case "Marca":
                      _insertMarca();
                    case "Producto":
                      _insertProducto();
                    case "Tipo_Precio":
                      _insertTipoPrecio();
                    case "Unidad_Medida":
                      _insertUnidadMedida();
                  }
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFFDC9525)),
                ),
              ),
            ],
          );
        });
  }

  void _msgInsertadoCorrectamente() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.check_circle, // Success icon
                color: Color(0xFFDC9525), // Cyan
              ),
              SizedBox(width: 10.0),
              Text(
                '¡Éxito!', // More positive title
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC9525), // Cyan
                ),
              ),
            ],
          ),
          content: Text(
            'Datos insertados correctamente\nen la tabla de la base de datos.',
            style: TextStyle(color: Color(0xFF154790)), // Clear text color
            textAlign: TextAlign.center, // Centered text for better layout
          ),
          actions: [
            TextButton(
              child: Text(
                'Continuar', // More action-oriented button text
                style: TextStyle(
                  color: Color(0xFFDC9525), // Cyan
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TrasladarDatosScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _msgConexion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conexión a Base de Datos"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _serverController,
                decoration: InputDecoration(labelText: "Server"),
              ),
              TextField(
                controller: _databaseController,
                decoration: InputDecoration(labelText: "Database"),
              ),
              TextField(
                controller: _userController,
                decoration: InputDecoration(labelText: "User"),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _conectarBaseDeDatos();
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text("Conectar"),
            ),
          ],
        );
      },
    );
  }

  void _seleccionarArchivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );
    if (result != null) {
      setState(() {
        _archivoSeleccionado = result.files.firstOrNull;
      });
      _obtenerHojasExcel(_archivoSeleccionado!);
    }
  }

  void _obtenerHojasExcel(PlatformFile file) async {
    try {
      // ignore: unnecessary_null_comparison
      if (file != null) {
        FormData formData = FormData.fromMap({
          'archivoExcel':
              await MultipartFile.fromFile(file.path!, filename: file.name),
        });
        final response = await _dio.post(
          '${baseUrl}Ctrl_ObtenerHojasExcel',
          data: formData,
        );
        print('Respuesta del servidor: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.data}');
        // Almacenar las hojas en la lista _sheetNames
        setState(() {
          _nombresHojas = List<String>.from(response.data);
        });
      }
    } catch (e) {
      print('Error al enviar el archivo al servidor: $e');
    }
  }

  Future<void> _insertBodega() async {
    try {
      PlatformFile? selectedFile = _archivoSeleccionado;

      if (selectedFile == null) {
        _msgSeleccionarArchivo();
        return;
      }

      FormData formData = FormData.fromMap({
        'ArchivoExcel': await MultipartFile.fromFile(
          selectedFile.path!,
          filename: selectedFile.name,
        ),
        'NombreHojaExcel': _nombreHojaSeleccionada,
        'userName': 'ds'
      });

      final response = await _dio.post(
        '${baseUrl}Ctrl_PaExternalBodega',
        data: formData,
      );

      if (response.statusCode == 200) {
        print(
            'Datos insertados correctamente en la tabla de la base de datos.');

        _msgInsertadoCorrectamente();
      } else {
        print('Error en la solicitud al servidor: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF154790),
                ),
              ),
              content: Text(
                'Hubo un error al insertar los datos en la base de datos',
                style: TextStyle(color: Color(0xFF154790)),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF154790),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error al insertar los datos: $e');
      _msgPosiblesInconvenientes();
    }
  }

  Future<void> _insertClaseProducto() async {
    try {
      PlatformFile? selectedFile = _archivoSeleccionado;
      if (selectedFile == null) {
        _msgSeleccionarArchivo();
        return;
      }

      FormData formData = FormData.fromMap({
        'ArchivoExcel': await MultipartFile.fromFile(
          selectedFile.path!,
          filename: selectedFile.name,
        ),
        'NombreHojaExcel': _nombreHojaSeleccionada,
        'userName': 'ds'
      });

      final response = await _dio.post(
        '${baseUrl}Ctrl_PaExternalClaseProducto',
        data: formData,
      );
      if (response.statusCode == 200) {
        print(
            'Datos insertados correctamente en la tabla de la base de datos.');

        _msgInsertadoCorrectamente();
      } else {
        print('Error en la solicitud al servidor: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF154790),
                ),
              ),
              content: Text(
                'Hubo un error al insertar los datos en la base de datos',
                style: TextStyle(color: Color(0xFF154790)),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF154790),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error al insertar los datos: $e');
      _msgPosiblesInconvenientes();
    }
  }

  Future<void> _insertMarca() async {
    try {
      PlatformFile? selectedFile = _archivoSeleccionado;
      if (selectedFile == null) {
        _msgSeleccionarArchivo();
        return;
      }

      FormData formData = FormData.fromMap({
        'ArchivoExcel': await MultipartFile.fromFile(
          selectedFile.path!,
          filename: selectedFile.name,
        ),
        'NombreHojaExcel': _nombreHojaSeleccionada,
        'userName': 'ds'
      });

      final response = await _dio.post(
        '${baseUrl}Ctrl_PaExternalMarca',
        data: formData,
      );

      if (response.statusCode == 200) {
        print(
            'Datos insertados correctamente en la tabla de la base de datos.');

        _msgInsertadoCorrectamente();
      } else {
        print('Error en la solicitud al servidor: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF154790),
                ),
              ),
              content: Text(
                'Hubo un error al insertar los datos en la base de datos',
                style: TextStyle(color: Color(0xFF154790)),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF154790),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error al insertar los datos: $e');
      _msgPosiblesInconvenientes();
    }
  }

  Future<void> _insertProducto() async {
    try {
      PlatformFile? selectedFile = _archivoSeleccionado;
      if (selectedFile == null) {
        _msgSeleccionarArchivo();
        return;
      }
      FormData formData = FormData.fromMap({
        'ArchivoExcel': await MultipartFile.fromFile(
          selectedFile.path!,
          filename: selectedFile.name,
        ),
        'NombreHojaExcel': _nombreHojaSeleccionada,
        'userName': 'ds'
      });
      final response = await _dio.post(
        '${baseUrl}Ctrl_PaExternalProducto',
        data: formData,
      );
      if (response.statusCode == 200) {
        print(
            'Datos insertados correctamente en la tabla de la base de datos.');

        _msgInsertadoCorrectamente();
      } else {
        print('Error en la solicitud al servidor: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF154790),
                ),
              ),
              content: Text(
                'Hubo un error al insertar los datos en la base de datos',
                style: TextStyle(color: Color(0xFF154790)),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF154790),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error al insertar los datos: $e');
      _msgPosiblesInconvenientes();
    }
  }

  Future<void> _insertTipoPrecio() async {
    try {
      PlatformFile? selectedFile = _archivoSeleccionado;

      if (selectedFile == null) {
        _msgSeleccionarArchivo();
        return;
      }

      FormData formData = FormData.fromMap({
        'ArchivoExcel': await MultipartFile.fromFile(
          selectedFile.path!,
          filename: selectedFile.name,
        ),
        'NombreHojaExcel': _nombreHojaSeleccionada,
        'userName': 'ds'
      });

      final response = await _dio.post(
        '${baseUrl}Ctrl_PaExternalTipoPrecio',
        data: formData,
      );

      if (response.statusCode == 200) {
        print(
            'Datos insertados correctamente en la tabla de la base de datos.');

        _msgInsertadoCorrectamente();
      } else {
        print('Error en la solicitud al servidor: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF154790),
                ),
              ),
              content: Text(
                'Hubo un error al insertar los datos en la base de datos',
                style: TextStyle(color: Color(0xFF154790)),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF154790),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error al insertar los datos: $e');
      _msgPosiblesInconvenientes();
    }
  }

  Future<void> _insertUnidadMedida() async {
    try {
      PlatformFile? selectedFile = _archivoSeleccionado;

      if (selectedFile == null) {
        _msgSeleccionarArchivo();
        return;
      }

      FormData formData = FormData.fromMap({
        'ArchivoExcel': await MultipartFile.fromFile(
          selectedFile.path!,
          filename: selectedFile.name,
        ),
        'NombreHojaExcel': _nombreHojaSeleccionada,
        'userName': 'ds'
      });

      final response = await _dio.post(
        '${baseUrl}Ctrl_PaExternalUnidadMedida',
        data: formData,
      );

      if (response.statusCode == 200) {
        print(
            'Datos insertados correctamente en la tabla de la base de datos.');

        _msgInsertadoCorrectamente();
      } else {
        print('Error en la solicitud al servidor: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF154790),
                ),
              ),
              content: Text(
                'Hubo un error al insertar los datos en la base de datos',
                style: TextStyle(color: Color(0xFF154790)),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF154790),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error al insertar los datos: $e');
      _msgPosiblesInconvenientes();
    }
  }

  Future<void> _conectarBaseDeDatos() async {
    final url = Uri.parse('${baseUrl}Ctrl_Conexion');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'serverName': _serverController.text,
        'databaseName': _databaseController.text,
        'userId': _userController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // La conexión fue exitosa
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    } else {
      // Hubo un error al conectar
      final data = jsonDecode(response.body);
      print('Error: ${data['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${data['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(150.0), // Altura personalizada del AppBar
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0), // Radio para el borde circular
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.cyan, // Fondo color cyan
            elevation: 0,
            flexibleSpace: Padding(
              padding:
                  const EdgeInsets.only(top: 90.0, left: 50.0, right: 50.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 10.0),
                    child: Text(
                      'Traslado de Datos',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    MdiIcons.database, // Icono de base de datos
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    _msgConexion(); // Llama a la función de conexión
                  },
                ),
                IconButton(
                  icon: Icon(
                    MdiIcons.earthPlus,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    mostrarDialogoBaseUrl();
                  },
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20.0, top: 20.0),
                child: Image.asset(
                  'assets/logo.png', // Ruta a tu logo
                  height: 40.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Seleccione la tabla SQL',
                border: OutlineInputBorder(),
              ),
              value: _tablaSeleccionada,
              onChanged: (String? newValue) {
                setState(() {
                  _tablaSeleccionada = newValue;
                });
              },
              items: <String>[
                'Bodega',
                'Clase_Producto',
                'Marca',
                'Producto',
                'Tipo_Precio',
                'Unidad_Medida',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (_tablaSeleccionada == null) {
                  _msgSeleccionarTablaSQL();
                }
              },
              child: AbsorbPointer(
                absorbing: _tablaSeleccionada == null,
                child: ExpansionTile(
                  backgroundColor: Color.fromARGB(255, 230, 244, 245),
                  title: Text(
                    'Seleccionar archivo excel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onExpansionChanged: (expanded) {
                    if (expanded && _tablaSeleccionada != null) {
                      setState(() {
                        _expandir = expanded;
                      });
                    }
                  },
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () {
                          _seleccionarArchivo();
                        },
                        title: Text(_archivoSeleccionado?.name ??
                            'Seleccionar archivo de Excel'),
                        leading: _archivoSeleccionado == null
                            ? Icon(Icons.attach_file)
                            : Icon(
                                MdiIcons.fileExcel,
                                color: Color(0xFFDD952A),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_archivoSeleccionado != null)
                      Text(
                        'Seleccionar una hoja excel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_nombresHojas.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _nombresHojas
                            .map(
                              (sheetName) => Row(
                                children: [
                                  Checkbox(
                                    value: _nombreHojaSeleccionada == sheetName,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          _nombreHojaSeleccionada = sheetName;
                                        } else {
                                          _nombreHojaSeleccionada = null;
                                        }
                                      });
                                    },
                                    fillColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return Color(0xFFDC9525);
                                        }
                                        return Colors.white;
                                      },
                                    ),
                                  ),
                                  Text(sheetName),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    if (_archivoSeleccionado != null &&
                        _nombreHojaSeleccionada != null)
                      TextButton(
                        onPressed: () {
                          _msgConfirmar();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_task_sharp,
                              color: Color(0xFFDC9525),
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              'Insertar datos',
                              style: TextStyle(
                                color: Color(0xFFDC9525),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
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
    );
  }
}
