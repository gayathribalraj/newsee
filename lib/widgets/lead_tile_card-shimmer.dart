/*
 @created on : jun 13 ,2025
 @author : Gayathri.b 
 Description : Custom shimmer card and text widget for displaying individual lead details inside the  card format
*/

import 'package:flutter/material.dart';
import 'package:newsee/widgets/shimmer_runner.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/utils.dart';

class LeadTileCardShimmer extends StatelessWidget {
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

  const  LeadTileCardShimmer({
    Key? key,
    this.title = '',
    this.subtitle = '',
    required this.icon,
    this.color = Colors.teal,
    this.type = '',
    this.product = '',
    this.phone = '',
    this.createdon = '',
    this.location = '',
    this.loanamount = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    child: ShimmerRunner(
                      container: "",
                      isIcon: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerRunner(
                          container: "",
                          isIcon: false,
                        ),
                        SizedBox(height: 10),
                        ShimmerRunner(
                          container: "",
                          isIcon: false,
                        ),
                      ],
                    ),
                  ),
                                    const SizedBox(width: 12),

                  const ShimmerRunner(
                    container: "",
                    isIcon: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: iconWithLabel(Icons.person_2_outlined, type)),
                  SizedBox(width: 10),
                  Expanded(child: iconWithLabel(Icons.badge_outlined, product)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final phoneNumber = "919940362579";
                        final Uri _url = Uri.parse(
                          'https://wa.me/sms:$phoneNumber',
                        );

                        if (!await canLaunchUrl(_url)) {
                          throw 'Could not launch $_url';
                        } else {
                          await launchUrl(_url);
                        }
                        Navigator.pop(context);
                      },
                      child: iconWithLabel(Icons.phone_outlined, phone),
                    ),
                  ),
                  SizedBox(width: 10),
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
                  Expanded(child: iconWithLabel(Icons.location_pin, location)),
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
    );
  }

  Widget iconWithLabel(IconData iconData, String label) {
    return Row(
      children: [
        ShimmerRunner(container: '', isIcon: true),
                  SizedBox(width: 10),
        Flexible(
          child: ShimmerRunner(container: "", isIcon: false),
        ),
      ],
    );
  }
}
