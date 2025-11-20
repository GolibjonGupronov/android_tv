import 'dart:convert';

import 'package:flutter/material.dart';

class ImageFromBase64 extends StatelessWidget {
  final String base64String;
  final double? width;
  final double? height;
  final double? size;
  final BoxFit? fit;

  const ImageFromBase64({super.key, required this.base64String, this.size, this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    try {
      final cleanBase64 = base64String.replaceAll('\n', '').replaceAll('\r', '').replaceAll(' ', '').trim();

      final base64Data = cleanBase64.contains(',') ? cleanBase64.split(',').last : cleanBase64;

      final bytes = base64Decode(base64Data);

      return Image.memory(
        bytes,
        width: size ?? width,
        height: size ?? height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image, size: size ?? 50);
        },
      );
    } catch (e) {
      print('Base64 decode error: $e');
      return Icon(Icons.error, size: size ?? 50);
    }
  }
}
