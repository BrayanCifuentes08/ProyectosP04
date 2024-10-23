import 'package:elementos_asignados/services/PreferenciasService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SeleccionFondo extends StatefulWidget {
  final Function(String) onSelectBackground;

  const SeleccionFondo({Key? key, required this.onSelectBackground})
      : super(key: key);

  @override
  _SeleccionFondoState createState() => _SeleccionFondoState();
}

class _SeleccionFondoState extends State<SeleccionFondo> {
  final ImagePicker _picker = ImagePicker();
  final PreferenciasService _preferenciasService = PreferenciasService();
  String? customImagePath;
  bool isBackgroundSet = false;

  @override
  void initState() {
    super.initState();
    _checkBackgroundStatus();
  }

  Future<void> _checkBackgroundStatus() async {
    isBackgroundSet = await _preferenciasService.isBackgroundSet();
    if (isBackgroundSet) {
      customImagePath = await _preferenciasService.getBackgroundImage();
    }
    setState(() {});
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        customImagePath = image.path;
      });
      widget.onSelectBackground(image.path);
      await _preferenciasService.saveBackgroundImage(image.path);

      await Future.delayed(Duration(milliseconds: 100));

      Navigator.pushReplacementNamed(context, '/inicio');
    }
  }

  void _removeBackground() async {
    setState(() {
      customImagePath = null;
      isBackgroundSet = false;
    });
    widget.onSelectBackground('');
    await _preferenciasService.removeBackgroundImage();
    Navigator.pushReplacementNamed(context, '/inicio');
  }

  @override
  Widget build(BuildContext context) {
    // Determina la cantidad de elementos en el GridView
    int itemCount = isBackgroundSet ? 8 : 7;

    return Scaffold(
      appBar: AppBar(title: Text("Seleccionar Plantilla")),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: itemCount, // Cantidad de elementos en el GridView
        itemBuilder: (context, index) {
          if (index < 6) {
            String imagePath = 'assets/Fondos/background${index + 1}.jpg';
            return GestureDetector(
              onTap: () {
                widget.onSelectBackground(imagePath);
                _preferenciasService.saveBackgroundImage(imagePath);
                Navigator.pushReplacementNamed(context, '/inicio');
              },
              child: Image.asset(imagePath, fit: BoxFit.cover),
            );
          } else if (index <= 6) {
            return GestureDetector(
              onTap: _pickImage,
              child: Container(
                color: Colors.grey[300],
                child: Icon(Icons.add_a_photo, size: 50, color: Colors.black),
              ),
            );
          } else if (index == 7 && isBackgroundSet) {
            // Solo mostrar el botón de quitar fondo si hay un fondo seleccionado
            return GestureDetector(
              onTap: _removeBackground,
              child: Container(
                color: Colors.red[300],
                child: Center(
                  child: Text(
                    "Quitar Fondo",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          } else {
            return SizedBox
                .shrink(); // Devuelve un widget vacío si no se cumple ninguna condición
          }
        },
      ),
    );
  }
}
