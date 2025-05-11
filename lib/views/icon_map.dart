import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> iconMap(
    IconData iconData, Color color, double size) async {
  final pictureRecorder = PictureRecorder();
  final canvas = Canvas(pictureRecorder);
  final double padding = size * 0.15;
  final double totalSize = size + padding * 2;

  final shadowPaint = Paint()
    ..color = Colors.black.withValues(alpha: .3)
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);
  final backgroundPaint = Paint()..color = Colors.white;
  final center = Offset(totalSize / 2, totalSize / 2);
  canvas.drawCircle(center, size /2 + padding / 2, shadowPaint);
  canvas.drawCircle(center, size / 1.5 + padding / 1.5, backgroundPaint);

  final textPainter = TextPainter(textDirection: TextDirection.ltr);
  textPainter.text = TextSpan(
    text: String.fromCharCode(iconData.codePoint),
    style: TextStyle(
      fontSize: size,
      fontFamily: iconData.fontFamily,
      package: iconData.fontPackage,
      color: color,
    ),
  );
  textPainter.layout();
  final offset = Offset(
    (totalSize - textPainter.width) / 2,
    (totalSize - textPainter.height) / 2,
  );
  textPainter.paint(canvas, offset);

  final image = await pictureRecorder
      .endRecording()
      .toImage(totalSize.toInt(), totalSize.toInt());
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  final bytes = byteData!.buffer.asUint8List();

  return BitmapDescriptor.bytes(bytes);
}
