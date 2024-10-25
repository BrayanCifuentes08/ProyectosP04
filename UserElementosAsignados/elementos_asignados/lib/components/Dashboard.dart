import 'dart:convert';

import 'package:elementos_asignados/common/Loading.dart';
import 'package:elementos_asignados/common/ThemeNotifier.dart';
import 'package:elementos_asignados/components/Asignador.dart';
import 'package:elementos_asignados/components/Desasignador.dart';
import 'package:elementos_asignados/models/PaBscElementosNoAsignadosM.dart';
import 'package:elementos_asignados/models/PaBscUserElementoAsignadoM.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  final bool isBackgroundSet;
  final String imagePath;
  final Function(Locale) changeLanguage;
  final Function onScrollToDown;
  final Function onScrollToTop;
  Locale idiomaDropDown;
  // final bool temaClaro;
  // final String token;
  final String pUserName;
  // final int pEmpresa;
  // final int pEstacion_Trabajo;
  String baseUrl;
  // final DateTime fechaSesion;
  // final DateTime? fechaExpiracion;
  // final String? despEmpresa;
  // final String? despEstacion_Trabajo;

  Dashboard({
    required this.isBackgroundSet,
    required this.imagePath,
    required this.changeLanguage,
    required this.idiomaDropDown,
    required this.onScrollToDown,
    required this.onScrollToTop,
    required this.baseUrl,
    // required this.token,
    required this.pUserName,
    // required this.pEmpresa,
    // required this.pEstacion_Trabajo,
    // required this.fechaSesion,
    // required this.despEmpresa,
    // required this.despEstacion_Trabajo,
    // this.fechaExpiracion,
  });
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _cargando = false;
  bool isAsignarElemento = true;
  bool isDesasignarElemento = true;
  bool mostrarGridElementosUsuario = true;
  List<PaBscUserElementoAsignadoM> _elementosAsignados = [];
  bool isEmptyAsignados = false;
  bool isRequestError = false;

  @override
  void initState() {
    super.initState();
    _getUserElementosAsignados();
  }

  Future<void> _getUserElementosAsignados() async {
    // Verifica que el widget esté montado antes de realizar cualquier acción.
    if (!mounted) return;
    _elementosAsignados = [];
    isEmptyAsignados = false;
    isRequestError = false;
    setState(() {
      _cargando = true; // Establecer isLoading a true al inicio de la carga
    });

    String url = '${widget.baseUrl}PaBscUserElementoAsignadoCtrl';
    Map<String, String?> queryParams = {"pUserName": widget.pUserName};

    Map<String, String> parametrosString = queryParams
        .map((key, value) => MapEntry(key, value ?? ''))
      ..removeWhere((key, value) => value.isEmpty);

    Uri uri = Uri.parse(url).replace(queryParameters: parametrosString);

    try {
      final response =
          await http.get(uri, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscUserElementoAsignadoM> elementosAsignados = jsonResponse
            .map((data) => PaBscUserElementoAsignadoM.fromJson(data))
            .toList();

        // Verifica si el widget sigue montado antes de llamar a setState
        if (mounted) {
          setState(() {
            _elementosAsignados = elementosAsignados;
            isEmptyAsignados = _elementosAsignados.isEmpty;
          });
        }
      } else {
        print('Error: ${response.statusCode}');
        print('${response.body}');
        setState(() {
          isRequestError = true;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isRequestError = true;
      });
    } finally {
      // Verifica si el widget sigue montado antes de llamar a setState
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(0),
      child: SingleChildScrollView(
        // Agregar SingleChildScrollView
        child: Container(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height, // Mínimo tamaño de pantalla
          ),
          decoration: BoxDecoration(
            color: widget.isBackgroundSet
                ? Color.fromARGB(0, 21, 70, 144)
                : (!themeNotifier.temaClaro
                    ? Color(0xFFF111827)
                    : Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: Offset(0, 5),
              ),
            ],
            image: widget.isBackgroundSet
                ? DecorationImage(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isRequestError)
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.redAccent.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Error de conexión',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No se pudo recuperar la información. Por favor, revise su conexión e intente nuevamente.',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Llamar la función para reintentar la solicitud
                              _getUserElementosAsignados();
                            },
                            child: Text(
                              'Reintentar',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Verifica si no hay elementos asignados
                if (isEmptyAsignados)
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.blueAccent.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No hay elementos asignados',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${widget.pUserName} no tiene ningún elemento asignado.',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Llamar la función para reintentar la solicitud
                              _getUserElementosAsignados();
                            },
                            child: Text(
                              'Refrescar',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!isEmptyAsignados && !isRequestError)
                  Wrap(
                    spacing: 1,
                    runSpacing: 1,
                    alignment: WrapAlignment.start,
                    children: [
                      // Tarjeta de Usuario
                      _buildUserCard(widget.pUserName, '10:00 AM', '12:00 PM'),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isAsignarElemento = !isAsignarElemento;
                                isDesasignarElemento = true;
                                mostrarGridElementosUsuario = isAsignarElemento;
                                if (mostrarGridElementosUsuario) {
                                  _getUserElementosAsignados();
                                }
                              });
                            },
                            child: Text(
                              'Asignar elementos',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isAsignarElemento
                                  ? Color(0xFFF194a5a)
                                  : Colors.blue,
                            ),
                          ),
                          SizedBox(height: 10),
                          if (_elementosAsignados.isNotEmpty)
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isDesasignarElemento = !isDesasignarElemento;
                                  isAsignarElemento = true;
                                  mostrarGridElementosUsuario =
                                      isDesasignarElemento;
                                  if (mostrarGridElementosUsuario) {
                                    _getUserElementosAsignados();
                                  }
                                });
                              },
                              child: Text(
                                'Desasignar elementos',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDesasignarElemento
                                    ? Color(0xFFF194a5a)
                                    : Colors.blue,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                Divider(
                  height: 50,
                  thickness: 2,
                  color: Colors.grey,
                ),
                if (mostrarGridElementosUsuario)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'No. elementos asignados: ${_elementosAsignados.length}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600),
                      textAlign: TextAlign.start,
                    ),
                  ),
                if (_cargando)
                  LoadingComponent(
                      color: Colors.blue,
                      changeLanguage: widget.changeLanguage),
                if (mostrarGridElementosUsuario)
                  Flexible(
                    fit: FlexFit.loose,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: _elementosAsignados.length,
                      itemBuilder: (context, index) {
                        final elemento = _elementosAsignados[index];
                        return _buildAssignedItemCard(elemento.descripcion,
                            elemento.fechaHora, Icons.assignment);
                      },
                    ),
                  ),
                if (isAsignarElemento == false)
                  Asignador(
                    baseUrl: widget.baseUrl,
                    changeLanguage: widget.changeLanguage,
                    pUserName: widget.pUserName,
                    idiomaDropDown: widget.idiomaDropDown,
                    isBackgroundSet: widget.isBackgroundSet,
                    imagePath: widget.imagePath,
                    temaClaro: themeNotifier.temaClaro,
                  ),
                if (isDesasignarElemento == false)
                  Desasignador(
                    baseUrl: widget.baseUrl,
                    changeLanguage: widget.changeLanguage,
                    elementosAsignados: _elementosAsignados,
                    pUserName: widget.pUserName,
                    idiomaDropDown: widget.idiomaDropDown,
                    isBackgroundSet: widget.isBackgroundSet,
                    imagePath: widget.imagePath,
                    temaClaro: themeNotifier.temaClaro,
                  )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  // Tarjeta para mostrar la información del usuario
  Widget _buildUserCard(String name, String sessionStart, String sessionEnd) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('Sesión: $sessionStart'),
            Text('Expira: $sessionEnd'),
          ],
        ),
      ),
    );
  }

  // Tarjeta para los elementos asignados al usuario
  Widget _buildAssignedItemCard(
      String itemName, DateTime fechaHora, IconData icon) {
    // Formato de fecha
    final String formattedDate =
        DateFormat('dd/MM/yyyy, HH:mm').format(fechaHora);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            SizedBox(height: 10),
            Text(
              itemName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
