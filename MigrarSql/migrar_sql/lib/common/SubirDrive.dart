import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/src/client.dart';
import 'package:migrar_sql/common/Mensajes.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId:
      '999632088097-8d6s3ahb668gnhb4jcpve9pi7l1ug936.apps.googleusercontent.com',
  scopes: ['https://www.googleapis.com/auth/drive.file'],
);

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

Future<void> uploadToDrive(
    List<int> fileBytes, String fileName, BuildContext context) async {
  final GoogleSignInAccount? user = await googleSignIn.signIn();

  if (user == null) {
    print('El usuario no se autenticó.');
    return;
  }

  // Crear cliente autenticado
  final GoogleSignInAuthentication googleAuth = await user.authentication;

  final auth.AuthClient client = auth.authenticatedClient(
    HttpClient() as Client,
    auth.AccessCredentials(
      auth.AccessToken(
        'Bearer',
        googleAuth.accessToken!,
        DateTime.now().add(Duration(hours: 1)),
      ),
      null,
      ['https://www.googleapis.com/auth/drive.file'],
    ),
  );

  final drive.DriveApi driveApi = drive.DriveApi(client);

  // Crear archivo para subir
  final drive.File driveFile = drive.File()
    ..name = fileName
    ..mimeType =
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  try {
    final media = drive.Media(Stream.value(fileBytes), fileBytes.length);
    final response = await driveApi.files.create(
      driveFile,
      uploadMedia: media,
    );

    print('Archivo subido exitosamente a Google Drive con ID: ${response.id}');
    _mostrarMensajeScaffold(
      context,
      'Archivo subido exitosamente a Google Drive',
      Icons.check_circle,
      Colors.green,
      Colors.white,
      Colors.green.shade200,
      Duration(seconds: 3),
    );
  } catch (error) {
    print('Error al subir el archivo a Google Drive: $error');
    _mostrarAlerta(
      context,
      'Error al subir el archivo',
      'Hubo un problema al intentar subir el archivo a Google Drive: $error',
      Icons.error,
      Colors.red,
      0,
      '',
      null,
      null,
      null,
    );
  }
}
