import 'package:flutter/material.dart';
import 'dart:io';

class BackgroundImage extends StatelessWidget {
  final String imagePath;

  BackgroundImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: imagePath.startsWith('/data/')
          ? Image.file(
              File(imagePath),
              fit: BoxFit.cover, // Asegúrate de que cubra toda la pantalla
            )
          : Image.asset(
              imagePath,
              fit: BoxFit.cover, // Asegúrate de que cubra toda la pantalla
            ),
    );
  }
}
