part of 'wheel.dart';

class SliceBorder {
  final BorderSide side;
  final BorderSide bottom;

  const SliceBorder({
    this.side = BorderSide.none,
    this.bottom = BorderSide.none,
  });
}

/// Draws a slice of a circle. The slice's arc starts at the right (3 o'clock)
/// and moves clockwise as far as specified by angle.
class _CircleSlicePainter extends CustomPainter {
  final Color fillColor;
  final SliceBorder border;
  final double angle;
  final Gradient? gradient;

  const _CircleSlicePainter({
    required this.fillColor,
    this.gradient,
    this.border = const SliceBorder(),
    this.angle = _math.pi / 2,
  }) : assert(angle > 0 && angle < 2 * _math.pi);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = _math.min(size.width, size.height);
    final path = _CircleSlice.buildSlicePath(radius, angle);

    if (gradient != null) {
      canvas.drawPath(
        path,
        Paint()
          ..shader = gradient!.createShader(Rect.fromCircle(
            center: Offset(0, 0),
            radius: radius,
          ))
          ..style = PaintingStyle.fill,
      );
    } else {
      // fill slice area
      canvas.drawPath(
        path,
        Paint()
          ..shader
          ..color = fillColor
          ..style = PaintingStyle.fill,
      );
    }

    // draw slice border
    if (border.side.width > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..color = border.side.color
          ..strokeWidth = border.side.width
          ..style = PaintingStyle.stroke,
      );

      canvas.drawPath(
        Path()
          ..arcTo(
              Rect.fromCircle(
                center: Offset(0, 0),
                radius: radius,
              ),
              0,
              angle,
              false),
        Paint()
          ..color = border.bottom.color
          ..strokeWidth = border.bottom.width * 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_CircleSlicePainter oldDelegate) {
    return angle != oldDelegate.angle ||
        fillColor != oldDelegate.fillColor ||
        border.side != oldDelegate.border.side ||
        border.bottom != oldDelegate.border.bottom;
  }
}
