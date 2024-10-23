import 'package:flutter/material.dart';

PageRouteBuilder<T> customPageRoute<T>(Widget page, Duration duration) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Ajusta la duración de la animación a 800 ms para un efecto más notorio
      var tween = Tween(begin: Offset(1.0, 0.0), end: Offset.zero);
      var offsetAnimation =
          animation.drive(tween.chain(CurveTween(curve: Curves.easeInOut)));

      // Transición de escala (zoom)
      var scaleTween = Tween(begin: 0.9, end: 1.0);
      var scaleAnimation = animation
          .drive(scaleTween.chain(CurveTween(curve: Curves.easeInOut)));

      // Transición de desvanecimiento
      var fadeTween = Tween(begin: 0.0, end: 1.0);
      var fadeAnimation =
          animation.drive(fadeTween.chain(CurveTween(curve: Curves.easeInOut)));

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        ),
      );
    },
    transitionDuration: duration, // Duración total de la transición
  );
}
