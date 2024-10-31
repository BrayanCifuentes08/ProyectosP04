import 'dart:convert';
import 'package:elementos_asignados/common/FloatingActionButtonNotifier.dart';
import 'package:elementos_asignados/common/Loading.dart';
import 'package:elementos_asignados/common/Mensajes.dart';
import 'package:elementos_asignados/common/ThemeNotifier.dart';
import 'package:elementos_asignados/components/Layout.dart';
import 'package:elementos_asignados/models/PaBscElementosNoAsignadosM.dart';
import 'package:elementos_asignados/models/PaInsertUserElementoAsignadoM.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Asignador extends StatefulWidget {
  final bool isBackgroundSet;
  final String imagePath;
  final Function(Locale) changeLanguage;
  Locale idiomaDropDown;
  final String pUserName;
  final String baseUrl;
  final bool temaClaro;
  final int pEmpresa;
  final int pEstacion_Trabajo;
  final String token;
  final DateTime fechaSesion;
  final DateTime? fechaExpiracion;
  final String? despEmpresa;
  final String? despEstacion_Trabajo;

  Asignador(
      {required this.baseUrl,
      required this.changeLanguage,
      required this.idiomaDropDown,
      required this.pUserName,
      required this.isBackgroundSet,
      required this.imagePath,
      required this.temaClaro,
      required this.pEmpresa,
      required this.pEstacion_Trabajo,
      required this.token,
      required this.fechaSesion,
      this.fechaExpiracion,
      required this.despEmpresa,
      required this.despEstacion_Trabajo});
  @override
  _AsignadorState createState() => _AsignadorState();
}

class _AsignadorState extends State<Asignador> {
  bool _cargando = false;
  bool _cargandoPost = false;
  TextEditingController searchController = TextEditingController();
  List<PaBscElementosNoAsignadosM> _elementosNoAsignados = [];
  List<PaInsertUserElementoAsignadoM> _infoAsignacion = [];
  List<PaBscElementosNoAsignadosM> elementosFiltrados = [];
  Map<String, bool> _seleccionados = {};

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
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

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
          _seleccionados = {
            for (var elemento in _elementosNoAsignados)
              elemento.descripcion: false
          };
          elementosFiltrados = List.from(_elementosNoAsignados);
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
    for (var entry in _seleccionados.entries) {
      if (entry.value) {
        PaBscElementosNoAsignadosM? elemento;

        // Encontrar el elemento en _elementosNoAsignados basado en la clave única
        for (var el in _elementosNoAsignados) {
          if (el.descripcion == entry.key) {
            elemento = el;
            break; // Salir del bucle una vez que se encuentra el elemento
          }
        }

        if (elemento != null) {
          Map<String, dynamic> requestBody = {
            "UserName": widget.pUserName,
            "Elemento_Asignado": elemento.elementoAsignado,
            "mensaje": "",
            "resultado": false,
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

            if (response.statusCode == 200) {
              print("Elemento asignado con éxito: ${elemento.descripcion}");
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
                      "Elemento ${elemento!.descripcion} asignado correctamente",
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
            } else if (response.statusCode >= 400 &&
                response.statusCode < 500) {
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
    }
    if (!errorOccurred) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return Layout(
              imagePath: widget.imagePath,
              isBackgroundSet: widget.isBackgroundSet,
              changeLanguage: widget.changeLanguage,
              idiomaDropDown: widget.idiomaDropDown,
              temaClaro: widget.temaClaro,
              token: widget.token,
              pUserName: widget.pUserName,
              pEmpresa: widget.pEmpresa,
              pEstacion_Trabajo: widget.pEstacion_Trabajo,
              baseUrl: widget.baseUrl,
              fechaSesion: widget.fechaSesion,
              fechaExpiracion: widget.fechaExpiracion,
              despEmpresa: widget.despEmpresa,
              despEstacion_Trabajo: widget.despEstacion_Trabajo,
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

  void _filtrarElementos(String query) {
    setState(() {
      // Si el input está vacío, muestra todos los elementos
      if (query.isEmpty) {
        elementosFiltrados = List.from(_elementosNoAsignados);
      } else {
        // Aplica el filtro
        elementosFiltrados = _elementosNoAsignados
            .where((elemento) => elemento.descripcion
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final fabNotifier = Provider.of<FloatingActionButtonNotifier>(context);
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        children: [
          if (_cargando)
            LoadingComponent(
              color: Colors.blue,
              changeLanguage: widget.changeLanguage,
            )
          else ...[
            //INPUT DE BÚSQUEDA
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1),
              child: TextField(
                controller: searchController,
                onChanged: _filtrarElementos,
                style: TextStyle(
                  color: !themeNotifier.temaClaro
                      ? Colors.white
                      : Colors.blue[900],
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    hintText: 'Buscar elemento...',
                    hintStyle: TextStyle(
                      color: !themeNotifier.temaClaro
                          ? Color.fromARGB(255, 92, 122, 163)
                          : Color(0XFFF1F2937),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.blue[400],
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.blue[300]),
                            onPressed: () {
                              searchController.clear();
                              _filtrarElementos('');
                            },
                          )
                        : null,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                          color: !themeNotifier.temaClaro
                              ? Colors.grey[600]!
                              : Colors.grey[300]!,
                          width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          BorderSide(color: Colors.blue[400]!, width: 1.5),
                    ),
                    filled: true,
                    fillColor: !themeNotifier.temaClaro
                        ? Color.fromARGB(255, 24, 31, 43)
                        : Colors.transparent),
                cursorColor: Colors.blue[900],
              ),
            ),
            //CHIP DE CONTADOR DE ELEMENTOS SIN ASIGNAR
            Padding(
              padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(
                    'No. elementos sin asignar: ${_elementosNoAsignados.length}',
                    style: TextStyle(
                      color: !themeNotifier.temaClaro
                          ? Colors.white60
                          : Color(0XFFF1F2937),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: !themeNotifier.temaClaro
                      ? Colors.grey.shade800
                      : Color(0xFFFE5E7EB),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                          color: !themeNotifier.temaClaro
                              ? Colors.grey.shade800
                              : Color(0xFFFE5E7EB))),
                  avatar: Icon(
                    Icons.info,
                    color: !themeNotifier.temaClaro
                        ? Colors.white60
                        : Color(0XFFF1F2937),
                    size: 18,
                  ),
                ),
              ),
            ),
            //CONTAINER CON GRIDVIEW PARA SELECCIONAR ELEMENTOS
            Container(
              height: 400,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: !themeNotifier.temaClaro
                    ? Color.fromARGB(255, 36, 46, 63)
                    : Colors.white,
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
                      _seleccionados.values
                              .every((seleccionado) => seleccionado)
                          ? 'Deseleccionar Todos'
                          : 'Seleccionar Todos',
                      style: TextStyle(
                          fontSize: 14,
                          color: !themeNotifier.temaClaro
                              ? Colors.white
                              : Colors.grey.shade600),
                    ),
                    value: _seleccionados.values
                        .every((seleccionado) => seleccionado),
                    onChanged: (bool? value) {
                      setState(() {
                        for (var key in _seleccionados.keys) {
                          _seleccionados[key] = value ?? false;
                        }
                        fabNotifier.setButtonState(_seleccionados.values
                                .any((seleccionado) => seleccionado)
                            ? 1
                            : 0);
                      });
                    },
                    activeColor: Colors.blueAccent,
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
                          List.generate(elementosFiltrados.length, (index) {
                        final elemento = elementosFiltrados[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: _seleccionados[elemento.descripcion] == true
                                ? !themeNotifier.temaClaro
                                    ? const Color.fromARGB(255, 70, 106, 146)
                                    : Colors.blue[50]
                                : !themeNotifier.temaClaro
                                    ? Color.fromARGB(255, 47, 59, 82)
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  _seleccionados[elemento.descripcion] == true
                                      ? Colors.blue
                                      : !themeNotifier.temaClaro
                                          ? Color.fromARGB(255, 24, 31, 43)
                                          : Colors.grey[300]!,
                            ),
                          ),
                          child: CheckboxListTile(
                            title: Text(
                              elemento.descripcion,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: !themeNotifier.temaClaro
                                      ? Colors.white
                                      : Colors.black87,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            value:
                                _seleccionados[elemento.descripcion] ?? false,
                            activeColor: Colors.blueAccent,
                            onChanged: (bool? value) {
                              setState(() {
                                _seleccionados[elemento.descripcion] = value!;
                                if (_seleccionados.values
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
                  //TEXT BUTTON PARA LIMPIAR SELENCCIONES
                  if (_seleccionados.values.any((seleccionado) => seleccionado))
                    Align(
                      alignment: Alignment.centerLeft, // Alinear a la izquierda
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _seleccionados.updateAll((key, value) => false);
                            fabNotifier.setButtonState(0); // Ocultar botón
                          });
                        },
                        child: Text(
                          'Limpiar selecciones',
                          style: TextStyle(
                              color: !themeNotifier.temaClaro
                                  ? Colors.white70
                                  : Colors.blueGrey),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          SizedBox(height: 20),
          //CONTAINER DE SELECCIONADOS
          _seleccionados.values.any((seleccionado) => seleccionado)
              ? Column(children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: !themeNotifier.temaClaro
                          ? Color.fromARGB(255, 36, 46, 63)
                          : Colors.white,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //TEXTO ELEMENTOS SELECCIONADOS
                            Text(
                              'Elementos seleccionados',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: !themeNotifier.temaClaro
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            //CHIP DE CONTADOR DE SELECCIONADOS
                            Chip(
                              label: Text(
                                '${_seleccionados.values.where((seleccionado) => seleccionado).length} seleccionados',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Color(0xFFF475569),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      color: !themeNotifier.temaClaro
                                          ? Colors.grey.shade800
                                          : Color.fromARGB(
                                              255, 207, 207, 207))),
                              avatar: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                            color: !themeNotifier.temaClaro
                                ? Colors.grey[700]
                                : Colors.grey[300]),
                        SizedBox(height: 10),
                        //LISTA DE SELECCIONADOS CON INFORMACIÓN
                        ..._seleccionados.entries.map((entry) {
                          String descripcion = entry.key;
                          bool seleccionado = entry.value;
                          if (seleccionado) {
                            int index = _elementosNoAsignados.indexWhere(
                                (elemento) =>
                                    elemento.descripcion == descripcion);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_elementosNoAsignados[index].descripcion}', // Mostrar descripción del elemento seleccionado
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: !themeNotifier.temaClaro
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Elemento no. ${_elementosNoAsignados[index].elementoAsignado}',
                                  style: TextStyle(
                                      color: !themeNotifier.temaClaro
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                SizedBox(height: 15),
                                Divider(
                                    color: !themeNotifier.temaClaro
                                        ? Colors.grey[700]
                                        : Colors.grey[300]),
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
                  //COMPONENTE DE CARGA
                  if (_cargandoPost)
                    LoadingComponent(
                        color: Colors.blue,
                        changeLanguage: widget.changeLanguage),
                  //BOTON CONFIRMAR ASIGNACION
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
