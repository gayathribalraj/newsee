import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CreditScore extends StatelessWidget {
  const CreditScore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(child: Icon(Icons.person)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Credit Score",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            creditScore(),
            const SizedBox(height: 24),
            accountSummary(),
            const SizedBox(height: 24),
            factorsAffectingScore(),
          ],
        ),
      ),
    );
  }

  // Credit score
  Widget creditScore() {
    return Column(
      children: [
        SizedBox(
          height: 220,
          width: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(180, 180),
                painter: CreditScoreCircle(progress: (819 - 300) / 600),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "819",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Excellent",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("300"),
                    SizedBox(width: 160),
                    Text("900"),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "We will remind you in 29 days",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  // Account Summary
  Widget accountSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ACCOUNT SUMMARY",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
            ],
          ),
          child: Column(
            children: [
              summaryRow(
                icon: Icons.credit_card,
                title: "2 Credit Cards",
                value: "₹1,86,994",
                subtitle: "Limit Used",
              ),
              const Divider(),
              summaryRow(
                icon: Icons.account_balance,
                title: "4 Loans",
                value: "₹29,06,217",
                subtitle: "Outstanding",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget summaryRow({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  //  factors card
  Widget factorsAffectingScore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "FACTORS AFFECTING YOUR SCORE",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 12),

        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.9,
          children: [
            factorCard(
              icon: Icons.access_time,
              value: "100%",
              title: "On-time Payments",
              impact: "High Impact",
              status: "EXCELLENT",
              statusColor: Colors.green,
            ),
            factorCard(
              icon: Icons.credit_card,
              value: "29%",
              title: "Credit Utilization",
              impact: "High Impact",
              status: "VERY GOOD",
              statusColor: Colors.lightGreen,
            ),
            factorCard(
              icon: Icons.calendar_today,
              value: "9y 1m",
              title: "Credit Age",
              impact: "Mid Impact",
              status: "EXCELLENT",
              statusColor: Colors.green,
            ),
            factorCard(
              icon: Icons.search,
              value: "0",
              title: "Inquiries",
              impact: "Low Impact",
              status: "EXCELLENT",
              statusColor: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget factorCard({
    required IconData icon,
    required String value,
    required String title,
    required String impact,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            impact,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}


// CustomPainter
class CreditScoreCircle extends CustomPainter {
  final double progress;

  CreditScoreCircle({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;

    final bgPaint =
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20;

    final fgPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFB2F2BB), Color(0xFF2ECC71)],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
