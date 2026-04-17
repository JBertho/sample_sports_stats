import 'package:flutter/material.dart';

class CourtBackground extends StatelessWidget {
  static const double aspectRatio = 2551 / 1393;
  final Widget? child;

  const CourtBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _ParquetPainter()),
          Image.asset('assets/court_bg.png', fit: BoxFit.fill),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _ParquetPainter extends CustomPainter {
  static const Color _woodLight = Color(0xFFD9A86B);
  static const Color _woodDark = Color(0xFFB2824A);
  static const Color _plankLine = Color(0x33000000);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Fond bois avec un léger gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_woodLight, _woodDark],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // Planches horizontales (rangées)
    const plankHeight = 28.0;
    final linePaint = Paint()
      ..color = _plankLine
      ..strokeWidth = 1.0;

    for (double y = plankHeight; y < size.height; y += plankHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Séparations verticales décalées pour imiter un vrai parquet
    const plankWidth = 110.0;
    int row = 0;
    for (double y = 0; y < size.height; y += plankHeight) {
      final offsetX = (row.isEven ? 0.0 : plankWidth / 2);
      for (double x = offsetX; x < size.width; x += plankWidth) {
        canvas.drawLine(
          Offset(x, y),
          Offset(x, y + plankHeight),
          linePaint,
        );
      }
      row++;
    }
  }

  @override
  bool shouldRepaint(covariant _ParquetPainter oldDelegate) => false;
}
