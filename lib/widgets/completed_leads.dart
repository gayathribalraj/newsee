import 'package:flutter/material.dart';
import 'lead_tile_card.dart';

class CompletedLeads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        LeadTileCard(
          title: "Rajesh",
          subtitle: "1740984324466",
          icon: Icons.person,
          color: Colors.teal,
          phone: "7200517188",
          createdon: "03-03-2025",
          location: "Chennai",
          loanamount: "750000",
        ),
        LeadTileCard(
          title: "Vishal",
          subtitle: "1740984327286",
          icon: Icons.person,
          color: Colors.teal,
          phone: "7200517188",
          createdon: "03-05-2025",
          location: "Chennai",
          loanamount: "840000",
        ),
        LeadTileCard(
          title: "Gaurav",
          subtitle: "1742790445973",
          icon: Icons.person,
          color: Colors.teal,
          phone: "7200517188",
          createdon: "25-03-2025",
          location: "Chennai",
          loanamount: "100000",
        ),
        LeadTileCard(
          title: "Shyam",
          subtitle: "1742905368319",
          icon: Icons.person,
          color: Colors.teal,
          phone: "7200517188",
          createdon: "25-05-2025",
          location: "Chennai",
          loanamount: "125000",
        ),
      ],
    );
  }
}
