import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:traslado_datos/common/ThemeNotifier.dart';
import 'package:traslado_datos/generated/l10n.dart';
import 'package:traslado_datos/services/LoginService.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

Future<void> mostrarDialogo({
  required BuildContext context,
  required String titulo,
  required String mensaje,
  IconData? icono,
  required Color colorIcono,
  int cantidadBotones = 0,
  String textoPrimerBoton = 'Aceptar',
  String? textoSegundoBoton,
  VoidCallback? funcionPrimerBoton,
  VoidCallback? funcionSegundoBoton,
}) async {
  final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:
            !themeNotifier.temaClaro ? Color(0xFFF1F2937) : Colors.white,
        title: Row(
          children: [
            if (icono != null) // Si se pasa un icono, lo muestra
              Icon(
                icono,
                color: colorIcono, // Puedes ajustar el color si lo deseas
              ),
            SizedBox(width: 10), // Espacio entre el icono y el texto
            Text(
              titulo,
              style: TextStyle(
                color: !themeNotifier.temaClaro
                    ? Colors.white
                    : Color(0xFFF1F2937),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          // Agregar scroll aquí
          child: Text(
            mensaje,
            style: TextStyle(
              color:
                  !themeNotifier.temaClaro ? Colors.white : Color(0xFFF1F2937),
              fontSize: 16,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: <Widget>[
          if (cantidadBotones > 0)
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: !themeNotifier.temaClaro
                    ? Colors.blue.shade900
                    : Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                if (funcionPrimerBoton != null) {
                  funcionPrimerBoton();
                }
              },
              child: Text(
                textoPrimerBoton,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          if (cantidadBotones == 2 && textoSegundoBoton != null)
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                if (funcionSegundoBoton != null) {
                  funcionSegundoBoton();
                }
              },
              child: Text(
                textoSegundoBoton,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      );
    },
  );
}

Future<void> mostrarMensajeScaffold({
  required BuildContext context,
  required String mensaje,
  IconData? icono,
  required Color colorIcono,
  Duration duracion = const Duration(seconds: 3), // Duración predeterminada
}) async {
  final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icono != null)
            Icon(
              icono,
              color: colorIcono,
            ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(
                color: !themeNotifier.temaClaro
                    ? Color(0xFFF15803D)
                    : Color(0xFFF15803D),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      backgroundColor:
          themeNotifier.temaClaro ? Color(0xFFFDCFCE7) : Color(0xFFFDCFCE7),
      behavior: SnackBarBehavior.floating, // Hace que el mensaje flote
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      duration: duracion,
    ),
  );
}

class Mensajes {
  //Mensaje si no se ha seleccionado o ingresado información requerida
  static void mensajeAdvertencia(BuildContext context, String mensaje,
      Color backgroundColor, Color titleColor, Color textColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 27,
                color: Color(0xFFDC9525),
              ),
              SizedBox(width: 5),
              Flexible(
                  child: Text(S.of(context).mensajesAdvertencia,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                      )))
            ],
          ),
          content: RichText(
              text: TextSpan(children: [
            TextSpan(text: mensaje, style: TextStyle(color: textColor)),
          ])),
          actions: <Widget>[
            TextButton(
              child: Text(
                S.of(context).mensajesAceptar,
                style: TextStyle(color: Colors.cyan),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Mensaje para confirmar transaccion (creacion documento, insertar cargo abono) llamar funciones
  static void mostrarDialogoConfirmacion(
      BuildContext context,
      Function _funcion,
      Function _desplazarScroll,
      String mensaje,
      Color backgroundColor,
      Color titleColor,
      Color textColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Row(
            children: [
              Icon(MdiIcons.clipboardCheckMultipleOutline,
                  size: 27, color: Color(0xFFDC9525)),
              SizedBox(width: 5),
              Expanded(
                  child: Text(S.of(context).mensajesConfirmarCreacion,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                      )))
            ],
          ),
          content: Text(mensaje, style: TextStyle(color: textColor)),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).mensajesConfimar,
                  style: TextStyle(color: Colors.cyan)),
              onPressed: () {
                _funcion();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).mensajesCancelar,
                  style: TextStyle(color: Colors.cyan)),
              onPressed: () {
                Navigator.of(context).pop();
                _desplazarScroll();
              },
            ),
          ],
        );
      },
    );
  }

  //Mensaje para cerrar Sesion de Usuario
  static void cerrarSesionUsuario(bool temaClaro, BuildContext context,
      String pUserName, DateTime fecha, DateTime? fechaE) async {
    String fechaFormateada = DateFormat('dd MMMM yyyy, HH:mm').format(fecha);
    String? fechaVFormateada = fechaE != null
        ? DateFormat('dd MMMM yyyy, HH:mm').format(fechaE)
        : 'Fecha no disponible';

    final LoginService _loginService = LoginService();
    // ignore: unused_local_variable
    final sessionData = _loginService.getUserSession();

    showDialog(
      barrierColor: temaClaro
          ? Colors.black.withOpacity(0.5)
          : Colors.black.withOpacity(0.7),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: temaClaro
              ? Colors.white
              : Color.fromARGB(255, 18, 32, 47).withOpacity(0.9),
          title: Row(
            children: [
              Icon(Icons.account_circle,
                  color: temaClaro ? Colors.blue : Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Tooltip(
                  message: '${S.of(context).mensajesUsuario}: $pUserName',
                  child: Text(
                    '${S.of(context).mensajesUsuario}: $pUserName',
                    style: TextStyle(
                        color: temaClaro ? Colors.black : Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: temaClaro ? Colors.blue.shade300 : Colors.white30),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(MdiIcons.calendarCheck,
                      color: temaClaro ? Colors.blue : Colors.white70),
                  SizedBox(width: 10),
                  Expanded(
                    child: Tooltip(
                      message:
                          '${S.of(context).mensajesSesionGuardadaEl} $fechaFormateada',
                      child: Text(
                        '${S.of(context).mensajesSesionGuardadaEl} $fechaFormateada',
                        style: TextStyle(
                            color: temaClaro ? Colors.black : Colors.white70),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              if (fechaE != '' && fechaE != null)
                Row(
                  children: [
                    Icon(MdiIcons.calendarRemove,
                        color: temaClaro ? Colors.blue : Colors.white70),
                    SizedBox(width: 10),
                    Expanded(
                      child: Tooltip(
                        message:
                            '${S.of(context).mensajesSesionExpiraEl} $fechaVFormateada',
                        child: Text(
                          '${S.of(context).mensajesSesionExpiraEl} $fechaVFormateada',
                          style: TextStyle(
                              color: temaClaro ? Colors.black : Colors.white70),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          actions: [
            Center(
              child: Wrap(
                spacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await _loginService.clearUserSession();
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/inicio');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al cerrar sesión: $e'),
                          ),
                        );
                      }
                    },
                    icon: Icon(MdiIcons.logout, color: Colors.white),
                    label: Text(
                      S.of(context).mensajesCerrarSesion,
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
