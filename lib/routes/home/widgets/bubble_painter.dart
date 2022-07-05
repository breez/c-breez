import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';

const double _kBubbleRadius = 12;

class BubblePainter extends CustomPainter {
  final Size size;

  final bubblePaint = Paint()
    ..color = theme.themeId == "BLUE"
        ? const Color(0xFF0085fb).withOpacity(0.1)
        : const Color(0xff4D88EC).withOpacity(0.1)
    ..style = PaintingStyle.fill;

  BubblePainter(
    this.size,
  );

  @override
  void paint(Canvas canvas, Size size) {
    double height = (size.height - kToolbarHeight);
    canvas.drawCircle(
      Offset(size.width / 2, height * 0.4),
      _kBubbleRadius,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.39, height * 0.6),
      _kBubbleRadius * 1.5,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, height * 0.7),
      _kBubbleRadius * 1.25,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, height * 0.8),
      _kBubbleRadius * 0.75,
      bubblePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
