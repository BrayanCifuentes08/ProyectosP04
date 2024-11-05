import 'package:flutter/material.dart';

class AnimacionesIcons extends StatelessWidget {
  final IconData icon1;
  final IconData icon2;
  final bool condicion;
  final VoidCallback onPressed;
  final Duration duration;
  final Curve curve;
  final Color colorIcon1;
  final Color colorIcon2;

  AnimacionesIcons({
    required this.icon1,
    required this.icon2,
    required this.condicion,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    required this.colorIcon1,
    required this.colorIcon2,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: duration,
        transitionBuilder: (Widget child, Animation<double> animation) {
          var rotationTween = Tween<double>(begin: 0.0, end: 1.0);
          var rotateAnimation = animation.drive(rotationTween);
          var rotationTransition = RotationTransition(
            turns: rotateAnimation,
            child: child,
          );

          return FadeTransition(
            opacity: animation,
            child: rotationTransition,
          );
        },
        child: Icon(
          condicion ? icon1 : icon2,
          key: ValueKey<bool>(condicion),
          color: condicion ? colorIcon1 : colorIcon2,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class AnimacionTextBarrido extends StatefulWidget {
  final String text;
  final Color colorClaro; // Color para tema claro
  final Color colorOscuro; // Color para tema oscuro
  final bool temaClaro;
  final double fontSize;
  final FontWeight fontWeight;
  final Duration duration;

  AnimacionTextBarrido({
    required this.text,
    required this.colorClaro,
    required this.colorOscuro,
    required this.temaClaro,
    this.fontSize = 30,
    this.fontWeight = FontWeight.bold,
    this.duration = const Duration(seconds: 5),
  });

  @override
  _AnimacionTextBarridoState createState() => _AnimacionTextBarridoState();
}

class _AnimacionTextBarridoState extends State<AnimacionTextBarrido>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(); // La animación se repetirá indefinidamente

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear, // Animación lineal para un movimiento fluido
    ));
  }

  @override
  void dispose() {
    _controller.dispose(); // Limpiamos el controlador cuando ya no se usa
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Definimos los colores para el tema claro y oscuro
        Color colorPrimario =
            widget.temaClaro ? widget.colorClaro : widget.colorOscuro;
        Color colorSecundario = const Color.fromARGB(
            255, 180, 180, 180); // Gris plateado para ambos temas

        return ShaderMask(
          shaderCallback: (Rect bounds) {
            // Calculamos el desplazamiento
            double start = _animation.value * 2 - 1; // Rango de -1 a 1
            return LinearGradient(
              begin: Alignment(-1 + start, 0), // Mueve el inicio del gradiente
              end: Alignment(1 + start, 0), // Mueve el final del gradiente
              colors: [
                colorPrimario,
                colorSecundario,
                colorPrimario,
                colorSecundario,
              ],
              stops: [
                0.0, // Inicio del color primario
                0.8, // Extensión del gris
                1.0, // Extensión del color primario
                2.0, // Fin del gris
              ],
              tileMode: TileMode.repeated, // Repite el gradiente
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              color: Colors.white, // El ShaderMask manejará los colores
            ),
          ),
        );
      },
    );
  }
}
