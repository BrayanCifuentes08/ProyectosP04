import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class EnvelopRefreshIndicator extends StatelessWidget {
  final Widget child;
  final bool leadingScrollIndicatorVisible;
  final bool trailingScrollIndicatorVisible;
  final RefreshCallback onRefresh;
  final Color? accent;
  final IndicatorController? controller;

  static const _circleSize = 70.0;
  static const _blurRadius = 10.0;
  static const _defaultShadow = [
    BoxShadow(blurRadius: _blurRadius, color: Color.fromARGB(150, 0, 0, 0))
  ];

  const EnvelopRefreshIndicator({
    required this.child,
    required this.onRefresh,
    this.leadingScrollIndicatorVisible = false,
    this.trailingScrollIndicatorVisible = false,
    this.accent,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomRefreshIndicator(
      controller: controller,
      leadingScrollIndicatorVisible: leadingScrollIndicatorVisible,
      trailingScrollIndicatorVisible: trailingScrollIndicatorVisible,
      builder: (context, child, controller) =>
          LayoutBuilder(builder: (context, constraints) {
        final widgetWidth = constraints.maxWidth;
        final widgetHeight = constraints.maxHeight;
        final letterTopWidth = (widgetWidth / 2) + 50;

        final leftValue = (widgetWidth +
                _blurRadius -
                ((letterTopWidth + _blurRadius) * controller.value / 1))
            .clamp(letterTopWidth - 100, double.infinity);

        final rightShift = widgetWidth + _blurRadius;
        final rightValue = (rightShift - (rightShift * controller.value / 1))
            .clamp(0.0, double.infinity);

        final opacity = (controller.value - 1).clamp(0, 0.5) / 0.5;

        final isNotIdle = !controller.isIdle;
        return Stack(
          children: <Widget>[
            Container(
              child: child,
            ),
            if (isNotIdle)
              Positioned(
                right: rightValue,
                child: Container(
                  height: widgetHeight,
                  width: widgetWidth,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                        148, 255, 255, 255), // Color ajustado aquí
                    boxShadow: _defaultShadow,
                  ),
                ),
              ),
            if (isNotIdle)
              Positioned(
                left: leftValue,
                child: CustomPaint(
                  size: Size(
                    letterTopWidth,
                    widgetHeight,
                  ),
                  painter: TrianglePainter(
                    strokeColor: theme.dividerColor,
                    color: Color.fromARGB(
                        148, 255, 255, 255), // Color ajustado aquí
                    strokeWidth: 2,
                  ),
                ),
              ),
            if (controller.value >= 1)
              Container(
                padding: const EdgeInsets.only(right: 100),
                child: Transform.scale(
                  scale: controller.value,
                  child: Opacity(
                    opacity: controller.isLoading || controller.state.isSettling
                        ? 1
                        : opacity,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: _circleSize,
                        height: _circleSize,
                        decoration: BoxDecoration(
                          boxShadow: _defaultShadow,
                          color:
                              accent ?? Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).colorScheme.onPrimary,
                                ),
                                value: controller.isLoading ? null : 0,
                              ),
                            ),
                            Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        );
      }),
      child: child,
      onRefresh: onRefresh,
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color? strokeColor;
  final Color color;
  final double strokeWidth;

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  TrianglePainter({
    this.strokeColor = Colors.black,
    this.color =
        const Color.fromARGB(148, 255, 255, 255), // Color ajustado aquí
    this.strokeWidth = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = getTrianglePath(size.width, size.height);

    Paint backgroundPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;
    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha(50)
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(10));
    canvas
      ..drawPath(path, shadowPaint)
      ..drawPath(path, backgroundPaint);

    final strokeColor = this.strokeColor;
    if (strokeColor != null) {
      Paint strokePaint = Paint()
        ..color = strokeColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, strokePaint);
    }
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y / 2)
      ..lineTo(x, 0)
      ..lineTo(x, y)
      ..lineTo(0, y / 2);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
