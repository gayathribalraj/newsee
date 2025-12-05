/*
 @author     : Gayathri B
   @date       : 28/11/2025
   @desc       : Query Inbox page displaying user queries using OptionsSheet widget.
                Shows a list of queries with recipient name, query type, and date.
              Each query item is displayed as an OptionsSheet with action capability.
 */

import 'package:flutter/material.dart';
import 'package:newsee/widgets/options_sheet.dart';
import 'package:newsee/widgets/side_navigation.dart';
import 'package:newsee/pages/query_details.dart';

class QueryInbox extends StatefulWidget {
  int? tabdata;
  final String? title;
final String? body;


 QueryInbox({Key? key, required this.title, required this.body}) : super(key: key);


  @override
  State<QueryInbox> createState() => QueryInboxState();
}

class QueryInboxState extends State<QueryInbox> {

  @override
  Widget build(BuildContext context) {
    print(widget.body??'no body bro');
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //     child: Text('QueryInbox', style: TextStyle(fontSize: 25)),
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('QueryInbox', style: TextStyle(fontSize: 25)),
              const SizedBox(height: 10),

              OptionsSheet(
                icon: Icons.message,
                title: 'Gayathri',
                subtitle: 'Loan application status',
                status: 'Done',
                details: ['2025-12-01'],
                detailsName:  [Icons.calendar_month],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QueryDetails(
                        userName: 'Gayathri',
                        queryType: 'Loan application status',
                      ),
                    ),
                  );
                },
              ),
              OptionsSheet(
                icon: Icons.message,
                title: 'Siva',
                subtitle: 'Interest rate query',
                status: 'completed',
                details: ['2025-12-03'],
                detailsName:  [Icons.calendar_month],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QueryDetails(
                        userName: 'Siva',
                        queryType: 'Interest rate query',
                      ),
                    ),
                  );
                },
              ),
              OptionsSheet(
                icon: Icons.message,
                title: 'Ramesh',
                subtitle: 'Loan application status',
                status: 'pending',
                details: ['2025-10-03'],
                detailsName:  [Icons.calendar_month],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QueryDetails(
                        userName: 'Ramesh',
                        queryType: 'Loan application status',
                      ),
                    ),
                  );
                },
              ),
              
             widget!.title==""?SizedBox(): OptionsSheet(
                icon: Icons.message,
                title: 'Karthick',
                subtitle: widget.body ?? 'Test',
                status: 'pending',
                details: [DateTime.now().toString().split(' ')[0]],
                detailsName: ['Date'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QueryDetails(
                        userName: 'Karthick',
                        queryType: widget.body ?? 'Test',
                      ),
                    ),
                  );
                },
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
