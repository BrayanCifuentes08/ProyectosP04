abstract class ModelWithFields {
  Map<String, dynamic> getFields();

  Map<String, bool> getCamposBloqueadosUpdate();

  Map<String, bool> getCamposBloqueadosInsert();

  Map<String, String> getTiposDeCampo();
}
