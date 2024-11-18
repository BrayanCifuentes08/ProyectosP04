import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mantenimiento_catalogos/common/CatalogoProvider.dart';
import 'package:mantenimiento_catalogos/common/Loading.dart';
import 'package:mantenimiento_catalogos/common/Mensajes.dart';
import 'package:mantenimiento_catalogos/common/ThemeNotifier.dart';
import 'package:mantenimiento_catalogos/components/Mantenimiento.dart';
import 'package:mantenimiento_catalogos/generated/l10n.dart';
import 'package:mantenimiento_catalogos/models/ModeloInputs.dart';
import 'package:mantenimiento_catalogos/models/PaCrudCanalDistribucionM.dart';
import 'package:mantenimiento_catalogos/models/PaCrudElementoAsignadoM.dart';
import 'package:mantenimiento_catalogos/models/PaCrudTipoCanalDistribucionM.dart';
import 'package:mantenimiento_catalogos/models/PaCrudUserM.dart';
import 'package:mantenimiento_catalogos/services/Shared.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  final String? catalogo;
  final TextEditingController searchController;
  final FocusNode focusSearch;
  final String _opcionSeleccionada;
  final Function(String?) onOpcionChanged;
  final bool isBackgroundSet;
  final String imagePath;
  final Function(Locale) changeLanguage;
  final Function onScrollToDown;
  final Function onScrollToTop;
  Locale idiomaDropDown;
  final bool temaClaro;
  final String token;
  final String pUserName;
  final int pEmpresa;
  final int pEstacion_Trabajo;
  final int pApplication;
  String baseUrl;
  final DateTime fechaSesion;
  final DateTime? fechaExpiracion;
  final String? despEmpresa;
  final String? despEstacion_Trabajo;

  Dashboard({
    required this.catalogo,
    required this.searchController,
    required this.focusSearch,
    required String opcionSeleccionado,
    required this.onOpcionChanged,
    required this.isBackgroundSet,
    required this.imagePath,
    required this.changeLanguage,
    required this.idiomaDropDown,
    required this.temaClaro,
    required this.baseUrl,
    required this.onScrollToDown,
    required this.onScrollToTop,
    required this.token,
    required this.pUserName,
    required this.pEmpresa,
    required this.pEstacion_Trabajo,
    required this.fechaSesion,
    required this.despEmpresa,
    required this.despEstacion_Trabajo,
    this.fechaExpiracion,
    required this.pApplication,
  }) : _opcionSeleccionada = opcionSeleccionado;
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<String> descripciones = [];
  List<Widget> dynamicInputs = [];
  bool _registroSeleccionado = false;
  ModelWithFields? registroSeleccionado;
  List<ModelWithFields> registros = [];
  String? _opcionSeleccionada;
  Map<String, TextEditingController> controllers = {};
  Map<String, FocusNode> focusNodes = {};
  List<PaCrudTipoCanalDistribucionM> _tipoCanalDistribucion = [];
  List<PaCrudCanalDistribucionM> _canalDistribucion = [];
  List<PaCrudElementoAsignadoM> _elementoAsignado = [];
  List<PaCrudUserM> _user = [];
  bool _cargando = false;
  late AccionService accionService;
  List<Map<String, dynamic>> datosDinamicos = [];
  Map<String, dynamic> datos = {};
  List<PopupMenuEntry<int>> dropdownItems = [];
  int? valorSeleccionadoDropdown;
  int? _indiceSeleccionado;
  ValueNotifier<bool> valorSwitchNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> valorCheckboxNotifier = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    print(widget.baseUrl);
    _opcionSeleccionada = widget._opcionSeleccionada;
    generarRegistros(widget.catalogo ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accionService = Provider.of<AccionService>(context, listen: false);
      accionService.setAccion(
          "${S.of(context).dashboardVisualizandoCatalogo} ${widget.catalogo}",
          MdiIcons.checkAll);
    });
  }

  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    focusNodes.forEach((_, node) => node.dispose());
    widget.focusSearch.dispose();
    super.dispose();
  }

  //Para buscar al ingresar algo en el input de busqueda
  // void _onSearchTextChanged() {
  //   // Llama a la función cada vez que el texto cambia
  //   descripciones.clear();
  //   generarRegistros(widget.catalogo ?? '');
  // }

  //Método para mostrar un Mensaje al Usuario
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

  //Método para mostrar un Mensaje al Usuario de retroalimentación
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

  // Método para obtener descripciones basadas en el catalogo
  List<String> obtenerDescripciones() {
    // Llama a la función generarRegistros con el catálogo actual
    generarRegistros(widget.catalogo ?? '');
    print("DESCRIPCIONES: ${descripciones.length}");
    // Regresa la lista de descripciones generadas
    return descripciones;
  }

  //Función para habilitar inputs
  Future<void> habilitarInputs(int accion) async {
    if (registros.isNotEmpty) {
      if (accion == 2) {
        registroSeleccionado = null;
      }
      dynamicInputs.clear();

      Map<String, dynamic> campos = registros[0].getFields();
      accionService.setAccion(
          S.of(context).dashboardAgregandoRegistro, MdiIcons.checkAll);
      // Limpiar la lista de inputs antes de generar nuevos

      // Iterar sobre los campos del modelo y generar inputs sin valores iniciales
      campos.forEach((nombreCampo, valor) {
        dynamicInputs.add(
          FutureBuilder<Widget>(
            future: generarInputCampo(nombreCampo, valor, registros[0]),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Muestra un indicador mientras se resuelve el Future
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return snapshot
                    .data!; // Muestra el widget una vez que el Future se ha resuelto
              }
            },
          ),
        );
      });

      widget.onScrollToDown();
      // Llamar a setState para actualizar la interfaz
      setState(() {});
    }
  }

  //Método para generar las descripciones basadas en el catálogo
  void generarRegistros(String catalogo) async {
    descripciones.clear();
    datosDinamicos.clear();
    _indiceSeleccionado = null;
    datos.clear();
    dynamicInputs.clear();
    dropdownItems = [];
    valorSeleccionadoDropdown = null;
    _opcionSeleccionada = null;
    _registroSeleccionado = false;
    registros.clear();

    controllers.forEach((key, controller) {
      controller.clear();
    });
    switch (catalogo) {
      case 'Tipo Canal Distribucion':
        await _getTipoCanalDistribucion(1);
        if (_tipoCanalDistribucion.isNotEmpty) {
          registros.addAll(_tipoCanalDistribucion);
        }
        break;
      case 'Canal Distribucion':
        await _getCanalDistribucion(1);
        if (_canalDistribucion.isNotEmpty) {
          registros.addAll(_canalDistribucion);
        }
        break;
      case 'Elemento Asignado':
        await _getElementoAsignado(1);
        if (_elementoAsignado.isNotEmpty) {
          registros.addAll(_elementoAsignado);
        }
        break;
      case 'User':
        await _getUser(1);
        if (_user.isNotEmpty) {
          registros.addAll(_user);
        }
        break;
      default:
        descripciones.add('Catálogo no definido');
        setState(() {});
        return;
    }
    if (registros.isNotEmpty) {
      for (var modelo in registros) {
        Map<String, String> datos = {}; // Reiniciar el mapa en cada iteración
        String? descripcion;

        // Obtener descripción y otros datos según el catálogo
        switch (catalogo) {
          case 'Tipo Canal Distribucion':
            descripcion = (modelo as PaCrudTipoCanalDistribucionM).descripcion;
            if (descripcion != null) {
              descripciones.add(descripcion);
              datos['fechaHora'] =
                  DateFormat('dd/MM/yyyy, HH:mm').format(modelo.fechaHora!);
              datos['userName'] = modelo.userName ?? '';
              datosDinamicos.add(datos); // Agregar el nuevo mapa a la lista
            }
            break;
          case 'Canal Distribucion':
            descripcion = (modelo as PaCrudCanalDistribucionM).descripcion;
            if (descripcion != null) {
              descripciones.add(descripcion);
              datos['fechaHora'] =
                  DateFormat('dd/MM/yyyy, HH:mm').format(modelo.fechaHora!);
              datos['userName'] = modelo.userName ?? '';
              datosDinamicos.add(datos); // Agregar el nuevo mapa a la lista
            }
            break;
          case 'Elemento Asignado':
            descripcion = (modelo as PaCrudElementoAsignadoM).descripcion;
            if (descripcion != null) {
              descripciones.add(descripcion);
              datos['fechaHora'] =
                  DateFormat('dd/MM/yyyy, HH:mm').format(modelo.fechaHora!);
              datos['userName'] = modelo.userName ?? '';
              datosDinamicos.add(datos); // Agregar el nuevo mapa a la lista
            }
            break;
          case 'User':
            descripcion = (modelo as PaCrudUserM).name;
            if (descripcion != null) {
              descripciones.add(descripcion);
              datos['fechaHora'] =
                  DateFormat('dd/MM/yyyy, HH:mm').format(modelo.fechaHora!);
              datos['userName'] = modelo.userName ?? '';
              datosDinamicos.add(datos); // Agregar el nuevo mapa a la lista
            }
            break;
        }
        // Solo agrega si la descripción no es nula
      }
    } else {
      descripciones.add('No se encontraron registros');
    }

    setState(() {});
  }

  //Widget que genera los inputs que requiere el catalogo por los campos definidos en los models
  Future<Widget> generarInputCampo(
      String label, dynamic valor, ModelWithFields modelo) async {
    bool esCampoBloqueado = modelo.getCamposBloqueadosInsert()[label] ?? false;
    String tipoCampo = modelo.getTiposDeCampo()[label] ?? 'text';
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final textStyle = TextStyle(
      color: !themeNotifier.temaClaro ? Colors.white70 : Colors.grey[800],
      fontWeight: FontWeight.w500,
    );
    final inputDecoration = InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
          color: !themeNotifier.temaClaro ? Colors.white70 : Colors.blueGrey),
      filled: true,
      fillColor: !themeNotifier.temaClaro
          ? Color.fromARGB(255, 43, 56, 75)
          : Colors.grey[100],
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none, // Sin borde visible
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
            color: !themeNotifier.temaClaro
                ? Color.fromARGB(255, 55, 70, 94)
                : Colors.grey[300]!,
            width: 1),
      ),
      suffixIcon: esCampoBloqueado
          ? Icon(Icons.lock, color: Colors.grey) // Ícono de candado bloqueado
          : null, // No mostrar nada si el campo no está bloqueado
    );

    if (tipoCampo == "bool") {
      if (!controllers.containsKey(label)) {
        controllers[label] = TextEditingController(
            text: '0'); // Inicializa el controlador en '0'
      }

      // Determina el valor inicial basándote en si el campo está bloqueado
      valorCheckboxNotifier.value =
          esCampoBloqueado ? true : (controllers[label]?.text == '1');

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: textStyle),
            ValueListenableBuilder<bool>(
              valueListenable:
                  valorCheckboxNotifier, // Escucha los cambios en el ValueNotifier
              builder: (context, valorSwitch, child) {
                return Switch(
                  value: valorSwitch, // Estado visual del Switch
                  onChanged: esCampoBloqueado
                      ? null // No se puede cambiar si está bloqueado
                      : (bool nuevoValor) {
                          setState(() {
                            // Actualizar el valor con 1 si es activo, 0 si no
                            controllers[label]?.text = nuevoValor
                                ? '1'
                                : '0'; // Refleja en el controlador
                            valorCheckboxNotifier.value =
                                nuevoValor; // Actualiza el ValueNotifier
                            valor = nuevoValor
                                ? 1
                                : 0; // Actualiza la variable valor
                          });
                        },
                  activeColor:
                      Colors.blueAccent, // Color del switch cuando está activo
                );
              },
            ),
          ],
        ),
      );
    }

    if (tipoCampo == "switch") {
      if (!controllers.containsKey(label)) {
        controllers[label] = TextEditingController(
            text: '0'); // Inicializa el controlador en '0'
      }

      // Determina el valor inicial basándote en si el campo está bloqueado
      valorSwitchNotifier.value =
          esCampoBloqueado ? true : (controllers[label]?.text == '1');

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: textStyle),
            ValueListenableBuilder<bool>(
              valueListenable:
                  valorSwitchNotifier, // Escucha los cambios en el ValueNotifier
              builder: (context, valorSwitch, child) {
                return Switch(
                  value: valorSwitch, // Estado visual del Switch
                  onChanged: esCampoBloqueado
                      ? null // No se puede cambiar si está bloqueado
                      : (bool nuevoValor) {
                          setState(() {
                            // Actualizar el valor con 1 si es activo, 0 si no
                            controllers[label]?.text = nuevoValor
                                ? '1'
                                : '0'; // Refleja en el controlador
                            valorSwitchNotifier.value =
                                nuevoValor; // Actualiza el ValueNotifier
                            valor = nuevoValor
                                ? 1
                                : 0; // Actualiza la variable valor
                          });
                        },
                  activeColor:
                      Colors.blueAccent, // Color del switch cuando está activo
                );
              },
            ),
          ],
        ),
      );
    }

    // Si el valor es DateTime
    if (tipoCampo == "date") {
      if (!controllers.containsKey(label)) {
        controllers[label] = TextEditingController(); // Controlador vacío
        focusNodes[label] = FocusNode();
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          readOnly: true, // Evita la entrada de texto manual
          enabled: !esCampoBloqueado,
          controller: controllers[label], // Asignar el controlador
          focusNode: focusNodes[label],
          onTap: () async {
            DateTime? nuevaFecha = await showDatePicker(
              context: context,
              initialDate: valor, // Aquí puedes definir una fecha inicial
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (nuevaFecha != null) {
              setState(() {
                // Actualiza el controlador con la fecha seleccionada
                controllers[label]?.text =
                    nuevaFecha.toIso8601String().split('T')[0];
              });
            }
          },
          decoration: inputDecoration,
        ),
      );
    }

    if (tipoCampo == "dropdown") {
      if (!controllers.containsKey(label)) {
        controllers[label] = TextEditingController(); // Controlador vacío
        focusNodes[label] = FocusNode();
      }

      // Lógica para generar los items del PopupMenu según el catálogo

      if (widget.catalogo == 'Canal Distribucion') {
        await _getTipoCanalDistribucion(1);
        dropdownItems = _tipoCanalDistribucion.map((item) {
          return PopupMenuItem<int>(
            value: item.tipoCanalDistribucion,
            child: Text(item.descripcion!),
          );
        }).toList();
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controllers[label], // Asignar el controlador
          readOnly: true, // Evita la entrada de texto manual
          enabled: !esCampoBloqueado,
          onTap: () async {
            final nuevoValor = await showMenu<int>(
              context: context,
              position: RelativeRect.fromLTRB(100, 100, 0, 0),
              items: dropdownItems,
            );

            if (nuevoValor != null) {
              print("Valor seleccionado: $nuevoValor");

              // Encuentra la descripción del item seleccionado
              final selectedItem = _tipoCanalDistribucion.firstWhere(
                (item) => item.tipoCanalDistribucion == nuevoValor,
              );

              setState(() {
                controllers[label]?.text = selectedItem.descripcion!;
                valorSeleccionadoDropdown = nuevoValor;
              });
            }
          },
          decoration: inputDecoration.copyWith(
            suffixIcon: esCampoBloqueado
                ? Icon(Icons.lock, color: Colors.grey)
                : IconButton(
                    icon: Icon(Icons.arrow_drop_down,
                        color: !themeNotifier.temaClaro
                            ? Colors.blueGrey
                            : Colors.black), // Icono de menú
                    onPressed: () async {
                      // Mostrar el menú emergente
                      final nuevoValor = await showMenu<int>(
                        context: context,
                        position: RelativeRect.fromLTRB(100, 100, 0,
                            0), // Ajusta la posición según sea necesario
                        items:
                            dropdownItems, // Aquí usa la lista de PopupMenuItem
                      );

                      if (nuevoValor != null) {
                        print(
                            "Valor seleccionado: $nuevoValor"); // Imprimir el valor seleccionado

                        // Encuentra la descripción del item seleccionado
                        final selectedItem = _tipoCanalDistribucion.firstWhere(
                          (item) => item.tipoCanalDistribucion == nuevoValor,
                        );

                        setState(() {
                          controllers[label]?.text = selectedItem
                              .descripcion!; // Mostrar la descripción
                          valorSeleccionadoDropdown =
                              nuevoValor; // Guardar el valor entero
                        });
                      }
                    },
                  ),
          ),
          style: textStyle, // Estilo del texto
        ),
      );
    }

    TextInputType tipoTeclado;
    if (tipoCampo == "int") {
      tipoTeclado = TextInputType.number;
    } else if (tipoCampo == "double") {
      tipoTeclado = TextInputType.numberWithOptions(decimal: true);
    } else if (tipoCampo == "email") {
      tipoTeclado = TextInputType.emailAddress;
    } else {
      tipoTeclado = TextInputType.text;
    }

    if (!controllers.containsKey(label)) {
      controllers[label] = TextEditingController(); // Controlador vacío
      focusNodes[label] = FocusNode();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: !esCampoBloqueado,
        keyboardType: tipoTeclado,
        controller: controllers[label], // Asignar el controlador
        focusNode: focusNodes[label],
        decoration: inputDecoration,
        style: textStyle,
      ),
    );
  }

  //Llena los inputs con los datos del registro seleccionado en la lista
  Future<void> llenarInputs(ModelWithFields registro) async {
    dynamicInputs.clear(); // Limpia los inputs previos

    // Obtén los campos del registro
    Map<String, dynamic> campos = registro.getFields();

    // Llena los inputs dinámicamente con los valores de los campos
    campos.forEach((nombreCampo, valor) {
      dynamicInputs.add(
        FutureBuilder<Widget>(
          future: generarInputCampoConValor(nombreCampo, valor, registro),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Muestra un indicador mientras se resuelve el Future
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot
                  .data!; // Muestra el widget una vez que el Future se ha resuelto
            }
          },
        ),
      );
    });

    setState(() {});
  }

  //Widget que genera los inpus que requiere el catalogo por los campos definidos en los models con datos del registro seleccionado
  Future<Widget> generarInputCampoConValor(
      String label, dynamic valorInicial, ModelWithFields modelo) async {
    bool esCampoBloqueado = modelo.getCamposBloqueadosUpdate()[label] ?? false;

    String tipoCampo = modelo.getTiposDeCampo()[label] ?? 'text';
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final textStyle = TextStyle(
      color: !themeNotifier.temaClaro ? Colors.white70 : Colors.grey[800],
      fontWeight: FontWeight.w500,
    );
    final inputDecoration = InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
          color: !themeNotifier.temaClaro ? Colors.white70 : Colors.blueGrey),
      filled: true,
      fillColor: !themeNotifier.temaClaro
          ? Color.fromARGB(255, 43, 56, 75)
          : Colors.grey[100],
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none, // Sin borde visible
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
            color: !themeNotifier.temaClaro
                ? Color.fromARGB(255, 55, 70, 94)
                : Colors.grey[300]!,
            width: 1),
      ),
      suffixIcon: esCampoBloqueado
          ? Icon(Icons.lock, color: Colors.grey) // Ícono de candado bloqueado
          : null, // No mostrar nada si el campo no está bloqueado
    );
    setState(() {});

    if (tipoCampo == "bool") {
      // Inicializa el ValueNotifier basado en valorInicial
      valorSwitchNotifier.value = valorInicial == true;
      if (!controllers.containsKey(label)) {
        controllers[label] = TextEditingController(
          text: valorCheckboxNotifier.value ? 'true' : 'false',
        );
      } else {
        // Si el controlador ya existe, actualiza su valor inicial si es necesario
        controllers[label]!.text =
            valorCheckboxNotifier.value ? 'true' : 'false';
      }
    }

    if (tipoCampo == "bool") {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    color: !themeNotifier.temaClaro
                        ? Colors.white
                        : Colors.black)),
            ValueListenableBuilder<bool>(
              valueListenable: valorCheckboxNotifier,
              builder: (context, valorSwitch, child) {
                return Switch(
                  value: valorSwitch, // Estado visual del Switch
                  onChanged: esCampoBloqueado
                      ? null // Bloqueado si es true
                      : (bool nuevoValor) {
                          setState(() {
                            valorCheckboxNotifier.value = nuevoValor;
                            bool nuevoValorBool = nuevoValor ? true : false;
                            controllers[label]?.text =
                                nuevoValorBool.toString();
                            print(
                                "Nuevo valor de Estado bool: $nuevoValorBool");
                          });
                        },
                  activeColor: Colors.blueAccent, // Color cuando está activo
                );
              },
            ),
          ],
        ),
      );
    }

    if (tipoCampo == "switch") {
      // Inicializa el ValueNotifier basado en valorInicial
      valorSwitchNotifier.value = valorInicial == 1;
      if (!controllers.containsKey(label)) {
        controllers[label] = TextEditingController(
          text: valorSwitchNotifier.value ? '1' : '0',
        );
      } else {
        // Si el controlador ya existe, actualiza su valor inicial si es necesario
        controllers[label]!.text = valorSwitchNotifier.value ? '1' : '0';
      }
    }

    if (tipoCampo == "switch") {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    color: !themeNotifier.temaClaro
                        ? Colors.white
                        : Colors.black)),
            ValueListenableBuilder<bool>(
              valueListenable: valorSwitchNotifier,
              builder: (context, valorSwitch, child) {
                return Switch(
                  value: valorSwitch, // Estado visual del Switch
                  onChanged: esCampoBloqueado
                      ? null // Bloqueado si es true
                      : (bool nuevoValor) {
                          setState(() {
                            valorSwitchNotifier.value = nuevoValor;
                            int nuevoValorInt = nuevoValor ? 1 : 0;
                            controllers[label]?.text = nuevoValorInt.toString();
                            print("Nuevo valor de Estado: $nuevoValorInt");
                          });
                        },
                  activeColor: Colors.blueAccent, // Color cuando está activo
                );
              },
            ),
          ],
        ),
      );
    }

    if (tipoCampo == "date") {
      // Asegúrate de inicializar el controlador si no existe
      if (!controllers.containsKey(label)) {
        controllers[label] = TextEditingController(
            text: valorInicial.toIso8601String().split('T')[0]);
        focusNodes[label] = FocusNode();
      } else {
        controllers[label]!.text = valorInicial.toIso8601String().split('T')[0];
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          readOnly: true, // Evita la entrada de texto manual
          enabled: !esCampoBloqueado,
          controller: controllers[label],
          focusNode: focusNodes[label],
          onTap: () async {
            DateTime? nuevaFecha = await showDatePicker(
              context: context,
              initialDate: valorInicial,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (nuevaFecha != null) {
              setState(() {
                // Actualiza el valor en el controlador
                controllers[label]!.text =
                    nuevaFecha.toIso8601String().split('T')[0];
              });
            }
          },
          decoration: inputDecoration,
          style: textStyle,
        ),
      );
    }

    if (tipoCampo == "dropdown") {
      // Inicializa el controlador si no existe
      if (!controllers.containsKey(label)) {
        controllers[label] =
            TextEditingController(text: valorInicial?.toString());
        focusNodes[label] = FocusNode();
      } else {
        // Si el controlador ya existe, actualiza su valor
        controllers[label]?.text = valorInicial!.toString();
      }

      if (widget.catalogo == 'Canal Distribucion') {
        await _getTipoCanalDistribucion(1);
        dropdownItems = _tipoCanalDistribucion.map((item) {
          return PopupMenuItem<int>(
            value: item.tipoCanalDistribucion,
            child: Text(item.descripcion!),
          );
        }).toList();
      }

      if (valorInicial != null) {
        String? descripcionEncontrada;
        // Bucle para encontrar la descripción
        for (var item in _tipoCanalDistribucion) {
          if (item.tipoCanalDistribucion == valorInicial) {
            descripcionEncontrada = item.descripcion;
            break;
          }
        }
        if (descripcionEncontrada != null) {
          controllers[label]?.text = descripcionEncontrada;
        }
      }

      // Variable local para manejar la selección
      valorSeleccionadoDropdown = controllers[label]?.text.isNotEmpty == true
          ? int.tryParse(controllers[label]!.text)
          : null;

      // Crear el Dropdown sin FutureBuilder ya que los datos ya están cargados
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          enabled: !esCampoBloqueado,
          controller: controllers[label],
          readOnly: true, // Evita la entrada de texto manual
          onTap: () async {
            final nuevoValor = await showMenu<int>(
              context: context,
              position: RelativeRect.fromLTRB(100, 100, 0, 0),
              items: dropdownItems,
            );

            if (nuevoValor != null) {
              print("Valor seleccionado: $nuevoValor");

              // Encuentra la descripción del item seleccionado
              final selectedItem = _tipoCanalDistribucion.firstWhere(
                (item) => item.tipoCanalDistribucion == nuevoValor,
              );

              setState(() {
                controllers[label]?.text = selectedItem.descripcion!;
                valorSeleccionadoDropdown = nuevoValor;
              });
            }
          },
          decoration: inputDecoration.copyWith(
            suffixIcon: esCampoBloqueado
                ? Icon(Icons.lock, color: Colors.grey)
                : IconButton(
                    icon: Icon(Icons.arrow_drop_down), // Icono de menú
                    onPressed: () async {
                      // Mostrar el menú emergente
                      final nuevoValor = await showMenu<int>(
                        context: context,
                        position: RelativeRect.fromLTRB(100, 100, 0, 0),
                        items: dropdownItems,
                      );

                      if (nuevoValor != null) {
                        print("Valor seleccionado: $nuevoValor");

                        // Encuentra la descripción del item seleccionado
                        final selectedItem = _tipoCanalDistribucion.firstWhere(
                          (item) => item.tipoCanalDistribucion == nuevoValor,
                        );

                        setState(() {
                          controllers[label]?.text = selectedItem.descripcion!;
                          valorSeleccionadoDropdown = nuevoValor;
                        });
                      }
                    },
                  ),
          ),
          style: textStyle,
        ),
      );
    }

    // Si no es booleano, sigue el flujo normal
    TextInputType tipoTeclado;
    if (tipoCampo == "int") {
      tipoTeclado = TextInputType.number;
    } else if (tipoCampo == "double") {
      tipoTeclado = TextInputType.numberWithOptions(decimal: true);
    } else if (tipoCampo == "email") {
      tipoTeclado = TextInputType.emailAddress;
    } else {
      tipoTeclado = TextInputType.text;
    }

    if (!controllers.containsKey(label)) {
      controllers[label] = TextEditingController(text: valorInicial.toString());
      focusNodes[label] = FocusNode();
    } else {
      controllers[label]!.text = valorInicial.toString();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: !esCampoBloqueado,
        controller: controllers[label],
        focusNode: focusNodes[label],
        keyboardType: tipoTeclado,
        decoration: inputDecoration,
        style: textStyle,
      ),
    );
  }

  //Método para llamar a la función del catálogo para insertar un registro
  void insertarRegistros(String catalogo) async {
    List<String> camposVacios = [];
    FocusNode?
        primerCampoVacio; // Variable para almacenar el primer campo vacío

    // Recorre los controladores y verifica si están vacíos solo si el campo no está bloqueado
    controllers.forEach((label, controller) {
      bool esCampoBloqueado =
          registros[0].getCamposBloqueadosInsert()[label] ?? false;

      // Verificar si el campo no está bloqueado y su valor está vacío
      if (!esCampoBloqueado && controller.text.isEmpty) {
        camposVacios.add(label); // Agrega el nombre del campo vacío a la lista
        if (primerCampoVacio == null) {
          primerCampoVacio =
              focusNodes[label]; // Guarda el FocusNode del primer campo vacío
        }
      }
    });

    // Si hay campos vacíos, muestra la alerta
    if (camposVacios.isNotEmpty) {
      String mensaje =
          '${S.of(context).dashboardLosSiguientesCamposEstanVacios}\n' +
              camposVacios.join('\n');
      _mostrarAlerta(
          context,
          S.of(context).dashboardCamposVacios,
          mensaje,
          FontAwesomeIcons.circleExclamation,
          Colors.red.shade700,
          1,
          S.of(context).dashboardAceptar, () {
        // Aquí, cerramos el AlertDialog y activamos el Focus en el primer campo vacío
        if (primerCampoVacio != null) {
          FocusScope.of(context).requestFocus(primerCampoVacio);
        }
      }, null, null);
    } else {
      switch (catalogo) {
        case 'Tipo Canal Distribucion':
          _mostrarAlerta(
              context,
              S.of(context).dashboardConfirmar,
              S.of(context).dashboardDeseaInsertarEsteRegistro,
              FontAwesomeIcons.circleExclamation,
              Color(0xFFFEAB308),
              1,
              S.of(context).dashboardInsertar, () async {
            await _getTipoCanalDistribucion(2);
          }, null, null);
          break;
        case 'Canal Distribucion':
          _mostrarAlerta(
              context,
              S.of(context).dashboardConfirmar,
              S.of(context).dashboardDeseaInsertarEsteRegistro,
              FontAwesomeIcons.circleExclamation,
              Color(0xFFFEAB308),
              1,
              S.of(context).dashboardInsertar, () async {
            await _getCanalDistribucion(2);
          }, null, null);
          break;
        case 'Elemento Asignado':
          _mostrarAlerta(
              context,
              S.of(context).dashboardConfirmar,
              S.of(context).dashboardDeseaInsertarEsteRegistro,
              FontAwesomeIcons.circleExclamation,
              Color(0xFFFEAB308),
              1,
              S.of(context).dashboardInsertar, () async {
            await _getElementoAsignado(2);
          }, null, null);
          break;
        case 'User':
          _mostrarAlerta(
              context,
              S.of(context).dashboardConfirmar,
              S.of(context).dashboardDeseaInsertarEsteRegistro,
              FontAwesomeIcons.circleExclamation,
              Color(0xFFFEAB308),
              1,
              S.of(context).dashboardInsertar, () async {
            await _getUser(2);
          }, null, null);
          break;
        default:
          setState(() {});
          return;
      }
    }
  }

  //Método para llamar a la función del catálogo para actualizar un registro
  void actualizarRegistros(String catalogo) async {
    switch (catalogo) {
      case 'Tipo Canal Distribucion':
        _mostrarAlerta(
            context,
            S.of(context).dashboardConfirmar,
            S.of(context).dashboardDeseaActualizarEsteRegistro,
            FontAwesomeIcons.circleExclamation,
            Color(0xFFFEAB308),
            1,
            S.of(context).dashboardActualizar, () async {
          await _getTipoCanalDistribucion(3);
        }, null, null);
        break;
      case 'Canal Distribucion':
        _mostrarAlerta(
            context,
            S.of(context).dashboardConfirmar,
            S.of(context).dashboardDeseaActualizarEsteRegistro,
            FontAwesomeIcons.circleExclamation,
            Color(0xFFFEAB308),
            1,
            S.of(context).dashboardActualizar, () async {
          await _getCanalDistribucion(3);
        }, null, null);
        break;
      case 'Elemento Asignado':
        _mostrarAlerta(
            context,
            S.of(context).dashboardConfirmar,
            S.of(context).dashboardDeseaActualizarEsteRegistro,
            FontAwesomeIcons.circleExclamation,
            Color(0xFFFEAB308),
            1,
            S.of(context).dashboardActualizar, () async {
          await _getElementoAsignado(3);
        }, null, null);
        break;
      case 'User':
        _mostrarAlerta(
            context,
            S.of(context).dashboardConfirmar,
            S.of(context).dashboardDeseaActualizarEsteRegistro,
            FontAwesomeIcons.circleExclamation,
            Color(0xFFFEAB308),
            1,
            S.of(context).dashboardActualizar, () async {
          await _getUser(3);
        }, null, null);
        break;
      default:
        setState(() {});
        return;
    }
  }

  //Método para llamar a la función del catálogo para eliminar un registro
  void eliminarRegistros(String catalogo) async {
    widget.searchController.clear();
    switch (catalogo) {
      case 'Tipo Canal Distribucion':
        _mostrarAlerta(
            context,
            S.of(context).dashboardConfirmar,
            S.of(context).dashboardDeseaEliminarEsteRegistro,
            FontAwesomeIcons.circleExclamation,
            Color(0xFFFEAB308),
            1,
            S.of(context).dashboardEliminar, () async {
          await _getTipoCanalDistribucion(4);
        }, null, null);
        break;
      case 'Canal Distribucion':
        _mostrarAlerta(
            context,
            S.of(context).dashboardConfirmar,
            S.of(context).dashboardDeseaEliminarEsteRegistro,
            FontAwesomeIcons.circleExclamation,
            Color(0xFFFEAB308),
            1,
            S.of(context).dashboardEliminar, () async {
          await _getCanalDistribucion(4);
        }, null, null);
        break;
      case 'Elemento Asignado':
        _mostrarAlerta(
            context,
            S.of(context).dashboardConfirmar,
            S.of(context).dashboardDeseaEliminarEsteRegistro,
            FontAwesomeIcons.circleExclamation,
            Color(0xFFFEAB308),
            1,
            S.of(context).dashboardEliminar, () async {
          await _getElementoAsignado(4);
        }, null, null);
        break;
      case 'User':
        _mostrarAlerta(
            context,
            S.of(context).dashboardConfirmar,
            S.of(context).dashboardDeseaEliminarEsteRegistro,
            FontAwesomeIcons.circleExclamation,
            Color(0xFFFEAB308),
            1,
            S.of(context).dashboardEliminar, () async {
          await _getUser(4);
        }, null, null);
        break;
      default:
        setState(() {});
        return;
    }
  }

  //Función para catálogo TipoCanalDistribución
  Future<void> _getTipoCanalDistribucion(int accion) async {
    setState(() {
      _cargando = true; // Establecer isLoading a true al inicio de la carga
    });

    String? valorInputTipoCanalDistribucion =
        controllers['Tipo Canal Distribución']?.text ?? null;
    String? valorInputDescripcion = controllers['Descripción']?.text ?? null;
    String? valorInputEstado = controllers['Estado']?.text ?? null;
    String? valorInputFechaHora = controllers['Fecha y Hora']?.text ?? null;

    // Conversión de valores a int
    int? tipoCanalDistribucion = valorInputTipoCanalDistribucion != null
        ? int.tryParse(valorInputTipoCanalDistribucion) // Convierte a int
        : null;
    int? estado =
        valorInputEstado != null ? int.tryParse(valorInputEstado) : null;
    // Por ejemplo, si 'Fecha y Hora' se espera que sea una fecha:
    DateTime? fechaHora = valorInputFechaHora != null
        ? DateTime.tryParse(valorInputFechaHora)
        : null;
    String url = '${widget.baseUrl}PaCrudTipoCanalDistribucionCtrl';

    Map<String, String?> queryParams = {
      "accion": accion.toString(),
      if (widget.catalogo != "Canal Distribucion")
        "pCriterioBusqueda": widget.searchController.text,
      if (widget.catalogo == "Canal Distribucion") "pCriterioBusqueda": "",
      if (tipoCanalDistribucion != null)
        "pTipoCanalDistribucion": tipoCanalDistribucion?.toString(),
      if (valorInputDescripcion != null && valorInputDescripcion.isNotEmpty)
        "pDescripcion": valorInputDescripcion,
      if (estado != null) "pEstado": estado?.toString(),
      "pUserName": widget.pUserName,
    };
    print(queryParams);
    Map<String, String> parametrosString = queryParams
        .map((key, value) => MapEntry(key, value ?? ''))
      ..removeWhere((key, value) => value.isEmpty);

    Uri uri = Uri.parse(url).replace(queryParameters: parametrosString);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        // Verifica si la respuesta es un Map
        if (decodedResponse is Map) {
          if (decodedResponse['resultado'] == false) {
            _mostrarAlerta(
                context,
                S.of(context).dashboardError,
                decodedResponse['mensaje'],
                FontAwesomeIcons.circleExclamation,
                Colors.red.shade700,
                0,
                S.of(context).dashboardAceptar,
                null,
                null,
                null);
            return; // Salir del método si hay un error
          }
          // Ajusta según la estructura de tu respuesta
          if (decodedResponse['datos'] != null) {
            List<PaCrudTipoCanalDistribucionM> tipoCanalDistribucion =
                (decodedResponse['datos'] as List)
                    .map((data) => PaCrudTipoCanalDistribucionM.fromJson(data))
                    .toList();
            setState(() {
              _tipoCanalDistribucion = tipoCanalDistribucion;
            });
          } else {
            print('No se encontraron datos en la respuesta.');
          }
        } else if (decodedResponse is List) {
          if (decodedResponse.isNotEmpty && decodedResponse[0] is Map) {
            var responseMap = decodedResponse[0];
            if (responseMap['resultado'] == false) {
              _mostrarAlerta(
                  context,
                  S.of(context).dashboardError,
                  responseMap['mensaje'],
                  FontAwesomeIcons.circleExclamation,
                  Colors.red.shade700,
                  0,
                  S.of(context).dashboardAceptar,
                  null,
                  null,
                  null);
              widget.searchController.clear();
              _getTipoCanalDistribucion(1);
              setState(() {});
              return; // Salir del método si hay un error
            }
          }
          List<PaCrudTipoCanalDistribucionM> tipoCanalDistribucion =
              decodedResponse
                  .map((data) => PaCrudTipoCanalDistribucionM.fromJson(data))
                  .toList();
          setState(() {
            _tipoCanalDistribucion = tipoCanalDistribucion;
          });
        } else {
          print('Formato de respuesta inesperado.');
        }

        if (accion == 2 || accion == 3 || accion == 4) {
          _opcionSeleccionada = "";
          controllers.clear();
          controllers.forEach((key, controller) {
            controller.clear(); // Esto vacía el texto de cada controlador
          });
          generarRegistros(widget.catalogo ?? '');
          if (accion == 4) {
            widget.searchController.clear();
            _mostrarMensajeScaffold(
                context,
                "Registro eliminado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
          if (accion == 3) {
            _mostrarMensajeScaffold(
                context,
                "Registro actualizado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
          if (accion == 2) {
            _mostrarMensajeScaffold(
                context,
                "Registro ingresado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
          widget.onScrollToTop();
        }
      } else {
        print('Error: ${response.body}');
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

  //Función para catálogo CanalDistribución
  Future<void> _getCanalDistribucion(int accion) async {
    setState(() {
      _cargando = true; // Establecer isLoading a true al inicio de la carga
    });

    String? valorInputBodega = controllers['Bodega']?.text ?? null;
    String? valorInputDescripcion = controllers['Descripción']?.text ?? null;
    String? valorInputEstado = controllers['Estado']?.text ?? null;
    String? valorInputFechaHora = controllers['Fecha y Hora']?.text ?? null;

    int? bodega =
        valorInputBodega != null ? int.tryParse(valorInputBodega) : null;
    int? estado =
        valorInputEstado != null ? int.tryParse(valorInputEstado) : null;
    print("Estado: $estado");
    // Por ejemplo, si 'Fecha y Hora' se espera que sea una fecha:
    DateTime? fechaHora = valorInputFechaHora != null
        ? DateTime.tryParse(valorInputFechaHora)
        : null;
    String url = '${widget.baseUrl}PaCrudCanalDistribucionCtrl';

    Map<String, String?> queryParams = {
      "accion": accion.toString(),
      "pCriterioBusqueda": widget.searchController.text,
      if (bodega != null) "pBodega": bodega.toString(),
      if (valorSeleccionadoDropdown != null)
        "pTipoCanalDistribucion": valorSeleccionadoDropdown.toString(),
      if (valorInputDescripcion != null && valorInputDescripcion.isNotEmpty)
        "pDescripcion": valorInputDescripcion,
      if (estado != null) "pEstado": estado.toString(),
      if (fechaHora != null) "pFecha_Hora": fechaHora.toIso8601String(),
      "pUserName": widget.pUserName,
    };
    print(queryParams);
    Map<String, String> parametrosString = queryParams
        .map((key, value) => MapEntry(key, value ?? ''))
      ..removeWhere((key, value) => value.isEmpty);

    Uri uri = Uri.parse(url).replace(queryParameters: parametrosString);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        // Verifica si la respuesta es un Map
        if (decodedResponse is Map) {
          if (decodedResponse['resultado'] == false) {
            // Muestra el mensaje en un AlertDialog
            _mostrarAlerta(
                context,
                S.of(context).dashboardError,
                decodedResponse['mensaje'],
                FontAwesomeIcons.circleExclamation,
                Colors.red.shade700,
                0,
                S.of(context).dashboardAceptar,
                null,
                null,
                null);
            return; // Salir del método si hay un error
          }
          // Ajusta según la estructura de tu respuesta
          if (decodedResponse['datos'] != null) {
            List<PaCrudCanalDistribucionM> canalDistribucion =
                (decodedResponse['datos'] as List)
                    .map((data) => PaCrudCanalDistribucionM.fromJson(data))
                    .toList();
            setState(() {
              _canalDistribucion = canalDistribucion;
            });
          } else {
            print('No se encontraron datos en la respuesta.');
          }
        } else if (decodedResponse is List) {
          if (decodedResponse.isNotEmpty && decodedResponse[0] is Map) {
            var responseMap = decodedResponse[0];
            if (responseMap['resultado'] == false) {
              _mostrarAlerta(
                  context,
                  S.of(context).dashboardError,
                  responseMap['mensaje'],
                  FontAwesomeIcons.circleExclamation,
                  Colors.red.shade700,
                  0,
                  S.of(context).dashboardAceptar,
                  null,
                  null,
                  null);
              widget.searchController.clear();
              _getCanalDistribucion(1);
              setState(() {});
              return; // Salir del método si hay un error
            }
          }
          List<PaCrudCanalDistribucionM> canalDistribucion = decodedResponse
              .map((data) => PaCrudCanalDistribucionM.fromJson(data))
              .toList();
          setState(() {
            _canalDistribucion = canalDistribucion;
          });
        } else {
          print('Formato de respuesta inesperado.');
        }
        if (accion == 2 || accion == 3 || accion == 4) {
          _opcionSeleccionada = "";
          controllers.clear();
          controllers.forEach((key, controller) {
            controller.clear(); // Esto vacía el texto de cada controlador
          });
          generarRegistros(widget.catalogo ?? '');
          if (accion == 4) {
            widget.searchController.clear();
            _mostrarMensajeScaffold(
                context,
                "Registro eliminado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
          if (accion == 3) {
            _mostrarMensajeScaffold(
                context,
                "Registro actualizado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
          if (accion == 2) {
            _mostrarMensajeScaffold(
                context,
                "Registro ingresado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
        }
      } else {
        print('Error: ${response.body}');
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

  //Función para catálogo ElementoAsignado
  Future<void> _getElementoAsignado(int accion) async {
    setState(() {
      _cargando = true; // Establecer isLoading a true al inicio de la carga
    });

    String? valorInputElementoId = controllers['Elemento Id']?.text ?? null;
    String? valorInputDescripcion = controllers['Descripción']?.text ?? null;
    String? valorInputEstado = controllers['Estado']?.text ?? null;
    String? valorInputFechaHora = controllers['Fecha y Hora']?.text ?? null;
    String? valorInputElementoAsignado =
        controllers['Elemento Asignado']?.text ?? null;
    int? estado =
        valorInputEstado != null ? int.tryParse(valorInputEstado) : null;
    DateTime? fechaHora = valorInputFechaHora != null
        ? DateTime.tryParse(valorInputFechaHora)
        : null;

    String url = '${widget.baseUrl}PaCrudElementoAsignadoCtrl';

    Map<String, String?> queryParams = {
      "accion": accion.toString(),
      "pCriterioBusqueda": widget.searchController.text,
      if (valorInputElementoId != null)
        "pElementoAsignado": valorInputElementoAsignado,
      "pElementoId": valorInputElementoId,
      "pUserName": widget.pUserName,
      "pEmpresa": widget.pEmpresa.toString(),
      if (valorInputDescripcion != null && valorInputDescripcion.isNotEmpty)
        "pDescripcion": valorInputDescripcion,
      if (estado != null) "pEstado": estado.toString(),
      if (fechaHora != null) "pFecha_Hora": fechaHora.toIso8601String(),
    };
    print(queryParams);
    Map<String, String> parametrosString = queryParams
        .map((key, value) => MapEntry(key, value ?? ''))
      ..removeWhere((key, value) => value.isEmpty);

    Uri uri = Uri.parse(url).replace(queryParameters: parametrosString);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      });

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        // Verifica si la respuesta es un Map
        if (decodedResponse is Map) {
          if (decodedResponse['resultado'] == false) {
            // Muestra el mensaje en un AlertDialog
            _mostrarAlerta(
                context,
                S.of(context).dashboardError,
                decodedResponse['mensaje'],
                FontAwesomeIcons.circleExclamation,
                Colors.red.shade700,
                0,
                S.of(context).dashboardAceptar,
                null,
                null,
                null);
            return; // Salir del método si hay un error
          }
          // Ajusta según la estructura de tu respuesta
          if (decodedResponse['datos'] != null) {
            List<PaCrudElementoAsignadoM> elementoAsignado =
                (decodedResponse['datos'] as List)
                    .map((data) => PaCrudElementoAsignadoM.fromJson(data))
                    .toList();
            setState(() {
              _elementoAsignado = elementoAsignado;
            });
          } else {
            print('No se encontraron datos en la respuesta.');
          }
        } else if (decodedResponse is List) {
          if (decodedResponse.isNotEmpty && decodedResponse[0] is Map) {
            var responseMap = decodedResponse[0];
            if (responseMap['resultado'] == false) {
              _mostrarAlerta(
                  context,
                  S.of(context).dashboardError,
                  responseMap['mensaje'],
                  FontAwesomeIcons.circleExclamation,
                  Colors.red.shade700,
                  0,
                  S.of(context).dashboardAceptar,
                  null,
                  null,
                  null);
              widget.searchController.clear();
              _getElementoAsignado(1);
              setState(() {});
              return; // Salir del método si hay un error
            }
          }
          List<PaCrudElementoAsignadoM> elementoAsignado = decodedResponse
              .map((data) => PaCrudElementoAsignadoM.fromJson(data))
              .toList();
          setState(() {
            _elementoAsignado = elementoAsignado;
          });
        } else {
          print('Formato de respuesta inesperado.');
        }
        if (accion == 2 || accion == 3 || accion == 4) {
          _opcionSeleccionada = "";
          controllers.clear();
          controllers.forEach((key, controller) {
            controller.clear(); // Esto vacía el texto de cada controlador
          });
          generarRegistros(widget.catalogo ?? '');
          if (accion == 4) {
            widget.searchController.clear();
            _mostrarMensajeScaffold(
                context,
                "Registro eliminado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
          if (accion == 3) {
            _mostrarMensajeScaffold(
                context,
                "Registro actualizado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
          if (accion == 2) {
            _mostrarMensajeScaffold(
                context,
                "Registro ingresado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
        }
      } else {
        print('Error: ${response.body}');
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

  //Función para catálogo User
  Future<void> _getUser(int accion) async {
    setState(() {
      _cargando = true; // Establecer isLoading a true al inicio de la carga
    });

    String? valorInputpUserName = controllers['UserName']?.text ?? null;
    String? valorInputpEmpresa = controllers['Empresa']?.text ?? null;
    String? valorInputpEstacionTrabajo =
        controllers['Estacion Trabajo']?.text ?? null;
    String? valorInputpApplication = controllers['Application']?.text ?? null;
    String? valorInputName = controllers['Name']?.text ?? null;
    String? valorInputCelular = controllers['Celular']?.text ?? null;
    String? valorInputEMail = controllers['EMail']?.text ?? null;
    String? valorInputDisable = controllers['Disable']?.text ?? null;

    String? valorInputPass = controllers['Pass']?.text ?? null;
    String? valorInputFechaHora = controllers['Fecha y Hora']?.text ?? null;
    DateTime? fechaHora = valorInputFechaHora != null
        ? DateTime.tryParse(valorInputFechaHora)
        : null;

    String url = '${widget.baseUrl}PaCrudUserCtrl';

    Map<String, String?> queryParams = {
      "accion": accion.toString(),
      "pCriterioBusqueda": widget.searchController.text,
      if (valorInputpUserName != null) "pUserName": valorInputpUserName,
      "pEmpresa": valorInputpEmpresa,
      "pEstacion_Trabajo": valorInputpEstacionTrabajo,
      "pApplication": valorInputpApplication,
      "pName": valorInputName,
      "pCelular": valorInputCelular,
      "pEMail": valorInputEMail,
      "pPass": valorInputPass,
      if (valorInputDisable != null) "pDisable": valorInputDisable.toString(),
      if (fechaHora != null) "pFecha_Hora": fechaHora.toIso8601String(),
    };
    print(queryParams);
    Map<String, String> parametrosString = queryParams
        .map((key, value) => MapEntry(key, value ?? ''))
      ..removeWhere((key, value) => value.isEmpty);

    Uri uri = Uri.parse(url).replace(queryParameters: parametrosString);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      }).timeout(Duration(seconds: 130));
      ;

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        // Verifica si la respuesta es un Map
        if (decodedResponse is Map) {
          if (decodedResponse['resultado'] == false) {
            // Muestra el mensaje en un AlertDialog
            _mostrarAlerta(
                context,
                S.of(context).dashboardError,
                decodedResponse['mensaje'],
                FontAwesomeIcons.circleExclamation,
                Colors.red.shade700,
                0,
                S.of(context).dashboardAceptar,
                null,
                null,
                null);
            return; // Salir del método si hay un error
          }
          // Ajusta según la estructura de tu respuesta
          if (decodedResponse['datos'] != null) {
            List<PaCrudUserM> user = (decodedResponse['datos'] as List)
                .map((data) => PaCrudUserM.fromJson(data))
                .toList();
            setState(() {
              _user = user;
            });
          } else {
            print('No se encontraron datos en la respuesta.');
          }
        } else if (decodedResponse is List) {
          if (decodedResponse.isNotEmpty && decodedResponse[0] is Map) {
            var responseMap = decodedResponse[0];
            if (responseMap['resultado'] == false) {
              _mostrarAlerta(
                  context,
                  S.of(context).dashboardError,
                  responseMap['mensaje'],
                  FontAwesomeIcons.circleExclamation,
                  Colors.red.shade700,
                  0,
                  S.of(context).dashboardAceptar,
                  null,
                  null,
                  null);
              widget.searchController.clear();
              _getElementoAsignado(1);
              setState(() {});
              return; // Salir del método si hay un error
            }
          }
          List<PaCrudUserM> user = decodedResponse
              .map((data) => PaCrudUserM.fromJson(data))
              .toList();
          setState(() {
            _user = user;
          });
        } else {
          print('Formato de respuesta inesperado.');
        }
        if (accion == 2 || accion == 3 || accion == 4) {
          _opcionSeleccionada = "";
          controllers.clear();
          controllers.forEach((key, controller) {
            controller.clear(); // Esto vacía el texto de cada controlador
          });
          generarRegistros(widget.catalogo ?? '');
          if (accion == 4) {
            widget.searchController.clear();
            _mostrarMensajeScaffold(
                context,
                "Registro eliminado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
          if (accion == 3) {
            _mostrarMensajeScaffold(
                context,
                "Registro actualizado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
          if (accion == 2) {
            _mostrarMensajeScaffold(
                context,
                "Registro ingresado correctamente",
                MdiIcons.checkboxMarkedCircle,
                Color(0xFFF15803D),
                Duration(seconds: 4));
          }
        }
      } else {
        print('Error: ${response.body}');
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

  double _calculateAspectRatio(BuildContext context) {
    // Obtener el ancho de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;

    // Ajustar el childAspectRatio dependiendo del ancho de la pantalla
    if (screenWidth < 400) {
      return 4; // Mayor proporción para pantallas pequeñas
    } else if (screenWidth < 600) {
      return 3; // Proporción media para pantallas medianas
    } else {
      return 2; // Proporción estándar para pantallas más grandes
    }
  }

  @override
  Widget build(BuildContext context) {
    final opcionNotifier = Provider.of<CatalogoProvider>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          //DISEÑO CONTAINER PRINCIPAL
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
              children: [
                //DROPDOWN PARA NAVEGAR A OTROS CATÁLOGOS
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Tooltip(
                          message: S.of(context).dashboardSeleccionaUnCatalogo,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                S.of(context).drawerMantenimiento,
                                style: TextStyle(
                                  color: !themeNotifier.temaClaro
                                      ? Colors.grey.shade200
                                      : Colors.blueGrey,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              value: opcionNotifier.selectedValue,
                              items: <String>[
                                'Canal Distribucion',
                                'Tipo Canal Distribucion',
                                'Elemento Asignado',
                                'User'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Tooltip(
                                    message:
                                        value, // Mensaje del tooltip para cada opción
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: !themeNotifier.temaClaro
                                            ? Colors.grey.shade200
                                            : Colors.blueGrey,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  opcionNotifier.setSelectedValue(newValue);
                                });
                                // Navegar a Mantenimiento al seleccionar un valor
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Mantenimiento(
                                      imagePath: widget.imagePath,
                                      isBackgroundSet: widget.isBackgroundSet,
                                      catalogo: newValue,
                                      changeLanguage: widget.changeLanguage,
                                      idiomaDropDown: widget.idiomaDropDown,
                                      temaClaro: widget.temaClaro,
                                      token: widget.token,
                                      pUserName: widget.pUserName,
                                      pEmpresa: widget.pEmpresa,
                                      pEstacion_Trabajo:
                                          widget.pEstacion_Trabajo,
                                      baseUrl: widget.baseUrl,
                                      fechaSesion: widget.fechaSesion,
                                      fechaExpiracion: widget.fechaExpiracion,
                                      despEmpresa: widget.despEmpresa,
                                      despEstacion_Trabajo:
                                          widget.despEstacion_Trabajo,
                                      pApplication: widget.pApplication,
                                    ),
                                  ),
                                );
                              },
                              iconStyleData: IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: !themeNotifier.temaClaro
                                      ? Colors.grey.shade200
                                      : Colors.blueGrey,
                                ),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: !themeNotifier.temaClaro
                                      ? Color.fromARGB(255, 0, 42, 58)
                                      : Color.fromARGB(255, 226, 233, 236),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                offset: Offset(0, 8),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness:
                                      MaterialStateProperty.all<double>(6),
                                  thumbVisibility:
                                      MaterialStateProperty.all<bool>(true),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                      ),
                    ],
                  ),
                ),
                //Container de descripciones
                Container(
                  decoration: BoxDecoration(
                    color: !themeNotifier.temaClaro
                        ? Color(0xFFF1F2937)
                        : Color.fromARGB(255, 226, 233, 236),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: !themeNotifier.temaClaro
                            ? Colors.black87
                            : Color(0xFFA3C6C4),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        //Muestra de iconos e input de busqueda
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: !themeNotifier.temaClaro
                                    ? Color.fromARGB(255, 43, 56, 75)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),

                              //Muestra de icono e input de busqueda
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 4.0,
                                runSpacing: 4.0,
                                children: [
                                  // Icono y textfield para buscar
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        //Boton para buscar
                                        Tooltip(
                                          showDuration: Duration(seconds: 4),
                                          richMessage: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${S.of(context).dashboardBuscarRegistro}\n',
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: S
                                                    .of(context)
                                                    .dashboardSeRealizaraUnaBusqueda,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF374151),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          verticalOffset: 20,
                                          child: IconButton(
                                            highlightColor:
                                                const Color.fromARGB(
                                                    255, 160, 216, 224),
                                            icon: Icon(MdiIcons.bookSearch,
                                                color: Colors.blueGrey,
                                                size: 20),
                                            onPressed: () {
                                              widget.focusSearch.unfocus();
                                              generarRegistros(
                                                  widget.catalogo ?? '');
                                            },
                                          ),
                                        ),
                                        //TextField de busqueda
                                        Container(
                                          width: 100,
                                          child: TextField(
                                            focusNode: widget.focusSearch,
                                            onEditingComplete: () {
                                              widget.focusSearch.unfocus();
                                              generarRegistros(
                                                  widget.catalogo ?? '');
                                            },
                                            controller: widget.searchController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  S.of(context).dashboardBuscar,
                                              hintStyle: TextStyle(
                                                  color:
                                                      !themeNotifier.temaClaro
                                                          ? Colors.white
                                                          : Colors.black),
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                                color: !themeNotifier.temaClaro
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      ]),
                                  // Icono de agregar
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (!_registroSeleccionado)
                                        Tooltip(
                                          showDuration: Duration(seconds: 4),
                                          richMessage: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${S.of(context).dashboardAgregar}\n',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: S
                                                    .of(context)
                                                    .dashboardSeHabilitaranLosInputs,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF374151),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          verticalOffset: 20,
                                          child: IconButton(
                                            highlightColor:
                                                const Color.fromARGB(
                                                    255, 160, 224, 187),
                                            icon: Icon(
                                              MdiIcons.textBoxPlus,
                                              color: Colors.green,
                                              size: 24,
                                            ),
                                            onPressed: () async {
                                              await habilitarInputs(2);
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (_cargando)
                        LoadingComponent(
                            color: Colors.lightBlue,
                            changeLanguage: widget.changeLanguage),
                      // Lista de Descripciones
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 300.0,
                          decoration: BoxDecoration(
                            color: !themeNotifier.temaClaro
                                ? Color.fromARGB(255, 43, 56, 75)
                                : Color.fromARGB(255, 238, 237, 237),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: !themeNotifier.temaClaro
                                  ? Color.fromARGB(255, 55, 70, 94)
                                  : Color.fromARGB(255, 197, 197, 197),
                              width: 2.0,
                            ),
                          ),
                          //  GridView.builder de descripciones
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Scrollbar(
                                thickness: 8.0,
                                radius: Radius.circular(10),
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    childAspectRatio:
                                        _calculateAspectRatio(context),
                                    crossAxisSpacing: 6.0,
                                    mainAxisSpacing: 6.0,
                                  ),
                                  itemCount: descripciones.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                        color: _indiceSeleccionado == index
                                            ? (themeNotifier.temaClaro
                                                ? Color.fromARGB(
                                                    255, 217, 233, 248)
                                                : Color.fromARGB(
                                                    255, 94, 126, 155))
                                            : !themeNotifier.temaClaro
                                                ? Color.fromARGB(
                                                    255, 49, 63, 85)
                                                : Colors.white,
                                        child: InkWell(
                                            onTap: () async {
                                              String? selectedValue =
                                                  descripciones[index];
                                              setState(() {
                                                _indiceSeleccionado = index;
                                                _opcionSeleccionada =
                                                    selectedValue; // Actualiza el estado
                                                _registroSeleccionado = true;
                                                accionService.setAccion(
                                                    "${S.of(context).dashboardVisualizandoRegistro} ${_opcionSeleccionada}",
                                                    MdiIcons.checkAll);
                                                widget.onScrollToDown();
                                              });
                                              // Realiza la acción de selección
                                              ModelWithFields? registro;
                                              for (var modelo in registros) {
                                                switch (widget.catalogo) {
                                                  case 'Tipo Canal Distribucion':
                                                    if ((modelo as PaCrudTipoCanalDistribucionM)
                                                            .descripcion ==
                                                        selectedValue) {
                                                      registro = modelo;
                                                    }
                                                    break;
                                                  case 'Canal Distribucion':
                                                    if ((modelo as PaCrudCanalDistribucionM)
                                                            .descripcion ==
                                                        selectedValue) {
                                                      registro = modelo;
                                                    }
                                                    break;
                                                  case 'Elemento Asignado':
                                                    if ((modelo as PaCrudElementoAsignadoM)
                                                            .descripcion ==
                                                        selectedValue) {
                                                      registro = modelo;
                                                    }
                                                    break;
                                                  case 'User':
                                                    if ((modelo as PaCrudUserM)
                                                            .name ==
                                                        selectedValue) {
                                                      registro = modelo;
                                                    }
                                                    break;
                                                }
                                              }

                                              if (registro != null) {
                                                print("llenando INPUT");
                                                await llenarInputs(registro);
                                              } else {
                                                print(
                                                    'No se encontró el registro correspondiente');
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  //  Ícono + Descripción
                                                  Flexible(
                                                    flex: 1,
                                                    child: Tooltip(
                                                      showDuration:
                                                          Duration(seconds: 4),
                                                      richMessage: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '${S.of(context).dashboardInformacion}\n',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFFF0284c7),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: S
                                                                .of(context)
                                                                .dashboardSeMostraraInformacion,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Icon(
                                                        Icons.info_outline,
                                                        size: 25,
                                                        color: !themeNotifier
                                                                .temaClaro
                                                            ? Colors.white70
                                                            : Colors
                                                                .blue.shade700,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Tooltip(
                                                      message:
                                                          "${descripciones[index]}",
                                                      child: Text(
                                                        "${descripciones[index]}",
                                                        style: TextStyle(
                                                          color: !themeNotifier
                                                                  .temaClaro
                                                              ? Colors.white
                                                              : Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),

                                                  //PopupMenuButton con flecha
                                                  Flexible(
                                                    flex: 1,
                                                    child: PopupMenuButton(
                                                      color: !themeNotifier
                                                              .temaClaro
                                                          ? Colors.white70
                                                          : Colors.white,
                                                      icon: Icon(
                                                        Icons.arrow_drop_down,
                                                        size:
                                                            24, // Reducir tamaño del ícono de flecha
                                                        color: !themeNotifier
                                                                .temaClaro
                                                            ? Colors.white70
                                                            : Colors.black38,
                                                      ),
                                                      itemBuilder: (BuildContext
                                                          context) {
                                                        return [
                                                          PopupMenuItem(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${S.of(context).loginUsuario}: ${datosDinamicos[index]['userName'] ?? 'N/A'}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: !themeNotifier.temaClaro
                                                                        ? Colors
                                                                            .grey
                                                                            .shade600
                                                                        : Colors
                                                                            .black38,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 4),
                                                                Text(
                                                                  '${datosDinamicos[index]['fechaHora'] ?? 'Sin descripción'}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: !themeNotifier.temaClaro
                                                                        ? Colors
                                                                            .grey
                                                                            .shade600
                                                                        : Colors
                                                                            .black38,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )));
                                  },
                                ),
                              )),
                        ),
                      ),
                      //Boton para Limpiar Seleccion y Regrescar catalogo
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Tooltip(
                            showDuration: Duration(seconds: 4),
                            richMessage: TextSpan(
                              children: [
                                TextSpan(
                                  text: _registroSeleccionado == false
                                      ? '${S.of(context).dashboardRefrescarCatalogo}\n'
                                      : '${S.of(context).dashboardLimpiarSeleccion}\n',
                                  style: TextStyle(
                                    color: Color(0xFFF0284c7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: S
                                      .of(context)
                                      .dashboardSeEliminaranSelecciones,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFF374151),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            verticalOffset: 20,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _indiceSeleccionado = null;
                                  _opcionSeleccionada = null;
                                  _registroSeleccionado = false;
                                  widget.searchController.clear();
                                  // Limpiar los inputs también
                                  controllers.forEach((key, controller) {
                                    controller.clear();
                                  });
                                  generarRegistros(widget.catalogo ?? '');
                                  accionService.setAccion(
                                      "${S.of(context).dashboardVisualizandoCatalogo} ${widget.catalogo}",
                                      MdiIcons.checkAll);
                                });
                              },
                              child: Text(
                                _registroSeleccionado == false
                                    ? S.of(context).dashboardRefrescarCatalogo
                                    : S.of(context).dashboardLimpiarSeleccion,
                                style: TextStyle(color: Colors.blue),
                              ),
                            ))
                      ]),
                      Divider(
                        color: Color.fromARGB(255, 151, 151, 151),
                      ),
                      // Footer con número de registros
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${S.of(context).dashboardNumeroDeRegistros}: ${descripciones.length}',
                              style: TextStyle(
                                color: !themeNotifier.temaClaro
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                //Container de inputs
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: !themeNotifier.temaClaro
                        ? Color(0xFFF1F2937)
                        : Color.fromARGB(255, 226, 233, 236),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: !themeNotifier.temaClaro
                            ? Colors.black87
                            : Color(0xFFA3C6C4),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // Ajusta el tamaño del Column al contenido
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Inputs dinámicos con un contenedor para controlar el tamaño
                      if (!_registroSeleccionado && dynamicInputs.isNotEmpty ||
                          _registroSeleccionado && dynamicInputs.isNotEmpty)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight:
                                  400), // Puedes ajustar el tamaño máximo
                          child: ListView(
                            shrinkWrap:
                                true, // Evita que ListView ocupe espacio infinito
                            children: dynamicInputs,
                          ),
                        ),
                      // Espacio flexible para empujar los botones hacia abajo
                      SizedBox(height: 20),
                      // Iconos alineados a la derecha en la parte inferior
                      if (_cargando)
                        LoadingComponent(
                            color: Colors.lightBlue,
                            changeLanguage: widget.changeLanguage),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Ajusta el tamaño del Row al contenido
                              children: [
                                if (!_registroSeleccionado &&
                                    dynamicInputs.isNotEmpty)
                                  Tooltip(
                                    showDuration: Duration(seconds: 4),
                                    richMessage: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${S.of(context).dashboardGuardarRegistro}\n',
                                          style: TextStyle(
                                            color: Color(0xFFF2563eb),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: S
                                              .of(context)
                                              .dashboardSeGuardaraElRegistro,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF374151),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    verticalOffset: 20,
                                    child: IconButton(
                                      highlightColor: const Color.fromARGB(
                                          255, 160, 200, 224),
                                      icon: Icon(
                                        MdiIcons.contentSavePlus,
                                        color: Color(0xFFF2563eb),
                                      ),
                                      onPressed: () {
                                        insertarRegistros(
                                            widget.catalogo ?? '');
                                      },
                                    ),
                                  ),
                                if (_registroSeleccionado)
                                  Tooltip(
                                    showDuration: Duration(seconds: 4),
                                    richMessage: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${S.of(context).dashboardEliminar}\n',
                                          style: TextStyle(
                                            color: Color(0xFFFef4444),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: S
                                              .of(context)
                                              .dashboardSeEliminaraElRegistro,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF374151),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    verticalOffset: 20,
                                    child: IconButton(
                                      highlightColor: const Color.fromARGB(
                                          255, 224, 160, 160),
                                      icon: Icon(
                                        MdiIcons.deleteForever,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        eliminarRegistros(
                                            widget.catalogo ?? '');
                                      },
                                    ),
                                  ),
                                if (_registroSeleccionado)
                                  Tooltip(
                                    showDuration: Duration(seconds: 4),
                                    richMessage: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${S.of(context).dashboardActualizar}\n',
                                          style: TextStyle(
                                            color: Color(0xFFF9ca3af),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: S
                                              .of(context)
                                              .dashboardSeActualizaraElRegistro,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF374151),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    verticalOffset: 20,
                                    child: IconButton(
                                      highlightColor: const Color.fromARGB(
                                          255, 160, 216, 224),
                                      icon: Icon(
                                        MdiIcons.bookEdit,
                                        color: Colors.blueGrey.shade400,
                                      ),
                                      onPressed: () {
                                        actualizarRegistros(
                                            widget.catalogo ?? '');
                                      },
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
