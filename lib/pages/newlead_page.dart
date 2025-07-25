import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/coapplicant/presentation/page/coapp_page.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/page/dedupe_page.dart';
import 'package:newsee/feature/leadInbox/domain/modal/get_lead_response.dart';
import 'package:newsee/feature/leadsubmit/presentation/bloc/lead_submit_bloc.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';
import 'package:newsee/feature/personaldetails/presentation/bloc/personal_details_bloc.dart';
import 'package:newsee/pages/address.dart';
import 'package:newsee/pages/lead_submit_page.dart';
import 'package:newsee/pages/loan.dart';
import 'package:newsee/pages/personal.dart';
import 'package:newsee/widgets/side_navigation.dart';
import 'package:newsee/widgets/sysmo_alert.dart';

class NewLeadPage extends StatelessWidget {
  final GetLeadResponse? fullLeadData;
  NewLeadPage({this.fullLeadData});

  @override
  Widget build(BuildContext context) {
    print("newlead page- fullLeadData $fullLeadData");
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  LoanproductBloc()..add(
                    fullLeadData == null
                        ? LoanproductInit(
                          loanproductState: LoanproductState.init(),
                        )
                        : LoanproductFetchEvent(
                          leadDetails: fullLeadData?.LeadDetails,
                        ),
                  ),
        ),
        BlocProvider(create: (context) => DedupeBloc()),
        BlocProvider(
          create:
              (context) =>
                  PersonalDetailsBloc()..add(
                    fullLeadData == null
                        ? PersonalDetailsInitEvent(cifResponseModel: null)
                        : PersonalDetailsFetchEvent(
                          leadDetails: fullLeadData?.LeadDetails,
                        ),
                  ),
          lazy: false,
        ),
        BlocProvider(
          create:
              (context) =>
                  AddressDetailsBloc()..add(
                    fullLeadData == null
                        ? AddressDetailsInitEvent(cifResponseModel: null)
                        : AddressDetailsFetchEvent(
                          leadAddressDetails: fullLeadData?.LeadAddressDetails,
                        ),
                  ),
          lazy: false,
        ),
        BlocProvider(
          create:
              (context) =>
                  CoappDetailsBloc()..add(
                    fullLeadData == null
                        ? CoAppDetailsInitEvent()
                        : CoApplicantandGurantorFetchEvent(
                          leadDetails: fullLeadData?.LeadDetails,
                        ),
                  ),
          lazy: false,
        ),
        BlocProvider(create: (context) => LeadSubmitBloc()),
      ],
      child: DefaultTabController(
        length: fullLeadData == null ? 6 : 4,
        child: Scaffold(
          appBar:
              Globalconfig.isInitialRoute
                  ? null
                  : AppBar(
                    title: const Text(
                      'Lead Details',
                      style: TextStyle(color: Colors.white),
                    ),
                    flexibleSpace: Container(
                      decoration: const BoxDecoration(color: Colors.teal),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(60.0),
                      child: Builder(
                        builder: (context) {
                          final loanState =
                              context.watch<LoanproductBloc>().state;
                          final dedupeState = context.watch<DedupeBloc>().state;

                          final personalState =
                              context.watch<PersonalDetailsBloc>().state;
                          final addressState =
                              context.watch<AddressDetailsBloc>().state;

                          final coappState =
                              context.watch<CoappDetailsBloc>().state;

                          final TabController tabController =
                              DefaultTabController.of(context);

                          return TabBar(
                            controller: tabController,
                            indicatorColor: Colors.white,
                            indicatorWeight: 3,
                            onTap: (index) {
                              final firstStatusList = [
                                loanState.status,
                                dedupeState.status,
                                personalState.status,
                                addressState.status,
                                // coappState.status,
                              ];

                              final getstatusList = [
                                loanState.status,
                                personalState.status,
                                addressState.status,
                              ];

                              final statusList =
                                  fullLeadData == null
                                      ? firstStatusList
                                      : getstatusList;

                              bool canNavigate = true;
                              for (int i = 0; i < index; i++) {
                                if (statusList[i] != SaveStatus.success &&
                                    statusList[i] !=
                                        DedupeFetchStatus.success) {
                                  canNavigate = false;
                                  break;
                                }
                              }
                              if (!canNavigate) {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => SysmoAlert.warning(
                                        message:
                                            "Please complete the previous step before processing.",
                                        onButtonPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                );

                                Future.microtask(() {
                                  tabController.index =
                                      tabController.previousIndex;
                                });

                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Row(
                                //       children: [
                                //         Icon(
                                //           Icons.warning_amber_rounded,
                                //           color: Colors.white,
                                //         ),
                                //         SizedBox(width: 12),
                                //         Expanded(
                                //           child: Text(
                                //             "Please complete the previous step before processing.",
                                //             style: TextStyle(
                                //               color: Colors.white,
                                //               fontSize: 15,
                                //               fontWeight: FontWeight.w500,
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //     backgroundColor: Colors.teal,

                                //     behavior: SnackBarBehavior.floating,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(12),
                                //     ),
                                //     margin: const EdgeInsets.symmetric(
                                //       horizontal: 20,
                                //       vertical: 16,
                                //     ),
                                //     padding: const EdgeInsets.symmetric(
                                //       horizontal: 20,
                                //       vertical: 16,
                                //     ),
                                //     duration: const Duration(seconds: 2),
                                //   ),
                                // );
                              }
                            },
                            tabs:
                                fullLeadData == null
                                    ? <Widget>[
                                      statusTabBar(
                                        icon: Icons.badge,
                                        isComplete:
                                            loanState.status ==
                                            SaveStatus.success,
                                      ),
                                      statusTabBar(
                                        icon: Icons.file_copy,
                                        isComplete:
                                            dedupeState.status ==
                                            DedupeFetchStatus.success,
                                      ),
                                      statusTabBar(
                                        icon: Icons.face,
                                        isComplete:
                                            personalState.status ==
                                            SaveStatus.success,
                                      ),
                                      statusTabBar(
                                        icon: Icons.location_city,
                                        isComplete:
                                            addressState.status ==
                                            SaveStatus.success,
                                      ),
                                      statusTabBar(
                                        icon: Icons.add_reaction,
                                        isComplete:
                                            coappState.status ==
                                            SaveStatus.success,
                                      ),
                                      Tab(
                                        icon: Icon(
                                          Icons.done_all,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ]
                                    : <Widget>[
                                      statusTabBar(
                                        icon: Icons.badge,
                                        isComplete:
                                            loanState.status ==
                                            SaveStatus.success,
                                      ),
                                      statusTabBar(
                                        icon: Icons.face,
                                        isComplete:
                                            personalState.status ==
                                            SaveStatus.success,
                                      ),
                                      statusTabBar(
                                        icon: Icons.location_city,
                                        isComplete:
                                            addressState.status ==
                                            SaveStatus.success,
                                      ),
                                      statusTabBar(
                                        icon: Icons.add_reaction,
                                        isComplete:
                                            coappState.status ==
                                            SaveStatus.success,
                                      ),
                                    ],
                          );
                        },
                      ),
                    ),
                  ),
          drawer:
              Globalconfig.isInitialRoute
                  ? null
                  : Sidenavigationbar(pageContext: context),
          body: TabBarView(
            children:
                fullLeadData == null
                    ? [
                      Loan(title: 'loan'),
                      DedupeView(title: 'dedupe'),
                      Personal(title: 'personal'),
                      Address(title: 'address'),
                      CoApplicantPage(title: 'Co Applicant Details'),
                      LeadSubmitPage(title: 'Lead Details'),
                    ]
                    : [
                      Loan(title: 'loan'),
                      Personal(title: 'personal'),
                      Address(title: 'address'),
                      CoApplicantPage(title: 'Co Applicant Details'),
                    ],
          ),
        ),
      ),
    );
  }

  Tab statusTabBar({required IconData icon, required bool isComplete}) {
    return Tab(
      icon: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isComplete ? Colors.white : Colors.white70),
            if (isComplete)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(Icons.check_circle, size: 14, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
