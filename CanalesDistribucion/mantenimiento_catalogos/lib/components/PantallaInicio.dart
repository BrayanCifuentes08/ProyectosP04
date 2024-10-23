import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mantenimiento_catalogos/common/CatalogoProvider.dart';
import 'package:mantenimiento_catalogos/common/ThemeNotifier.dart';
import 'package:mantenimiento_catalogos/components/Mantenimiento.dart';
import 'package:mantenimiento_catalogos/generated/l10n.dart';
import 'package:mantenimiento_catalogos/services/LoginService.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PantallaInicio extends StatefulWidget {
  final bool isBackgroundSet;
  final String imagePath;
  final Function(Locale) changeLanguage;
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

  PantallaInicio({
    required this.isBackgroundSet,
    required this.imagePath,
    required this.changeLanguage,
    required this.idiomaDropDown,
    required this.temaClaro,
    required this.token,
    required this.pUserName,
    required this.pEmpresa,
    required this.pEstacion_Trabajo,
    required this.fechaSesion,
    this.fechaExpiracion,
    required this.baseUrl,
    required this.despEmpresa,
    required this.despEstacion_Trabajo,
  });
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  String? _selectedValue;
  late Timer _timer;
  Duration _timeLeft = Duration();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Verificar si la fecha de expiración es válida
    if (widget.fechaExpiracion != null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        final expiration = widget.fechaExpiracion!;
        final difference = expiration.difference(now);

        if (difference.isNegative) {
          _timer.cancel(); // Cancelar el timer si la sesión ya expiró
        } else {
          setState(() {
            _timeLeft = difference;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '$days días, ${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
    final screenSize = MediaQuery.of(context).size;
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final opcionNotifier = Provider.of<CatalogoProvider>(context);
    return SliverToBoxAdapter(
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              //DECORACIÓN DEL CONTAINER PRINCIPAL
              decoration: BoxDecoration(
                color: widget.isBackgroundSet
                    ? Color.fromARGB(0, 21, 70, 144)
                    : !themeNotifier.temaClaro
                        ? Color(0xFFF111827)
                        : Colors.white,
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
                    // Título de bienvenida
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        S.of(context).inicioBienvenido,
                        style: TextStyle(
                          fontSize:
                              screenSize.width * 0.055, // Tamaño adaptativo
                          color: !themeNotifier.temaClaro
                              ? Colors.grey.shade200
                              : Color(0xFF004964),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Dropdown de opciones de catalogo
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Alinear a la derecha
                        children: [
                          SizedBox(
                            width: 150,
                          ),
                          Expanded(
                            // Agregar un Expanded para ocupar el espacio restante
                            child: Tooltip(
                              message:
                                  'Selecciona un catálogo', // Mensaje del tooltip para el Dropdown
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
                                  value: _selectedValue,
                                  items: <String>[
                                    'Canal Distribucion',
                                    'Tipo Canal Distribucion'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Tooltip(
                                        message:
                                            value, // Mensaje del tooltip para cada opción
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: Colors.white,
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
                                          isBackgroundSet:
                                              widget.isBackgroundSet,
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
                                          fechaExpiracion:
                                              widget.fechaExpiracion,
                                          despEmpresa: widget.despEmpresa,
                                          despEstacion_Trabajo:
                                              widget.despEstacion_Trabajo,
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
                                      color: Color(0xFF004964),
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
                        ],
                      ),
                    ),
                    // Tarjeta moderna de usuario
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F2937),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: !themeNotifier.temaClaro
                                ? Color.fromARGB(0, 23, 26, 26)
                                : Color(0xFFA3C6C4),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Ícono del usuario
                                    FaIcon(
                                      MdiIcons.accountCircle,
                                      size: screenSize.width *
                                          0.15, // Tamaño adaptativo
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    SizedBox(height: 8),
                                    // Nombre del usuario
                                    Text(widget.pUserName,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 8),
                                    //Boton cerrar Sesión
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          final LoginService _loginService =
                                              LoginService();
                                          await _loginService
                                              .clearUserSession();
                                          Navigator.pushReplacementNamed(
                                              context, '/inicio');
                                        },
                                        icon: FaIcon(
                                            FontAwesomeIcons.signOutAlt,
                                            size: 18),
                                        label: Text(
                                          S.of(context).inicioCerrarSesion,
                                          style: TextStyle(
                                            fontSize: screenSize.width *
                                                0.04, // Tamaño de texto adaptable
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            iconColor: Colors.white,
                                            backgroundColor: Colors.transparent,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  screenSize.width * 0.1,
                                              vertical:
                                                  screenSize.height * 0.02,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            side: BorderSide(
                                                color: Colors.white, width: 2)),
                                      ),
                                    ),
                                  ])),
                          SizedBox(height: screenSize.height * 0.02),
                          // Información del usuario organizada en filas
                          Container(
                            height: 350,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: !themeNotifier.temaClaro
                                  ? Colors.white70
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                // Permite el desplazamiento del contenido
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Alinear a la izquierda
                                  children: [
                                    // Fila para la hora de inicio
                                    if (widget.fechaSesion != '')
                                      Row(
                                        children: [
                                          Icon(
                                            MdiIcons.calendarCheck,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start, // Alinear a la izquierda
                                              children: [
                                                Text(
                                                  S
                                                      .of(context)
                                                      .inicioHoraDeInicioSesion,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  DateFormat(
                                                          'dd MMMM yyyy, HH:mm')
                                                      .format(
                                                          widget.fechaSesion),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    Divider(
                                      color: Colors.black,
                                      height: 10,
                                    ),
                                    // Fila para la hora en la que expira
                                    if (widget.fechaExpiracion != null ||
                                        widget.fechaExpiracion == '')
                                      Row(
                                        children: [
                                          Icon(MdiIcons.calendarRemove,
                                              color: Colors.red),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  S
                                                      .of(context)
                                                      .inicioLaSesionExpira,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${DateFormat('dd MMMM yyyy, HH:mm').format(widget.fechaExpiracion!)} |",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Chip(
                                                      label: Text(
                                                        _formatDuration(
                                                            _timeLeft),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      backgroundColor:
                                                          Colors.grey.shade300,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20), // Ajusta el valor para más redondez
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            )));
  }
}
