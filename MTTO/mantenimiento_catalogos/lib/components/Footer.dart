import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_catalogos/common/ThemeNotifier.dart';
import 'package:mantenimiento_catalogos/services/Shared.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar esto para el Provider

// ignore: must_be_immutable
class Footer extends StatefulWidget {
  final String imagePath;
  final bool isBackgroundSet;
  final String? catalogo;
  final Function(Locale) changeLanguage;
  final String pUserName;
  final String? despEmpresa;
  final String? despEstacion_Trabajo;
  Locale idiomaDropDown;
  final String token;
  final int pEmpresa;
  final int pEstacion_Trabajo;
  final String baseUrl;
  final DateTime? fechaExpiracion;
  final DateTime fechaSesion;

  Footer({
    required this.imagePath,
    required this.isBackgroundSet,
    required this.catalogo,
    required this.changeLanguage,
    required this.idiomaDropDown,
    required this.pUserName,
    required this.despEmpresa,
    required this.despEstacion_Trabajo,
    required this.token,
    required this.pEmpresa,
    required this.pEstacion_Trabajo,
    required this.baseUrl,
    this.fechaExpiracion,
    required this.fechaSesion,
  });

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Estacion: ${widget.despEstacion_Trabajo}");
    // Obtener la instancia de AccionService
    final accionService = Provider.of<AccionService>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
      decoration: BoxDecoration(
        color: !themeNotifier.temaClaro
            ? Color.fromARGB(255, 0, 39, 53)
            : Color(0xFF004964),
        boxShadow: [
          BoxShadow(
            color:
                !themeNotifier.temaClaro ? Colors.black87 : Color(0xFFA3C6C4),
            blurRadius: 10.0,
            spreadRadius: 0.5,
            offset: Offset(0.0, 1.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding alrededor del footer
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Acción destacada
            if (accionService.accion != null) // Verifica si hay acción
              Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.1), // Fondo sutil para la acción
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      accionService.accion!.icono,
                      color: Colors.white,
                    ), // Icono de la acción
                    SizedBox(width: 8),
                    Flexible(
                      child: Tooltip(
                        message: "${accionService.accion!.texto}",
                        child: Text(
                          accionService.accion!.texto, // Texto de la acción
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1, // Limitar a una línea
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Texto del catálogo
            Padding(
              padding: EdgeInsets.all(5),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      FaIcon(FontAwesomeIcons.book,
                          color: Colors.white, size: 20),
                      Tooltip(
                        message: "${widget.catalogo ?? 'Sin catálogo'}",
                        child: Text(
                          "${widget.catalogo ?? 'Sin catálogo'}",
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      FaIcon(Icons.person, color: Colors.white, size: 24),
                      Tooltip(
                        message: widget.pUserName,
                        child: Text(
                          widget.pUserName,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (widget.despEstacion_Trabajo != null &&
                      widget.despEstacion_Trabajo != '')
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        FaIcon(MdiIcons.domain, color: Colors.white, size: 24),
                        Tooltip(
                          message: widget.despEstacion_Trabajo ?? '',
                          child: Text(
                            widget.despEstacion_Trabajo ?? '',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
