// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "dashboardAceptar": MessageLookupByLibrary.simpleMessage("Accept"),
        "dashboardActualizar": MessageLookupByLibrary.simpleMessage("Update"),
        "dashboardAgregandoRegistro":
            MessageLookupByLibrary.simpleMessage("Adding record"),
        "dashboardAgregar": MessageLookupByLibrary.simpleMessage("Add"),
        "dashboardBuscar": MessageLookupByLibrary.simpleMessage("Search..."),
        "dashboardBuscarRegistro":
            MessageLookupByLibrary.simpleMessage("Search Registration"),
        "dashboardCamposVacios":
            MessageLookupByLibrary.simpleMessage("Empty Fields"),
        "dashboardConfirmar": MessageLookupByLibrary.simpleMessage("Confirm"),
        "dashboardDeseaActualizarEsteRegistro":
            MessageLookupByLibrary.simpleMessage(
                "Do you want to update this record?"),
        "dashboardDeseaEliminarEsteRegistro":
            MessageLookupByLibrary.simpleMessage(
                "Do you want to delete this record?"),
        "dashboardDeseaInsertarEsteRegistro":
            MessageLookupByLibrary.simpleMessage(
                "Do you want to insert this record?"),
        "dashboardEliminar": MessageLookupByLibrary.simpleMessage("Delete"),
        "dashboardError": MessageLookupByLibrary.simpleMessage("Error"),
        "dashboardGuardarRegistro":
            MessageLookupByLibrary.simpleMessage("Save Record"),
        "dashboardInformacion":
            MessageLookupByLibrary.simpleMessage("Information"),
        "dashboardInsertar": MessageLookupByLibrary.simpleMessage("Enter"),
        "dashboardLimpiarSeleccion":
            MessageLookupByLibrary.simpleMessage("Clear selection"),
        "dashboardLosSiguientesCamposEstanVacios":
            MessageLookupByLibrary.simpleMessage(
                "The following fields are empty:"),
        "dashboardNumeroDeRegistros":
            MessageLookupByLibrary.simpleMessage("Number of records"),
        "dashboardRefrescarCatalogo":
            MessageLookupByLibrary.simpleMessage("Refresh catalog"),
        "dashboardSeActualizaraElRegistro":
            MessageLookupByLibrary.simpleMessage(
                "Clicking this button\nwill update the record."),
        "dashboardSeEliminaraElRegistro": MessageLookupByLibrary.simpleMessage(
            "Clicking this button\nwill delete the record."),
        "dashboardSeEliminaranSelecciones": MessageLookupByLibrary.simpleMessage(
            "Clicking this button, \nwill remove the current selections and \nupdate the list of records."),
        "dashboardSeGuardaraElRegistro": MessageLookupByLibrary.simpleMessage(
            "Clicking this button\nwill save the record."),
        "dashboardSeHabilitaranLosInputs": MessageLookupByLibrary.simpleMessage(
            "Clicking this button,\nwill enable the empty inputs to \ncomplete the required information."),
        "dashboardSeMostraraInformacion": MessageLookupByLibrary.simpleMessage(
            "Pressing the card \nwill display the complete \nregistration information."),
        "dashboardSeRealizaraUnaBusqueda": MessageLookupByLibrary.simpleMessage(
            "Clicking this button,\nwill perform a search with\nthe entered search criteria."),
        "dashboardSeleccionaUnCatalogo":
            MessageLookupByLibrary.simpleMessage("Select a catalog"),
        "dashboardVisualizandoCatalogo":
            MessageLookupByLibrary.simpleMessage("Viewing catalog:"),
        "dashboardVisualizandoRegistro":
            MessageLookupByLibrary.simpleMessage("Viewing record:"),
        "drawerIdioma": MessageLookupByLibrary.simpleMessage("Language"),
        "drawerManetenimientoMayus":
            MessageLookupByLibrary.simpleMessage("MAINTENANCE"),
        "drawerMantenimiento":
            MessageLookupByLibrary.simpleMessage("Maintenance"),
        "drawerPlantilla": MessageLookupByLibrary.simpleMessage("TEMPLATE"),
        "inicioBienvenido": MessageLookupByLibrary.simpleMessage(
            "Welcome to the Catalog Maintenance System"),
        "inicioCerrarSesion": MessageLookupByLibrary.simpleMessage("Logout"),
        "inicioHoraDeInicioSesion":
            MessageLookupByLibrary.simpleMessage("Login time:"),
        "inicioInicio": MessageLookupByLibrary.simpleMessage("Home"),
        "inicioLaSesionExpira":
            MessageLookupByLibrary.simpleMessage("The session expires:"),
        "loadingCargando":
            MessageLookupByLibrary.simpleMessage("Loading data..."),
        "locale": MessageLookupByLibrary.simpleMessage("en"),
        "loginConfirmar": MessageLookupByLibrary.simpleMessage("Confirm"),
        "loginContrasena": MessageLookupByLibrary.simpleMessage("Password"),
        "loginDebeIngresarElUsuario":
            MessageLookupByLibrary.simpleMessage("You must enter the user"),
        "loginDebeIngresarLaContrasena":
            MessageLookupByLibrary.simpleMessage("You must enter the password"),
        "loginGuardarSesion":
            MessageLookupByLibrary.simpleMessage("Save Session"),
        "loginIngresaContrasena":
            MessageLookupByLibrary.simpleMessage("Enter your password"),
        "loginIngresaUsuario":
            MessageLookupByLibrary.simpleMessage("Enter your user"),
        "loginIngresar": MessageLookupByLibrary.simpleMessage("Join"),
        "loginIngresarURL":
            MessageLookupByLibrary.simpleMessage("Enter your URL here"),
        "loginIniciarSesion": MessageLookupByLibrary.simpleMessage("Login"),
        "loginSeleccionarAplicacion":
            MessageLookupByLibrary.simpleMessage("Select an application"),
        "loginSeleccionarDisplay":
            MessageLookupByLibrary.simpleMessage("Select Displays"),
        "loginSeleccionarEmpresa":
            MessageLookupByLibrary.simpleMessage("Select a company"),
        "loginSeleccionarEstacionTrabajo":
            MessageLookupByLibrary.simpleMessage("Select a workstation"),
        "loginTextoCopiado":
            MessageLookupByLibrary.simpleMessage("Text copied to clipboard"),
        "loginURLNoValida": MessageLookupByLibrary.simpleMessage(
            "The URL is not responding or invalid."),
        "loginURLvalida": MessageLookupByLibrary.simpleMessage(
            "The URL is valid and responding."),
        "loginUsuario": MessageLookupByLibrary.simpleMessage("User"),
        "loginVerificar": MessageLookupByLibrary.simpleMessage("Verify"),
        "mensajesAceptar": MessageLookupByLibrary.simpleMessage("Accept"),
        "mensajesAdvertencia": MessageLookupByLibrary.simpleMessage("Warning"),
        "mensajesCancelar": MessageLookupByLibrary.simpleMessage("Cancel"),
        "mensajesCerrarSesion": MessageLookupByLibrary.simpleMessage("Log out"),
        "mensajesConfimar": MessageLookupByLibrary.simpleMessage("Confirm"),
        "mensajesConfirmarCreacion":
            MessageLookupByLibrary.simpleMessage("Confirm creation:"),
        "mensajesSesionExpiraEl":
            MessageLookupByLibrary.simpleMessage("Session expires on"),
        "mensajesSesionGuardadaEl":
            MessageLookupByLibrary.simpleMessage("Session saved on"),
        "mensajesUsuario": MessageLookupByLibrary.simpleMessage("UserName"),
        "paBscCanalDistribucionMBodega":
            MessageLookupByLibrary.simpleMessage("Winery"),
        "paBscCanalDistribucionMDescripcion":
            MessageLookupByLibrary.simpleMessage("Description"),
        "paBscCanalDistribucionMEstado":
            MessageLookupByLibrary.simpleMessage("State"),
        "paBscCanalDistribucionMFechayHora":
            MessageLookupByLibrary.simpleMessage("Date and Time"),
        "paBscCanalDistribucionMTipoCanalDistribucion":
            MessageLookupByLibrary.simpleMessage("Type Distribution Channel"),
        "paBscCanalDistribucionMUserName":
            MessageLookupByLibrary.simpleMessage("UserName"),
        "paBscTipoCanalDistribucionMDescripcion":
            MessageLookupByLibrary.simpleMessage("Description"),
        "paBscTipoCanalDistribucionMEstado":
            MessageLookupByLibrary.simpleMessage("State"),
        "paBscTipoCanalDistribucionMFechayHora":
            MessageLookupByLibrary.simpleMessage("Date and Time"),
        "paBscTipoCanalDistribucionMTipoCanalDistribucion":
            MessageLookupByLibrary.simpleMessage("Type Distribution Channel"),
        "paBscTipoCanalDistribucionMUserName":
            MessageLookupByLibrary.simpleMessage("UserName"),
        "splashMantenimiento":
            MessageLookupByLibrary.simpleMessage("Maintenance")
      };
}
