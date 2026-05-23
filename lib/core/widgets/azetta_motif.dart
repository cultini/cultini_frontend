import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// ─── Azetta geometric motif ("talwt") ─────────────────────────────────────────
/// Pure-presentation Amazigh-inspired diamond / zigzag pattern. No assets, no
/// dependencies — drawn with a [CustomPainter] and tinted from the theme so it
/// can be reused at low opacity as a divider band or a faint background texture.

/// Paints a repeating row (or grid) of nested losanges with zigzag edges.
class TalwtMotifPainter extends CustomPainter {
  const TalwtMotifPainter({
    this.color = AppColors.motif,
    this.opacity = 0.10,
    this.cell = 22.0,
    this.strokeWidth = 1.2,
    this.tileVertically = false,
  });

  /// Base tint of the motif.
  final Color color;

  /// Overall opacity applied to the stroke.
  final double opacity;

  /// Width/height of a single diamond cell, in logical pixels.
  final double cell;

  /// Line thickness.
  final double strokeWidth;

  /// When true the motif repeats down the full height (background texture);
  /// otherwise a single centered band is drawn (divider).
  final bool tileVertically;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.miter;

    final half = cell / 2;
    final rows = tileVertically ? (size.height / cell).ceil() + 1 : 1;
    final cols = (size.width / cell).ceil() + 1;
    final baseTop = tileVertically ? 0.0 : (size.height - cell) / 2;

    for (var r = 0; r < rows; r++) {
      final cy = baseTop + r * cell + half;
      for (var c = 0; c < cols; c++) {
        final cx = c * cell + half;
        _drawCell(canvas, paint, Offset(cx, cy), half);
      }
    }
  }

  /// One motif cell: an outer diamond, an inner diamond, and a central cross —
  /// the characteristic "talwt" losange.
  void _drawCell(Canvas canvas, Paint paint, Offset center, double r) {
    final outer = Path()
      ..moveTo(center.dx, center.dy - r)
      ..lineTo(center.dx + r, center.dy)
      ..lineTo(center.dx, center.dy + r)
      ..lineTo(center.dx - r, center.dy)
      ..close();
    canvas.drawPath(outer, paint);

    final ir = r * 0.5;
    final inner = Path()
      ..moveTo(center.dx, center.dy - ir)
      ..lineTo(center.dx + ir, center.dy)
      ..lineTo(center.dx, center.dy + ir)
      ..lineTo(center.dx - ir, center.dy)
      ..close();
    canvas.drawPath(inner, paint);

    // Diagonal cross through the centre.
    final t = r * 0.32;
    canvas.drawLine(
      Offset(center.dx - t, center.dy - t),
      Offset(center.dx + t, center.dy + t),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + t, center.dy - t),
      Offset(center.dx - t, center.dy + t),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant TalwtMotifPainter old) =>
      old.color != color ||
      old.opacity != opacity ||
      old.cell != cell ||
      old.strokeWidth != strokeWidth ||
      old.tileVertically != tileVertically;
}

/// A thin horizontal band of the talwt motif — use as an on-theme divider.
class AzettaDivider extends StatelessWidget {
  const AzettaDivider({
    super.key,
    this.height = 18,
    this.color = AppColors.motif,
    this.opacity = 0.16,
    this.cell = 16,
  });

  final double height;
  final Color color;
  final double opacity;
  final double cell;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: TalwtMotifPainter(color: color, opacity: opacity, cell: cell),
      ),
    );
  }
}

/// A faint full-area motif texture, meant to sit behind content.
class AzettaBackground extends StatelessWidget {
  const AzettaBackground({
    super.key,
    required this.child,
    this.color = AppColors.motif,
    this.opacity = 0.05,
    this.cell = 26,
  });

  final Widget child;
  final Color color;
  final double opacity;
  final double cell;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TalwtMotifPainter(
        color: color,
        opacity: opacity,
        cell: cell,
        tileVertically: true,
      ),
      child: child,
    );
  }
}
