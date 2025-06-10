import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/feature/saveprofilepicture/profilepicturebloc/saveprofilepicture_bloc.dart';
import 'package:newsee/feature/savelead/presentation/bloc/savelead_sourcing_bloc.dart';
import 'package:newsee/pages/address.dart';
import 'package:newsee/pages/check_page.dart';
import 'package:newsee/pages/documents_page.dart';
import 'package:newsee/pages/loan.dart';
import 'package:newsee/pages/loan_details_page.dart';
import 'package:newsee/pages/income_details_page.dart';
import 'package:newsee/pages/kyc_page.dart';
import 'package:newsee/pages/page/dedup_search.dart';
import 'package:newsee/pages/page/dedupe_page.dart';
import 'package:newsee/pages/personal.dart';
import 'package:newsee/pages/personal_details_page.dart';
import 'package:newsee/pages/profileicon.dart';
import 'package:newsee/pages/sourcing_page.dart';
import 'package:newsee/widgets/side_navigation.dart';

class NewLeadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar:
            Globalconfig.isInitialRoute
                ? null
                : AppBar(
                  // leading: IconButton(
                  //   onPressed: () {
                  //     print('');
                  //   },
                  //   icon: Icon(Icons.menu),
                  //   color: Colors.white,
                  // ),
                  // actionsPadding: EdgeInsets.fromLTRB(0, 0, (screenwidth * 0.1), 0),
                  // actions: 
                  // <Widget>[
                  //   ProfileIcon()
                  // ],
                  title: Text(
                    'Lead Details',
                    style: TextStyle(color: Colors.white),
                  ),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(color: Colors.teal),
                  ),
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    tabs: <Widget>[
                      // Tab(icon: Icon(Icons.file_copy, color: Colors.white)),
                      // Tab(icon: Icon(Icons.face, color: Colors.white)),
                      // Tab(icon: Icon(Icons.badge, color: Colors.white)),
                      // Tab(icon: Icon(Icons.wallet, color: Colors.white)),
                      // Tab(icon: Icon(Icons.currency_rupee, color: Colors.white),),
                      // Tab(icon: Icon(Icons.description, color: Colors.white)),
                      // Tab(icon: Icon(Icons.done_all, color: Colors.white)),
                      Tab(icon: Icon(Icons.badge, color: Colors.white)),
                      Tab(icon: Icon(Icons.file_copy, color: Colors.white),),
                      Tab(icon: Icon(Icons.face, color: Colors.white)),
                      Tab(icon: Icon(Icons.location_city, color: Colors.white)),
                      Tab(icon: Icon(Icons.done_all, color: Colors.white)),
                    ],
                  ),
                ),
        drawer: Globalconfig.isInitialRoute ? null : Sidenavigationbar(),
        body: TabBarView(
          children: [
            // SourcingPage('Sourcing', title: 'Sourcing'),
            // PersonalDetailsPage('Personal', title: 'Personal'),
            // KycPage('KYC', title: 'kyc'),
            // IncomeDetailsPage('Income', title: 'Income'),
            // LoanDetailsPage('Loan', title: 'loan'),
            // DocumentsPage('Document', title: 'documents'),
            // CheckPage('Check', title: 'check'),
            // Loan('Loan', title: 'loan'),
            DedupeView('Dedupe', title: 'dedupe'),
            Personal('Personal', title: 'personal'),
            Address('Address', title: 'address'),
            CheckPage('Check', title: 'Lead Details')
          ],
        ),
      ),
    );
  }
}

