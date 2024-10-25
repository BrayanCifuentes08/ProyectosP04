import 'dart:convert';
import 'package:elementos_asignados/common/FloatingActionButtonNotifier.dart';
import 'package:elementos_asignados/common/Loading.dart';
import 'package:elementos_asignados/common/Mensajes.dart';
import 'package:elementos_asignados/components/Layout.dart';
import 'package:elementos_asignados/models/PaBscElementosNoAsignadosM.dart';
import 'package:elementos_asignados/models/PaInsertUserElementoAsignadoM.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class Asignador extends StatefulWidget {
  final bool isBackgroundSet;
  final String imagePath;
  final Function(Locale) changeLanguage;
  Locale idiomaDropDown;
  final String pUserName;
  final String baseUrl;
  final bool temaClaro;

  Asignador(
      {required this.baseUrl,
      required this.changeLanguage,
      required this.idiomaDropDown,
      required this.pUserName,
      required this.isBackgroundSet,
      required this.imagePath,
      required this.temaClaro});
  @override
  _AsignadorState createState() => _AsignadorState();
}

class _AsignadorState extends State<Asignador> {
  bool _cargando = false;
  bool _cargandoPost = false;
  List<PaBscElementosNoAsignadosM> _elementosNoAsignados = [];
  List<PaInsertUserElementoAsignadoM> _infoAsignacion = [];
  List<bool> _seleccionados = [];

  @override
  void initState() {
    super.initState();
    _getUserElementosNoAsignados();
  }

  void _mostrarAlerta(
    BuildContext context,
    String titulo,
    String mensaje,
    IconData? icono,
    Color colorIcono,
    int cantidadBotones,
    String textoPrimerBoton,
    VoidCallback? funcionPrimerBoton,
    String? textoSegundoBoton,
    VoidCallback? funcionSegundoBoton,
  ) async {
    await mostrarDialogo(
      context: context,
      titulo: titulo,
      mensaje: mensaje,
      icono: icono,
      colorIcono: colorIcono,
      cantidadBotones: cantidadBotones,
      textoPrimerBoton: textoPrimerBoton,
      funcionPrimerBoton: funcionPrimerBoton,
      textoSegundoBoton: textoSegundoBoton,
      funcionSegundoBoton: funcionSegundoBoton,
    );
  }

  void _mostrarMensajeScaffold(
    BuildContext context,
    String mensaje,
    IconData? icono,
    Color colorIcono,
    Color colorText,
    Color colorFondo,
    Duration duracion,
  ) async {
    await mostrarMensajeScaffold(
      context: context,
      mensaje: mensaje,
      icono: icono,
      colorIcono: colorIcono,
      duracion: duracion,
      colorText: colorText,
      colorFondo: colorFondo,
    );
  }

  Future<void> _getUserElementosNoAsignados() async {
    if (!mounted) return;
    setState(() {
      _cargando = true;
    });
    String url = '${widget.baseUrl}PaBscElementosNoAsignadosCtrl';
    Uri uri = Uri.parse(url).replace();

    try {
      final response =
          await http.get(uri, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscElementosNoAsignadosM> elementosNoAsignados = jsonResponse
            .map((data) => PaBscElementosNoAsignadosM.fromJson(data))
            .toList();
        // Actualizar el estado con los datos obtenidos
        print('Elementos No Asignados: ${response.body}');
        setState(() {
          _elementosNoAsignados = elementosNoAsignados;
          _seleccionados =
              List<bool>.filled(_elementosNoAsignados.length, false);
        });
      } else {
        print('Error: ${response.statusCode}');
        print('${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  Future<void> _postUserAsignarElemento() async {
    if (!mounted) return;
    setState(() {
      _cargandoPost = true;
    });
    String url = '${widget.baseUrl}PaInsertUserElementoAsignadoCtrl';
    bool errorOccurred = false;
    for (int index = 0; index < _seleccionados.length; index++) {
      if (_seleccionados[index]) {
        Map<String, dynamic> requestBody = {
          "UserName": widget.pUserName,
          "Elemento_Asignado": _elementosNoAsignados[index].elementoAsignado,
          "mensaje": "",
          "resultado": false,
        };

        try {
          final response = await http.post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestBody),
          );

          if (response.statusCode == 200) {
            print(
                "Elemento asignado con éxito: ${_elementosNoAsignados[index].descripcion}");
            List<dynamic> jsonResponse = json.decode(response.body);
            List<PaInsertUserElementoAsignadoM> infoAsignacion = jsonResponse
                .map((data) => PaInsertUserElementoAsignadoM.fromJson(data))
                .toList();
            // Actualizar el estado con los datos obtenidos
            print('Elementos No Asignados: ${response.body}');
            setState(() {
              _infoAsignacion = infoAsignacion;
              if (_infoAsignacion[0].resultado) {
                errorOccurred = false;
                _mostrarMensajeScaffold(
                    context,
                    "Elemento ${_elementosNoAsignados[index].descripcion} asignado correctamente",
                    MdiIcons.checkboxMarkedCircle,
                    Color(0xFFF15803D),
                    Color(0xFFF15803D),
                    Color(0xFFFDCFCE7),
                    Duration(seconds: 2));
              }

              if (!_infoAsignacion[0].resultado) {
                errorOccurred = true;
                _mostrarMensajeScaffold(
                    context,
                    _infoAsignacion[0].mensaje,
                    FontAwesomeIcons.circleExclamation,
                    Color.fromARGB(255, 128, 21, 21),
                    Color.fromARGB(255, 128, 21, 21),
                    Color.fromARGB(255, 252, 220, 220),
                    Duration(seconds: 4));

                return;
              }
            });
          } else if (response.statusCode >= 400 && response.statusCode < 500) {
            errorOccurred = true;
            // Código de estado en el rango 400-499 (errores del cliente)
            print('Error del cliente: ${response.statusCode}');
            print('Respuesta del error: ${response.body}');
          } else if (response.statusCode >= 500) {
            errorOccurred = true;
            // Código de estado en el rango 500-599 (errores del servidor)
            print('Error del servidor: ${response.statusCode}');
            print('Respuesta del error: ${response.body}');
          }
        } catch (error) {
          errorOccurred = true;
          print('Error: $error');
        } finally {
          if (mounted) {
            setState(() {
              _cargandoPost = false;
            });
          }
        }
      }
    }
    if (!errorOccurred) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return Layout(
              imagePath: widget.imagePath,
              isBackgroundSet: widget.isBackgroundSet,
              catalogo: null,
              changeLanguage: widget.changeLanguage,
              idiomaDropDown: widget.idiomaDropDown,
              temaClaro: widget.temaClaro,
              baseUrl: 'http://192.168.10.41:9090/api/',
              pUserName: 'AUDITOR01',
              // token: sessionData['token'],
              // pUserName: sessionData['username'],
              // pEmpresa: sessionData['empresa'],
              // pEstacion_Trabajo: sessionData['estacionTrabajo'],
              // baseUrl: sessionData['urlBase'],
              // fechaSesion: sessionData['fecha'],
              // fechaExpiracion: sessionData['fechaExpiracion'],
              // despEmpresa: sessionData['desEmpresa'],
              // despEstacion_Trabajo: sessionData['desEstacionTrabajo'],
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fabNotifier = Provider.of<FloatingActionButtonNotifier>(context);
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        children: [
          if (_cargando)
            LoadingComponent(
              color: Colors.blue,
              changeLanguage: (Locale) {},
            )
          else ...[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No. elementos sin asignar: ${_elementosNoAsignados.length}',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Container(
              height: 400,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: Text(
                      _seleccionados.every((seleccionado) => seleccionado)
                          ? 'Deseleccionar Todos'
                          : 'Seleccionar Todos',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    value: _seleccionados.every((seleccionado) => seleccionado),
                    onChanged: (bool? value) {
                      setState(() {
                        for (int i = 0; i < _seleccionados.length; i++) {
                          _seleccionados[i] = value ?? false;
                        }
                        fabNotifier.setButtonState(
                            _seleccionados.any((seleccionado) => seleccionado)
                                ? 1
                                : 0);
                      });
                    },activeColor: Colors.blueAccent,
                     controlAffinity: ListTileControlAffinity.leading,
                  ),
                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 1, // Dos columnas
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 6,
                      children:
                          List.generate(_elementosNoAsignados.length, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: _seleccionados[index]
                                ? Colors.blue[50]
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _seleccionados[index]
                                  ? Colors.blue
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: CheckboxListTile(
                            title: Text(
                              _elementosNoAsignados[index]
                                  .descripcion, // Mostrar la propiedad descripcion
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            value: _seleccionados[index],
                            activeColor: Colors.blueAccent,
                            onChanged: (bool? value) {
                              setState(() {
                                _seleccionados[index] = value!;
                                if (_seleccionados
                                    .any((seleccionado) => seleccionado)) {
                                  fabNotifier
                                      .setButtonState(1); // Mostrar botón
                                } else {
                                  fabNotifier
                                      .setButtonState(0); // Ocultar botón
                                }
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        );
                      }),
                    ),
                  ),
                  if (_seleccionados.any((seleccionado) => seleccionado))
                    Align(
                      alignment: Alignment.centerLeft, // Alinear a la izquierda
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _seleccionados.fillRange(0, _seleccionados.length,
                                false); // Limpiar selecciones
                            fabNotifier.setButtonState(0); // Ocultar botón
                          });
                        },
                        child: Text(
                          'Limpiar selecciones',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          SizedBox(height: 20),
          _seleccionados.any((seleccionado) => seleccionado)
              ? Column(children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Elementos seleccionados',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Divider(color: Colors.grey[300]),
                        SizedBox(height: 10),
                        ..._seleccionados.asMap().entries.map((entry) {
                          int index = entry.key;
                          bool seleccionado = entry.value;
                          if (seleccionado) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_elementosNoAsignados[index].descripcion}', // Mostrar descripción del elemento seleccionado
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Campo 1: Valor ${index + 1}',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  'Campo 2: Valor ${index + 1}',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  'Campo 3: Valor ${index + 1}',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                SizedBox(height: 15),
                                Divider(color: Colors.grey[300]),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }).toList(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_cargandoPost)
                    LoadingComponent(
                        color: Colors.blue,
                        changeLanguage: widget.changeLanguage),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _mostrarAlerta(
                              context,
                              "Confirmar",
                              "¿Desea Asignar este elemento?",
                              FontAwesomeIcons.circleExclamation,
                              Color(0xFFFEAB308),
                              1,
                              "Asignar", () async {
                            await _postUserAsignarElemento();
                            fabNotifier.setButtonState(0);
                          }, null, null);
                        },
                        child: Text(
                          'Confirmar Asignación',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF194a5a)),
                      ),
                    ),
                  ),
                ])
              : SizedBox.shrink(), // Ocultar el contenedor si no hay selección
        ],
      ),
    );
  }
}
