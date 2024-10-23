// lib/mensajes.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:test_cuenta_corriente/generated/l10n.dart';
import 'package:test_cuenta_corriente/services/LoginService.dart';

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
                  child: Text(S.of(context).advertencia,
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
                S.of(context).aceptar,
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
                  child: Text(S.of(context).confirmarCreacion,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                      )))
            ],
          ),
          content: Text(mensaje, style: TextStyle(color: textColor)),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).confirmar,
                  style: TextStyle(color: Colors.cyan)),
              onPressed: () {
                _funcion();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).cancelar,
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
                  message: '${S.of(context).usuario}: $pUserName',
                  child: Text(
                    '${S.of(context).usuario}: $pUserName',
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
                  Icon(Icons.access_time,
                      color: temaClaro ? Colors.blue : Colors.white70),
                  SizedBox(width: 10),
                  Expanded(
                    child: Tooltip(
                      message:
                          '${S.of(context).sesionGuardadaEl} $fechaFormateada',
                      child: Text(
                        '${S.of(context).sesionGuardadaEl} $fechaFormateada',
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
              Row(
                children: [
                  Icon(Icons.date_range,
                      color: temaClaro ? Colors.blue : Colors.white70),
                  SizedBox(width: 10),
                  Expanded(
                    child: Tooltip(
                      message:
                          '${S.of(context).sesionExpiraEl} $fechaVFormateada',
                      child: Text(
                        '${S.of(context).sesionExpiraEl} $fechaVFormateada',
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
                      S.of(context).cerrarSesion,
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
