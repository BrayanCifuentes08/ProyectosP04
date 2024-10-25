import 'dart:convert';
import 'package:elementos_asignados/common/FloatingActionButtonNotifier.dart';
import 'package:elementos_asignados/common/Loading.dart';
import 'package:elementos_asignados/common/Mensajes.dart';
import 'package:elementos_asignados/components/Layout.dart';

import 'package:elementos_asignados/models/PaBscUserElementoAsignadoM.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class Desasignador extends StatefulWidget {
  final bool isBackgroundSet;
  final String imagePath;
  final Function(Locale) changeLanguage;
  final bool temaClaro;
  Locale idiomaDropDown;
  final String pUserName;
  final String baseUrl;

  final List<PaBscUserElementoAsignadoM> elementosAsignados;
  Desasignador(
      {required this.baseUrl,
      required this.changeLanguage,
      required this.idiomaDropDown,
      required this.elementosAsignados,
      required this.pUserName,
      required this.isBackgroundSet,
      required this.imagePath,
      required this.temaClaro});
  @override
  _DesasignadorState createState() => _DesasignadorState();
}

class _DesasignadorState extends State<Desasignador> {
  bool _cargando = false;
  List<bool> _seleccionados = [];
  bool _cargandoPost = false;

  @override
  void initState() {
    super.initState();
    _seleccionados = List<bool>.filled(widget.elementosAsignados.length, false);
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
    Duration duracion,
  ) async {
    await mostrarMensajeScaffold(
      context: context,
      mensaje: mensaje,
      icono: icono,
      colorIcono: colorIcono,
      duracion: duracion,
    );
  }

  Future<void> _deleteUserAsignarElemento() async {
    if (!mounted) return;
    setState(() {
      _cargandoPost = true;
    });
    String url = '${widget.baseUrl}PaDeleteUserElementoAsignadoCtrl';

    for (int index = 0; index < _seleccionados.length; index++) {
      if (_seleccionados[index]) {
        Map<String, dynamic> requestBody = {
          "UserName": widget.pUserName,
          "Elemento_Asignado":
              widget.elementosAsignados[index].elementoAsignado,
        };

        try {
          final response = await http.delete(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestBody),
          );

          print(
              "se está ejecutando el delete para el elemento ${widget.elementosAsignados[index].descripcion}");

          if (response.statusCode == 200) {
            print(
                "Elemento desasignado con éxito: ${widget.elementosAsignados[index].descripcion}");
            _mostrarMensajeScaffold(
                context,
                "Elemento/s desasignados correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
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
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
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
        } finally {
          if (mounted) {
            setState(() {
              _cargandoPost = false;
            });
          }
        }
      }
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
            ) // Mostrar un indicador de carga mientras se cargan los elementos
          else ...[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No. elementos asignados: ${widget.elementosAsignados.length}',
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
                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 1, // Dos columnas
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 6,
                      children: List.generate(widget.elementosAsignados.length,
                          (index) {
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
                              widget.elementosAsignados[index]
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
                  if (_seleccionados.any((seleccionado) =>
                      seleccionado)) // Solo mostrar el botón si hay selecciones
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0), // Espaciado superior
                      child: Align(
                        alignment:
                            Alignment.centerLeft, // Alinear a la izquierda
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _seleccionados.fillRange(0, _seleccionados.length,
                                  false); // Limpiar selecciones
                              fabNotifier.setButtonState(0); // Ocultar botón
                            });
                          },
                          child: Text('Limpiar selecciones'),
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
                                  '${widget.elementosAsignados[index].descripcion}', // Mostrar descripción del elemento seleccionado
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
                              "¿Desea Desasignar este elemento?",
                              FontAwesomeIcons.circleExclamation,
                              Color(0xFFFEAB308),
                              1,
                              "Desasignar", () async {
                            await _deleteUserAsignarElemento();
                            fabNotifier.setButtonState(0);
                          }, null, null);
                        },
                        child: Text(
                          'Confirmar Desasignación',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF194a5a)),
                      ),
                    ),
                  ),
                ])
              : SizedBox.shrink(),
          // Ocultar el contenedor si no hay selección
        ],
      ),
    );
  }
}
