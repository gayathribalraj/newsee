/*
 @created on : May 7,2025
 @author : Akshayaa 
 Description : Custom widget for displaying tabs for Pending and Completed Leads
*/

import 'package:flutter/material.dart';
import 'package:newsee/feature/draft/presentation/pages/draft_inbox.dart';
import 'package:newsee/feature/leadInbox/presentation/page/completed_leads.dart';
import 'package:newsee/feature/proposal_inbox/presentation/page/proposal_inbox_leads.dart';
import 'pending_leads.dart';

class LeadTabBar extends StatelessWidget {
  final String searchQuery;
  final TabController? tabController;

  const LeadTabBar({super.key, required this.searchQuery, this.tabController});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.teal,
            child: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "Leads"),
                Tab(text: "Draft"),
                Tab(text: "Applications"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                CompletedLeads(searchQuery: searchQuery),
                DraftInbox(),
                ProposalInbox(searchQuery: searchQuery),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
