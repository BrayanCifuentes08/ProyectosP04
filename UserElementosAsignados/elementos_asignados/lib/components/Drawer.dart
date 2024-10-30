// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:elementos_asignados/common/Mensajes.dart';
import 'package:elementos_asignados/common/Mensajes.dart';
import 'package:elementos_asignados/common/ThemeNotifier.dart';
import 'package:elementos_asignados/generated/l10n.dart';
import 'package:elementos_asignados/services/PreferenciasService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatefulWidget {
  final String imagePath;
  final bool isBackgroundSet;
  final Function(Locale) changeLanguage;
  Locale idiomaDropDown;
  bool temaClaro;
  final String token;
  final String pUserName;
  final int pEmpresa;
  final int pEstacion_Trabajo;
  String baseUrl;
  final DateTime fechaSesion;
  final DateTime? fechaExpiracion;
  final String? despEmpresa;
  final String? despEstacion_Trabajo;

  CustomDrawer({
    required this.imagePath,
    required this.isBackgroundSet,
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

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Locale _idiomaActual;
  final PreferenciasService _preferencesService = PreferenciasService();

  @override
  void initState() {
    super.initState();
    _idiomaActual = widget.idiomaDropDown;
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: !themeNotifier.temaClaro
              ? Color.fromARGB(255, 0, 31, 43)
              : Color(0xFF01394D),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 20,
              blurRadius: 20,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: !themeNotifier.temaClaro
                    ? Color.fromARGB(255, 0, 31, 43)
                    : Color(0xFF01394D),
              ),
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 5),
                        Draggable(
                          feedback: Image.asset(
                            'assets/logo.png',
                            height: 60,
                            color: Colors.white,
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                              'assets/logo.png',
                              height: 60,
                              color: Colors.white,
                            ),
                          ),
                          child: Image.asset(
                            'assets/logo.png',
                            height: 60,
                            color: Colors.white,
                          ),
                          onDragEnd: (details) {},
                        ),
                        Spacer(),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Mensajes.cerrarSesionUsuario(
                                    themeNotifier.temaClaro,
                                    context,
                                    widget.pUserName,
                                    widget.fechaSesion,
                                    widget.fechaExpiracion);
                              },
                              child: Initicon(
                                text: widget.pUserName,
                                backgroundColor: themeNotifier.temaClaro
                                    ? Colors.lightBlue[800]
                                    : Colors.lightBlue[900],
                                style: TextStyle(color: Colors.white),
                                size: 30,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          S.of(context).drawerManetenimientoMayus,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 330),
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child:
                            Icon(Icons.language, color: Colors.white, size: 24),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        S.of(context).drawerIdioma,
                        style: TextStyle(
                          color: Colors.white,
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
                      color: !themeNotifier.temaClaro
                          ? Color.fromARGB(255, 0, 42, 58)
                          : Color(0xFFF014c64),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<Locale>(
                        isExpanded: true,
                        iconStyleData: IconStyleData(
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white)),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            color: !themeNotifier.temaClaro
                                ? Color.fromARGB(255, 0, 42, 58)
                                : Color(0xFF004964),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          offset: Offset(0, 8),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        value: widget.idiomaDropDown,
                        onChanged: (Locale? newLocale) {
                          if (newLocale != null) {
                            setState(() {
                              _idiomaActual = newLocale;
                              widget.idiomaDropDown = _idiomaActual;
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
                                  'icons/flags/png100px/es.png', // Path to Spanish flag
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
                                  'icons/flags/png100px/us.png', // Path to US flag
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
                                  'icons/flags/png100px/fr.png', // Ruta a la bandera francesa
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
                                  'icons/flags/png100px/de.png', // Ruta a la bandera alemana
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
                  color: Colors.blueAccent,
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
                  Icons.image,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              title: Text(
                S.of(context).drawerPlantilla,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/selectBackground');
              },
            ),
            // Switch Modo Claro Oscuro
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        themeNotifier.toggleTheme(); // Cambia el tema
                        widget.temaClaro = !widget
                            .temaClaro; // Actualiza la variable del tema claro
                      });

                      // Guarda la preferencia del tema
                      await _preferencesService.saveTemaClaro(widget.temaClaro);
                      widget.temaClaro =
                          await _preferencesService.getTemaClaro();
                    },
                    child: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            !themeNotifier.temaClaro
                                ? 'assets/imagenOscuro3.jpg' // Imagen para modo oscuro
                                : 'assets/imagenClaro2.jpg', // Imagen para modo claro
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            BorderRadius.circular(15), // Esquinas redondeadas
                      ),
                      child: Switch(
                        value: !themeNotifier
                            .temaClaro, // Estado actual del tema claro
                        onChanged: (bool value) async {
                          setState(() {
                            themeNotifier.toggleTheme(); // Cambia el tema
                            widget.temaClaro =
                                !value; // Actualiza la variable del tema claro
                          });
                          // Guarda la preferencia del tema
                          await _preferencesService
                              .saveTemaClaro(widget.temaClaro);
                          widget.temaClaro =
                              await _preferencesService.getTemaClaro();
                        },
                        activeColor: Colors.blueAccent,
                        inactiveTrackColor: Colors.transparent,
                        activeTrackColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
