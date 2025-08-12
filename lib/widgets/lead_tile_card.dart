/*
 @created on : May 7, 2025
 @author : Akshayaa 
 Description : Custom widget for displaying individual lead details in card format with elevation.
*/

import 'package:flutter/material.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadTileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String type;
  final String product;
  final String phone;
  final String createdon;
  final String location;
  final String loanamount;
  final VoidCallback? onTap;
  final bool showarrow;
  final Widget? button;
  final bool ennablePhoneTap;

  const LeadTileCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.color = Colors.teal,
    required this.type,
    required this.product,
    required this.phone,
    required this.createdon,
    required this.location,
    required this.loanamount,
    this.onTap,
    this.showarrow = true,
    this.button,
    this.ennablePhoneTap = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          elevation: 0.5,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white38],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal.shade200,
                              Colors.teal.shade700,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      if (showarrow)
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black,
                        ),
                      if (button != null) button!,
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: iconWithLabel(Icons.person_2_outlined, type),
                      ),
                      Expanded(
                        child: iconWithLabel(Icons.badge_outlined, product),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (!ennablePhoneTap) return;
                            FocusScope.of(context).unfocus();
                            final phoneNumber = "919940362579";
                            final Uri uri = Uri.parse('tel:$phoneNumber');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              throw 'Could not launch $uri';
                            }
                          },
                          child: iconWithLabel(
                            Icons.chrome_reader_mode_outlined,
                            phone,
                          ),
                        ),
                      ),
                      Expanded(
                        child: iconWithLabel(
                          Icons.calendar_month_outlined,
                          createdon,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: iconWithLabel(Icons.location_pin, location),
                      ),
                      Expanded(
                        child: iconWithLabel(
                          Icons.currency_rupee_outlined,
                          formatAmount(loanamount),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget iconWithLabel(IconData iconData, String label) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade400, Colors.teal.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 6),
        Flexible(child: Text(label, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}
