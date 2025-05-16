import 'package:flutter/material.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/pages/address_page.dart';
import 'package:newsee/pages/loan_details_page.dart';
import 'package:newsee/pages/personal_details_page.dart';
import 'package:newsee/pages/sourcing_page.dart';
import 'package:newsee/widgets/side_navigation.dart';

class NewLeadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                  title: Text(
                    'New Lead',
                    style: TextStyle(color: Colors.white),
                  ),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.blue],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(Icons.file_copy, color: Colors.white),
                        child: Text(
                          'Sourcing',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Tab(
                        icon: Icon(Icons.face, color: Colors.white),
                        child: Text(
                          'Personal',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Tab(
                        icon: Icon(Icons.home, color: Colors.white),
                        child: Text(
                          'Address',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.currency_rupee_sharp,
                          color: Colors.white,
                        ),
                        child: Text(
                          'Loan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[],
                ),
        drawer: Globalconfig.isInitialRoute ? null : Sidenavigationbar(),
        body: TabBarView(
          children: [
            SourcingPage(title: 'Sourcing'),
            PersonalDetailsPage(title: 'Personal'),
            AddressPage(title: 'Address'),
            LoanDetailsPage(title: 'LoanDetails'),
          ],
        ),
      ),
    );
  }
}
