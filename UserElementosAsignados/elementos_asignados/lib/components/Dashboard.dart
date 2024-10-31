import 'dart:convert';
import 'package:elementos_asignados/common/FloatingActionButtonNotifier.dart';
import 'package:elementos_asignados/common/Loading.dart';
import 'package:elementos_asignados/common/ThemeNotifier.dart';
import 'package:elementos_asignados/components/Asignador.dart';
import 'package:elementos_asignados/components/Desasignador.dart';
import 'package:elementos_asignados/components/Layout.dart';
import 'package:elementos_asignados/generated/l10n.dart';
import 'package:elementos_asignados/models/PaBscUserElementoAsignadoM.dart';
import 'package:elementos_asignados/services/Shared.dart';
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
  final bool temaClaro;
  final String token;
  final String pUserName;
  final int pEmpresa;
  final int pEstacion_Trabajo;
  String baseUrl;
  final DateTime fechaSesion;
  final DateTime? fechaExpiracion;
  final String? despEmpresa;
  final String? despEstacion_Trabajo;

  Dashboard({
    required this.isBackgroundSet,
    required this.imagePath,
    required this.changeLanguage,
    required this.idiomaDropDown,
    required this.onScrollToDown,
    required this.onScrollToTop,
    required this.baseUrl,
    required this.token,
    required this.pUserName,
    required this.pEmpresa,
    required this.pEstacion_Trabajo,
    required this.fechaSesion,
    required this.despEmpresa,
    required this.despEstacion_Trabajo,
    this.fechaExpiracion,
    required this.temaClaro,
  });
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _cargando = false;
  bool isAsignarElemento = true;
  bool isDesasignarElemento = true;
  bool mostrarGridElementosUsuario = true;
  TextEditingController searchController = TextEditingController();
  List<PaBscUserElementoAsignadoM> elementosFiltrados = [];
  List<PaBscUserElementoAsignadoM> _elementosAsignados = [];
  bool isEmptyAsignados = false;
  bool isRequestError = false;

  @override
  void initState() {
    super.initState();
    _getUserElementosAsignados();
  }

  //FUNCIÓN PARA OBTENER ELEMENTOS ASIGNADOS DEL USUARIO
  Future<void> _getUserElementosAsignados() async {
    // Verifica que el widget esté montado antes de realizar cualquier acción.
    if (!mounted) return;
    setState(() {
      _elementosAsignados = [];
      isEmptyAsignados = false;
      isRequestError = false;
      _cargando = true;
    });

    String url = '${widget.baseUrl}PaBscUserElementoAsignadoCtrl';
    Map<String, String?> queryParams = {"pUserName": widget.pUserName};

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
        // respuesta JSON a lista
        List<dynamic> jsonResponse = json.decode(response.body);
        List<PaBscUserElementoAsignadoM> elementosAsignados = jsonResponse
            .map((data) => PaBscUserElementoAsignadoM.fromJson(data))
            .toList();

        // Verifica si el widget sigue montado antes de llamar a setState
        if (mounted) {
          setState(() {
            _elementosAsignados = elementosAsignados;
            elementosFiltrados = List.from(_elementosAsignados);
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

  //METODO FILTRAR ELEMENTOS
  void _filtrarElementos(String query) {
    setState(() {
      elementosFiltrados = _elementosAsignados
          .where((elemento) =>
              elemento.descripcion.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  //WIDGET PRINCIPAL
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final accionService = Provider.of<AccionService>(context);
    final fabNotifier = Provider.of<FloatingActionButtonNotifier>(context);
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(0),
      child: SingleChildScrollView(
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
                //TARJETA EN CASO DE ERROR
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
                            S.of(context).dashboardErrorConexion,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            S
                                .of(context)
                                .dashboardNoSePudoRecuperarLaInformacion,
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
                              S.of(context).dashboardReintentar,
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
                // WRAP DE TARJETA DE USUARIO Y BOTONES DE ASIGNAR Y DESASIGNAR
                if (!isRequestError)
                  Wrap(
                    spacing: 1,
                    runSpacing: 1,
                    alignment: WrapAlignment.start,
                    children: [
                      // Tarjeta de Usuario
                      _buildUserCard(
                        widget.pUserName,
                        DateFormat('dd/MM/yy').format(widget.fechaSesion),
                        widget.fechaExpiracion != null
                            ? DateFormat('dd/MM/yy')
                                .format(widget.fechaExpiracion!)
                            : null,
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                fabNotifier.setButtonState(0);
                                isAsignarElemento = !isAsignarElemento;
                                isDesasignarElemento = true;
                                mostrarGridElementosUsuario = isAsignarElemento;
                                if (mostrarGridElementosUsuario) {
                                  searchController.clear();
                                  _getUserElementosAsignados();
                                  accionService
                                      .setAccion(S.of(context).inicioInicio);
                                } else if (!isAsignarElemento) {
                                  accionService.setAccion(
                                      S.of(context).dashboardAsignar);
                                }
                              });
                            },
                            child: Text(
                              S.of(context).dashboardAsignarElementos,
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isAsignarElemento
                                  ? Color(0xFFF194a5a)
                                  : Colors.blue,
                            ),
                          ),
                          if (_elementosAsignados.isNotEmpty)
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  fabNotifier.setButtonState(0);
                                  isDesasignarElemento = !isDesasignarElemento;
                                  isAsignarElemento = true;
                                  mostrarGridElementosUsuario =
                                      isDesasignarElemento;
                                  if (mostrarGridElementosUsuario) {
                                    searchController.clear();
                                    _getUserElementosAsignados();
                                    accionService
                                        .setAccion(S.of(context).inicioInicio);
                                  } else if (!isDesasignarElemento) {
                                    accionService.setAccion(
                                        S.of(context).dashboardDesasignar);
                                  }
                                });
                              },
                              child: Text(
                                S.of(context).dashboardDesasignarElementos,
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDesasignarElemento
                                    ? Color(0xFFF194a5a)
                                    : Colors.blue,
                              ),
                            ),
                          if (_elementosAsignados.isNotEmpty &&
                                  !isDesasignarElemento ||
                              _elementosAsignados.isNotEmpty &&
                                  !isAsignarElemento ||
                              _elementosAsignados.isEmpty && !isAsignarElemento)
                            ElevatedButton.icon(
                              onPressed: () async {
                                setState(() {
                                  fabNotifier.setButtonState(0);
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return Layout(
                                          imagePath: widget.imagePath,
                                          isBackgroundSet:
                                              widget.isBackgroundSet,
                                          changeLanguage: widget.changeLanguage,
                                          idiomaDropDown: widget.idiomaDropDown,
                                          temaClaro: themeNotifier.temaClaro,
                                          baseUrl: widget.baseUrl,
                                          pUserName: widget.pUserName,
                                          token: widget.token,
                                          pEmpresa: widget.pEmpresa,
                                          pEstacion_Trabajo:
                                              widget.pEstacion_Trabajo,
                                          fechaSesion: widget.fechaSesion,
                                          fechaExpiracion:
                                              widget.fechaExpiracion,
                                          despEmpresa: widget.despEmpresa,
                                          despEstacion_Trabajo:
                                              widget.despEstacion_Trabajo,
                                        );
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                });
                              },
                              icon: Icon(FontAwesomeIcons.house,
                                  color: Colors.white,
                                  size: 15), // Ícono de casa
                              label: Text(
                                S.of(context).dashboardVolverAlInicio,
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF194a5a)),
                            ),
                        ],
                      ),
                    ],
                  ),
                Divider(
                  height: 35,
                  thickness: 2,
                  color: Colors.grey,
                ),
                //TARJETA INDICANDO QUE NO TIENE ELEMENTOS EL USUARIO
                if (isEmptyAsignados && isAsignarElemento)
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
                            S.of(context).dashboardNoHayElementosAsignados,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${widget.pUserName} ${S.of(context).dashboardNoTieneNingunElementoAsignado}',
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
                              S.of(context).dashboardRefrescar,
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
                //INPUT DE BUSQUEDA
                if (mostrarGridElementosUsuario &&
                    !isRequestError &&
                    !isEmptyAsignados)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 1),
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
                          hintText: S.of(context).dashboardBuscarElemento,
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
                                  icon: Icon(Icons.clear,
                                      color: Colors.blue[300]),
                                  onPressed: () {
                                    searchController.clear();
                                    _filtrarElementos('');
                                  },
                                )
                              : null,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
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
                            borderSide: BorderSide(
                                color: Colors.blue[400]!, width: 1.5),
                          ),
                          filled: true,
                          fillColor: !themeNotifier.temaClaro
                              ? Color.fromARGB(255, 24, 31, 43)
                              : Colors.transparent),
                      cursorColor: Colors.blue[900],
                    ),
                  ),
                //CHIP DE NO. ELEMENTOS ASIGNADOS
                if (mostrarGridElementosUsuario &&
                    !isRequestError &&
                    !isEmptyAsignados)
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(
                          '${S.of(context).dashboardNoElementosAsignados} ${_elementosAsignados.length}',
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                //COMPONENTE DE CARGA
                if (_cargando)
                  LoadingComponent(
                      color: Colors.blue,
                      changeLanguage: widget.changeLanguage),
                //GRID VIEW DE ELEMENTOS ASIGNADOS AL USUARIO
                if (mostrarGridElementosUsuario &&
                    !isRequestError &&
                    !isEmptyAsignados)
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
                      itemCount: elementosFiltrados.length,
                      itemBuilder: (context, index) {
                        final elemento = elementosFiltrados[index];
                        return _buildAssignedItemCard(elemento.descripcion,
                            elemento.fechaHora, Icons.assignment);
                      },
                    ),
                  ),
                //LLAMADA DE SECCIÓN PARA ASIGNAR ELEMENTOS
                if (isAsignarElemento == false)
                  Asignador(
                    baseUrl: widget.baseUrl,
                    changeLanguage: widget.changeLanguage,
                    pUserName: widget.pUserName,
                    idiomaDropDown: widget.idiomaDropDown,
                    isBackgroundSet: widget.isBackgroundSet,
                    imagePath: widget.imagePath,
                    temaClaro: themeNotifier.temaClaro,
                    pEmpresa: widget.pEmpresa,
                    pEstacion_Trabajo: widget.pEstacion_Trabajo,
                    token: widget.token,
                    fechaSesion: widget.fechaSesion,
                    fechaExpiracion: widget.fechaExpiracion,
                    despEmpresa: widget.despEmpresa,
                    despEstacion_Trabajo: widget.despEstacion_Trabajo,
                  ),
                //LLAMADA DE SECCIÓN PARA DESASIGNAR ELEMENTOS
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
                    pEmpresa: widget.pEmpresa,
                    pEstacion_Trabajo: widget.pEstacion_Trabajo,
                    token: widget.token,
                    fechaSesion: widget.fechaSesion,
                    fechaExpiracion: widget.fechaExpiracion,
                    despEmpresa: widget.despEmpresa,
                    despEstacion_Trabajo: widget.despEstacion_Trabajo,
                  )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  // Tarjeta para mostrar la información del usuario
  Widget _buildUserCard(String name, String sessionStart, String? sessionEnd) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Card(
      color: !themeNotifier.temaClaro
          ? Color.fromARGB(255, 43, 56, 75)
          : Colors.white,
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
                color: !themeNotifier.temaClaro ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text('${S.of(context).dashboardSesion}: $sessionStart',
                style: TextStyle(
                    color: !themeNotifier.temaClaro
                        ? Colors.white
                        : Colors.black)),
            if (sessionEnd != null)
              Text('${S.of(context).dashboardExpira}: $sessionEnd',
                  style: TextStyle(
                      color: !themeNotifier.temaClaro
                          ? Colors.white
                          : Colors.black)),
          ],
        ),
      ),
    );
  }

  // Tarjeta para los elementos asignados al usuario
  Widget _buildAssignedItemCard(
      String itemName, DateTime fechaHora, IconData icon) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final String formattedDate =
        DateFormat('dd/MM/yyyy, HH:mm').format(fechaHora);

    return Card(
      color: !themeNotifier.temaClaro
          ? Color.fromARGB(255, 43, 56, 75)
          : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.green),
            SizedBox(height: 8),
            Tooltip(
              message: itemName,
              child: Text(
                itemName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: !themeNotifier.temaClaro ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Limita a dos líneas
              ),
            ),
            SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 13,
                  color: !themeNotifier.temaClaro
                      ? Colors.white60
                      : Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
