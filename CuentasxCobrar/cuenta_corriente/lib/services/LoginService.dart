import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  ValueNotifier<bool> tokenExpiredNotifier = ValueNotifier<bool>(false);

  Future<void> saveUserSession({
    required String username,
    required String password,
    required int empresa,
    required int estacionTrabajo,
    required int aplicacion,
    required int display,
    required String token,
    required DateTime fecha,
    required DateTime tokenExpiration,
    required String urlBase,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setInt('empresa', empresa);
    await prefs.setInt('estacionTrabajo', estacionTrabajo);
    await prefs.setInt('aplicacion', aplicacion);
    await prefs.setInt('display', display);
    await prefs.setString('token', token);
    await prefs.setString('fecha', fecha.toIso8601String());
    await prefs.setString('tokenExpiration', tokenExpiration.toIso8601String());
    await prefs.setString('urlBase', urlBase);
  }

  Future<Map<String, dynamic>> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    String? fechaString = prefs.getString('fecha');
    DateTime? fecha = fechaString != null ? DateTime.parse(fechaString) : null;
    String? tokenExpirationString = prefs.getString('tokenExpiration');
    DateTime? tokenExpiration = tokenExpirationString != null
        ? DateTime.parse(tokenExpirationString)
        : null;

    if (tokenExpiration != null && DateTime.now().isAfter(tokenExpiration)) {
      await clearUserSession();
      tokenExpiredNotifier.value = true; // Notificar que el token ha expirado
      return {}; // Retorna un mapa vacío si la sesión ha expirado
    }

    return {
      'username': prefs.getString('username') ?? '',
      'password': prefs.getString('password') ?? '',
      'empresa': prefs.getInt('empresa') ?? 0,
      'estacionTrabajo': prefs.getInt('estacionTrabajo') ?? 0,
      'aplicacion': prefs.getInt('aplicacion') ?? 0,
      'display': prefs.getInt('display') ?? 0,
      'token': prefs.getString('token') ?? '',
      'fecha': fecha,
      'fechaExpiracion': tokenExpiration,
      'urlBase': prefs.getString('urlBase') ?? ''
    };
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? tokenExpirationString = prefs.getString('tokenExpiration');
    DateTime? tokenExpiration = tokenExpirationString != null
        ? DateTime.parse(tokenExpirationString)
        : null;

    if (tokenExpiration != null && DateTime.now().isAfter(tokenExpiration)) {
      await clearUserSession();
      tokenExpiredNotifier.value = true; // Notificar que el token ha expirado
      return null; // Retorna null si el token ha expirado
    }

    return prefs.getString('token');
  }

  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('empresa');
    await prefs.remove('estacionTrabajo');
    await prefs.remove('aplicacion');
    await prefs.remove('display');
    await prefs.remove('token');
    await prefs.remove('fecha');
    await prefs.remove('tokenExpiration');
    await prefs.remove('urlBase');
  }
}
