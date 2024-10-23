import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_cuenta_corriente/generated/l10n.dart';

class LoadingComponent extends StatefulWidget {
  final Color color;
  final Function(Locale) changeLanguage;

  LoadingComponent({
    required this.color,
    required this.changeLanguage,
  });

  @override
  _LoadingComponentState createState() => _LoadingComponentState();
}

class _LoadingComponentState extends State<LoadingComponent> {
  bool cargando = true;

  //al llamar el archivo:
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return cargando
        ? Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 0, 0, 0),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitThreeBounce(
                    color: widget.color,
                    size: 50.0,
                  ),
                  SizedBox(height: 10),
                  Text(
                    S.of(context).cargando,
                    style: TextStyle(color: widget.color),
                  ),
                ],
              ),
            ),
          )
        : SizedBox(); // Si isLoading es false, no muestra nada
  }
}
