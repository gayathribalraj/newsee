import 'package:flutter/material.dart';

class ButtonFrame extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const ButtonFrame({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  _FramerButtonState createState() => _FramerButtonState();
}

class _FramerButtonState extends State<ButtonFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;
        return GestureDetector(
          onTap: widget.onPressed,
          child: CustomPaint(
            painter: GradientBorderPainter(value),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(38),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: Colors.black87, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    widget.text,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final double animationValue;

  GradientBorderPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(38));
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..shader = LinearGradient(
            begin: Alignment(-1 + animationValue * 2, -1 + animationValue * 2),
            end: Alignment(1 + animationValue * 2, 1 + animationValue * 2),
            colors: const [Colors.purple, Colors.orange, Colors.purple],
          ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(GradientBorderPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;
}
