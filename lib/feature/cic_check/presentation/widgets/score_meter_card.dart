import 'package:flutter/material.dart';

class ScoreMeterCard extends StatefulWidget {
  final double score;
  final String label;
  final Duration delay;

  const ScoreMeterCard({
    super.key,
    required this.score,
    required this.label,
    this.delay = const Duration(milliseconds: 500),
  });

  @override
  State<ScoreMeterCard> createState() => ScoreMeterCardState();
}

class ScoreMeterCardState extends State<ScoreMeterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<int> scoreTextAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    double targetPercent = (widget.score / 900).clamp(0.0, 1.0);

    _animation = Tween<double>(
      begin: 0,
      end: targetPercent,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    scoreTextAnimation = IntTween(
      begin: 0,
      end: widget.score.toInt(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Delay before starting animation
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getColor(double score) {
    if (score >= 750) return Colors.green;
    if (score >= 650) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                height: 160,
                width: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(160, 160),
                      painter: ScoreArcPainter(
                        _animation.value,
                        getColor(widget.score),
                      ),
                    ),

                    Text(
                      scoreTextAnimation.value.toString(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      getScoreMeaning(widget.score),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        // );
      },
    );
  }

  String getScoreMeaning(double score) {
    if (score >= 750) return "Excellent";
    if (score >= 650) return "Good";
    if (score >= 500) return "Average";
    return "Poor / No Credit History";
  }
}

class ScoreArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  ScoreArcPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    double stroke = 22; //increase arc thickness here

    Paint base =
        Paint()
          ..color = Colors.grey.shade300
          ..strokeWidth = stroke
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    Paint progressPaint =
        Paint()
          ..color = color
          ..strokeWidth = stroke
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    double radius = size.width / 2;

    // Background circle
    canvas.drawCircle(Offset(radius, radius), radius - stroke, base);

    // Progress Arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius - stroke),
      -90 * 0.0174533,
      progress * 2 * 3.14159,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
