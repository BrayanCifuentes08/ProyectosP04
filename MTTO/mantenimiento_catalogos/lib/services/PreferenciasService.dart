import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasService {
  Future<void> saveBackgroundImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('backgroundImage', imagePath);
    await prefs.setBool('isBackgroundSet',
        imagePath.isNotEmpty); // Estado del fondo actualizado
    print('Background image saved: $imagePath');
  }

  Future<String?> getBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('backgroundImage');
    print('Background image loaded: $imagePath');
    return imagePath;
  }

  Future<bool> isBackgroundSet() async {
    final prefs = await SharedPreferences.getInstance();
    final isSet = prefs.getBool('isBackgroundSet') ?? false;
    print('Is background set: $isSet');
    return isSet;
  }

  Future<void> removeBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('backgroundImage');
    await prefs.setBool('isBackgroundSet', false);
    print('Background image removed');
  }

  Future<void> saveTemaClaro(bool isTemaClaro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('temaClaro', isTemaClaro);
    print('Tema claro guardado: $isTemaClaro');
  }

  Future<bool> getTemaClaro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('temaClaro') ?? false;
  }
}
