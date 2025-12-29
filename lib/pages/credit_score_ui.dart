import 'dart:math';
import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/profile.png'),
          ),
        ),
        title: const Text(
          "My Credits",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            creditPi(),
            const SizedBox(height: 24),
            actionButtons(),
            const SizedBox(height: 24),
            summaryCard(),
            const SizedBox(height: 16),
            sectionHeader("Credit Used"),
          ],
        ),
      ),
    );
  }

  // Credit score

  Widget creditPi() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CustomPaint(
            size: const Size(200, 120),
            painter: CreditPainter(),
            child: SizedBox(
              width: 200,
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(height: 20),
                  Text(
                    "819",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  Text("Excellent", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "We will remind you in 29 days",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }


Widget accountSummaryCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "4 Loans",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.orange),
                    SizedBox(width: 6),
                    Icon(Icons.flash_on, color: Colors.orange, size: 18),
                  ],
                ),
              ],
            ),
        
            Text(
              "₹1,86,994",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
        
            Text(
              "Limit Used",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "2 Credit Cards",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.orange),
                    SizedBox(width: 6),
                    Icon(Icons.flash_on, color: Colors.orange, size: 18),
                  ],
                ),
              ],
            ),
        
            Text(
              "₹1,86,994",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
        
            Text(
              "Limit Used",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  // Action Buttons
  Widget actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        ActionItem(icon: Icons.payment, label: "Make Payment"),
        ActionItem(icon: Icons.settings, label: "Manage"),
        ActionItem(icon: Icons.more_horiz, label: "More"),
      ],
    );
  }

  // Summary Card
  Widget summaryCard() {
    final List<SummaryItem> summaryItems = [
      SummaryItem(
        title: "Late Payments",
        value: "0",
        status: "Excellent",
        statusColor: Colors.green,
        icon: Icons.lightbulb_outline,
      ),
      SummaryItem(
        title: "Oldest Account",
        value: "12.4y",
        status: "Good",
        statusColor: Colors.blue,
        icon: Icons.thumb_up_alt_outlined,
      ),
      SummaryItem(
        title: "Credit Usage",
        value: "25%",
        status: "Fair",
        statusColor: Colors.orange,
        icon: Icons.percent,
      ),
      SummaryItem(
        title: "Available Credit",
        value: "\$31,158",
        status: "Poor",
        statusColor: Colors.red,
        icon: Icons.warning_amber_rounded,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Summary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            itemCount: summaryItems.length,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (context, index) {
              final item = summaryItems[index];
              return SummaryItem(
                title: item.title,
                value: item.value,
                status: item.status,
                statusColor: item.statusColor,
                icon: item.icon,
              );
            },
          ),

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {},
              child: const Text("See Overview →"),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextButton(onPressed: () {}, child: const Text("See All")),
      ],
    );
  }
}

//  Widgets

class ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final String status;
  final Color statusColor;
  final IconData icon;

  const SummaryItem({
    required this.title,
    required this.value,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: statusColor, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(fontSize: 11, color: statusColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Custom Painter

class CreditPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final bgPaint =
        Paint()
          ..color = Colors.grey.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20
          ..strokeCap = StrokeCap.square;

    final fgPaint =
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      bgPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      pi * 01,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
