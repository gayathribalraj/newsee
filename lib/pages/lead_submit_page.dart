import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/leadsubmit/presentation/bloc/lead_submit_bloc.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/personaldetails/presentation/bloc/personal_details_bloc.dart';
import 'package:newsee/pages/rupeeformatter.dart';
import 'package:newsee/widgets/success_bottom_sheet.dart';
import 'package:newsee/widgets/sysmo_title.dart';

class LeadSubmitPage extends StatelessWidget {
  final String title;

  const LeadSubmitPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), automaticallyImplyLeading: false),
      body: BlocConsumer<LeadSubmitBloc, LeadSubmitState>(
        listener: (context, state) {},
        builder: (context, state) {
          PersonalData? personalData;
          ProductMaster? productMaster;
          final personalDetailsBloc = context.watch<PersonalDetailsBloc?>();
          final loanproductBloc = context.watch<LoanproductBloc?>();
          personalData = personalDetailsBloc?.state.personalData;
          productMaster = loanproductBloc?.state.selectedProduct;
          print('personaldata => $personalData');

          return ListView(
            padding: const EdgeInsets.all(16),

            children:
                (personalData != null && productMaster != null)
                    ? showLeadSubmitCard(personalData, productMaster, context)
                    : showNoDataCard(),
          );
        },
      ),
    );
  }

  List<Widget> showLeadSubmitCard(
    PersonalData? personalData,
    ProductMaster? productMaster,
    BuildContext context,
  ) {
    return <Widget>[
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SysmoTitle(
                icon: Icons.face,
                label: "Name",
                value: '${personalData?.firstName} ${personalData?.lastName}',
              ),
              SysmoTitle(
                icon: Icons.person,
                label: "Type",
                value: "Applicant | Existing Customer",
              ),
              SysmoTitle(
                icon: Icons.badge,
                label: "Product",
                value: '${productMaster?.prdCode} - ${productMaster?.prdDesc}',
              ),
              SysmoTitle(icon: Icons.badge, label: "CIF ID", value: "121212"),
              SysmoTitle(
                icon: Icons.currency_rupee,
                label: "Loan Amount",
                value: formatAmount('${personalData?.loanAmountRequested}'),
              ),
              SysmoTitle(
                icon: Icons.location_on,
                label: "Location",
                value: "Chennai",
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 20),
      Center(
        child: ElevatedButton.icon(
          onPressed: () {
            showSuccessBottomSheet(
              context,
              "Submitted",
              "Lead ID : LEAD/202526/00008213",
              "Lead details successfully submitted",
            );
          },
          icon: Icon(Icons.send, color: Colors.white),
          label: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              children: [
                TextSpan(text: 'Push to '),
                TextSpan(text: 'LEND', style: TextStyle(color: Colors.white)),
                TextSpan(
                  text: 'perfect',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
            backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 75, 33, 83),
            ),
          ),
        ),
      ),
    ];
  }

  /* 

incase of incomplete dataentry show no data card

*/

  List<Widget> showNoDataCard() {
    return <Widget>[
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SysmoTitle(
                icon: Icons.close,
                label: "No Data",
                value: 'Please complete Personal and Address Details...!!',
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
