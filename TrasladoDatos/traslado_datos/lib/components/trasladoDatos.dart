import 'dart:convert';
import 'package:traslado_datos/common/Loading.dart';
import 'package:traslado_datos/components/Layout.dart';
import 'package:traslado_datos/generated/l10n.dart';
import 'package:traslado_datos/services/Shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:traslado_datos/common/FloatingActionButtonNotifier.dart';
import 'package:traslado_datos/common/ThemeNotifier.dart';

// ignore: must_be_immutable
class TrasladoDatos extends StatefulWidget {
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

  TrasladoDatos({
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
  _TrasladoDatosState createState() => _TrasladoDatosState();
}

class _TrasladoDatosState extends State<TrasladoDatos> {
  bool _cargando = false;
  bool isAsignarElemento = true;
  bool isDesasignarElemento = true;
  bool mostrarGridElementosUsuario = true;
  TextEditingController searchController = TextEditingController();

  bool isEmptyAsignados = false;
  bool isRequestError = false;

  @override
  void initState() {
    super.initState();
  }

  //WIDGET PRINCIPAL
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
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
              children: [],
            ),
          ),
        ),
      ),
    ));
  }
}
