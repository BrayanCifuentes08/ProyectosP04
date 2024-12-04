class PaBscUserDisplay2M {
  final int userDisplay;
  final int? userDisplayFather;
  final String userName;
  final String name;
  final bool active;
  final bool visible;
  final bool rol;
  final String? display;
  final int application;
  final int? param;
  final bool orden;
  final int consecutivoInterno;
  final String? displayURL;
  final String? displayMenu;
  final String? displayURLAlter;
  final bool languageID;
  final int? tipoDocumento;
  final String? desTipoDocumento;

  PaBscUserDisplay2M({
    required this.userDisplay,
    required this.userDisplayFather,
    required this.userName,
    required this.name,
    required this.active,
    required this.visible,
    required this.rol,
    required this.display,
    required this.application,
    required this.param,
    required this.orden,
    required this.consecutivoInterno,
    required this.displayURL,
    required this.displayMenu,
    required this.displayURLAlter,
    required this.languageID,
    required this.tipoDocumento,
    required this.desTipoDocumento,
  });

  factory PaBscUserDisplay2M.fromJson(Map<String, dynamic> json) {
    return PaBscUserDisplay2M(
      userDisplay: json['user_Display'],
      userDisplayFather: json['user_Display_Father'],
      userName: json['userName'],
      name: json['name'],
      active: json['active'],
      visible: json['visible'],
      rol: json['rol'],
      display: json['display'],
      application: json['application'],
      param: json['param'],
      orden: json['orden'],
      consecutivoInterno: json['consecutivo_Interno'],
      displayURL: json['display_URL'],
      displayMenu: json['display_Menu'],
      displayURLAlter: json['display_URL_Alter'],
      languageID: json['language_ID'],
      tipoDocumento: json['tipo_Documento'],
      desTipoDocumento: json['des_Tipo_Documento'],
    );
  }
}
