import 'package:flutter/material.dart';

class NavCustomPainter extends CustomPainter {
  final s = 0.2;
  final double borderRadius;
  final double shadowBlurRadius;
  final Color shadowColor;

  late double loc;
  late double bottom;
  Color color;
  TextDirection textDirection;

  NavCustomPainter({
    required double startingLoc,
    required int itemsLength,
    required this.color,
    required this.textDirection,
    this.borderRadius = 0.0, // Default to 0 for optional rounded corners
    this.shadowBlurRadius = 0.0, // Default to 0 for optional shadow
    this.shadowColor = Colors.transparent,
  }) {
    final span = 1.0 / itemsLength;
    final l = startingLoc + (span - s) / 2;
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
    bottom = 0.64;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Create the main path with optional rounded corners
    final path = Path()..moveTo(borderRadius > 0 ? borderRadius : 0, 0);

    path.lineTo(size.width * (loc - 0.05), 0);
    path.cubicTo(
      size.width * (loc + s * 0.2), // topX
      size.height * 0.05, // topY
      size.width * loc, // bottomX
      size.height * bottom, // bottomY
      size.width * (loc + s * 0.5), // centerX
      size.height * bottom, // centerY
    );
    path.cubicTo(
      size.width * (loc + s), // bottomX
      size.height * bottom, // bottomY
      size.width * (loc + s * 0.8), // topX
      size.height * 0.05, // topY
      size.width * (loc + s + 0.05),
      0,
    );

    path.lineTo(size.width - (borderRadius > 0 ? borderRadius : 0), 0);

    // Optional rounded corners
    if (borderRadius > 0) {
      path.arcToPoint(
        Offset(size.width, borderRadius),
        radius: Radius.circular(borderRadius),
        clockwise: false,
      );
    }
    path.lineTo(
        size.width, size.height - (borderRadius > 0 ? borderRadius : 0));
    if (borderRadius > 0) {
      path.arcToPoint(
        Offset(size.width - borderRadius, size.height),
        radius: Radius.circular(borderRadius),
        clockwise: false,
      );
    }
    path.lineTo(borderRadius > 0 ? borderRadius : 0, size.height);
    if (borderRadius > 0) {
      path.arcToPoint(
        Offset(0, size.height - borderRadius),
        radius: Radius.circular(borderRadius),
        clockwise: false,
      );
    }
    path.lineTo(0, borderRadius > 0 ? borderRadius : 0);
    if (borderRadius > 0) {
      path.arcToPoint(
        Offset(borderRadius, 0),
        radius: Radius.circular(borderRadius),
        clockwise: false,
      );
    }

    path.close();

    // Optional shadow
    if (shadowBlurRadius > 0) {
      final shadowPaint = Paint()
        ..color = shadowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius);
      canvas.drawPath(
          path.shift(Offset(4, 4)), shadowPaint); // Shift shadow slightly
    }

    // Draw main path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}


// class NavCustomPainter extends CustomPainter {
//   final s = 0.2;

//   late double loc;
//   late double bottom;
//   Color color;
//   TextDirection textDirection;

//   NavCustomPainter({
//     required double startingLoc,
//     required int itemsLength,
//     required this.color,
//     required this.textDirection,
//   }) {
//     final span = 1.0 / itemsLength;
//     final l = startingLoc + (span - s) / 2;
//     loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
//     bottom = 0.64;
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     final path = Path()
//       ..moveTo(0, 0)
//       ..lineTo(size.width * (loc - 0.05), 0)
//       ..cubicTo(
//         size.width * (loc + s * 0.2), // topX
//         size.height * 0.05, // topY
//         size.width * loc, // bottomX
//         size.height * bottom, // bottomY
//         size.width * (loc + s * 0.5), // centerX
//         size.height * bottom, // centerY
//       )
//       ..cubicTo(
//         size.width * (loc + s), // bottomX
//         size.height * bottom, // bottomY
//         size.width * (loc + s * 0.8), // topX
//         size.height * 0.05, // topY
//         size.width * (loc + s + 0.05),
//         0,
//       )
//       ..lineTo(size.width, 0)
//       ..lineTo(size.width, size.height)
//       ..lineTo(0, size.height)
//       ..close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return this != oldDelegate;
//   }
// }
