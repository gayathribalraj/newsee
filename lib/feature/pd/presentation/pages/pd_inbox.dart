/*
  @author     : karthick.d /06/2025
  @desc       : Stateless widget that renders a list of proposals for Personal Discussion
                It dispatches a SearchLeadEvent on initialization and listens to state changes.
                Based on the state (loading, success, or failure), it renders:
                - Shimmer loading cards while waiting,    
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/pd/domain/modal/pd_inbox_request.dart';
import 'package:newsee/feature/pd/presentation/bloc/pd_inbox_bloc.dart';
import 'package:newsee/feature/pd/presentation/pages/assessment_page.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/application_status_response.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/group_proposal_inbox.dart';
import 'package:newsee/feature/cic_check/presentation/cic_check_page.dart';
import 'package:newsee/widgets/bottom_sheet.dart';
import 'package:newsee/widgets/options_sheet.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:newsee/widgets/lead_tile_card-shimmer.dart';
import 'package:newsee/widgets/lead_tile_card.dart';

class PDInbox extends StatelessWidget {
  final String searchQuery;
  var currentPage = 1;
  PDInbox({super.key, required this.searchQuery});

  showAlert(context, message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => SysmoAlert.failure(
            message: message.toString(),
            onButtonPressed: () {
              Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              PDInboxBloc()..add(
                PDInboxFetchEvent(
                  request: PdInboxRequest(userId: '', token: ''),
                ),
              ),
      child: BlocConsumer<PDInboxBloc, PDInboxState>(
        listener: (context, state) {
          if (state.applicationStatus == SaveStatus.success) {
            // _showBottomSheet(context, proposal['lpdPropNo']);
          } else if (state.applicationStatus == SaveStatus.failure) {
            showAlert(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          final globalLoadingBloc = context.read<GlobalLoadingBloc>();
          Future<void> onRefresh() async {
            context.read<PDInboxBloc>().add(
              PDInboxFetchEvent(
                request: PdInboxRequest(
                  userId: '',
                  token: '',
                  pageNo: state.currentPage,
                ),
              ),
            );
          }

          if (state.status == PDInboxStatus.loading) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return LeadTileCardShimmer(
                    icon: Icons.person,
                    color: Colors.teal,
                  );
                },
              ),
            );
          }

          if (state.status == PDInboxStatus.failure) {
            return renderWhenNoItems(onRefresh, state, context);
          }

          if (state.applicationStatus == SaveStatus.loading) {
            globalLoadingBloc.add(ShowLoading(message: 'Fetching Status...'));
          } else {
            globalLoadingBloc.add(HideLoading());
          }

          final List<GroupProposalInbox>? allLeads =
              state.proposalResponseModel;

          // logic for search functionaluty , when user type search query
          // in searchbar
          List<GroupProposalInbox>? filteredLeads = onSearchApplicationInbox(
            items: allLeads,
            searchQuery: searchQuery,
          );
          if (filteredLeads == null || filteredLeads.isEmpty) {
            return renderWhenNoItems(onRefresh, state, context);
          } else {
            // final totalPages = (filteredLeads.length / itemsPerPage).ceil();
            return renderItems(state, filteredLeads, onRefresh, context);
          }

          // comments
        },
      ),
    );
  }

  RefreshIndicator renderItems(
    PDInboxState state,
    List<GroupProposalInbox> filteredLeads,
    Future<void> Function() onRefresh,
    BuildContext context,
  ) {
    final currentPage = state.currentPage;
    print("currentPage: $currentPage");
    final int pageCount = 20;
    final int totalNumberOfApplication = state.totalProposalApplication.toInt();
    final int numberOfpages = (totalNumberOfApplication / pageCount).ceil();
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredLeads.length,
              itemBuilder: (context, index) {
                final proposal = filteredLeads[index].finalList;
                return LeadTileCard(
                  title:
                      proposal['proposalName']?.toString().isNotEmpty == true
                          ? "${proposal['firstName']} ${proposal['lastName']}"
                          : 'Name is Empty',
                  subtitle: proposal['proposalNumber'] ?? 'N/A',
                  icon: Icons.person,
                  color: Colors.teal,
                  type: proposal['proposalStatus'] ?? 'N/A',
                  product: proposal['schemeName'] ?? 'N/A',
                  phone: proposal['mobileNumber'] ?? 'N/A',
                  createdon: proposal['createdDate'] ?? 'N/A',
                  // location: proposal['branchName'] ?? 'N/A',
                  location: proposal['distance'] != null 
                      ? '${(proposal['distance'] / 1000).toStringAsFixed(2)} km away'
                      : 'N/A',
                  loanamount: proposal['loanAmount']?.toString() ?? '',
                  onTap: () {
                    // context.read<PDInboxBloc>().add(
                    //   ApplicationStatusCheckEvent(currentApplication: proposal),
                    // );
                    _showBottomSheet(context, proposal['proposalNumber']);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: NumberPaginator(
              numberPages: numberOfpages,
              initialPage: currentPage,
              onPageChange: (int index) {
                context.read<PDInboxBloc>().add(
                  SearchProposalInboxEvent(
                    request: LeadInboxRequest(
                      userid: '',
                      token: '',
                      pageNo: index,
                      pageCount: 20,
                    ),
                  ),
                );
              },

              child: const SizedBox(
                width: 250,
                height: 35,
                child: Row(
                  children: [
                    PrevButton(),
                    Expanded(child: NumberContent()),
                    NextButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  RefreshIndicator renderWhenNoItems(
    Future<void> Function() onRefresh,
    PDInboxState state,
    BuildContext context,
  ) {
    final currentPage = state.currentPage;
    print("currentPage: $currentPage");
    final int pageCount = 20;
    final int totalNumberOfApplication = state.totalProposalApplication.toInt();
    final int numberOfpages = (totalNumberOfApplication / pageCount).ceil();
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 200),
                Center(
                  child: Text(
                    state.errorMessage ?? AppConstants.GLOBAL_NO_DATA_FOUND,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: NumberPaginator(
              numberPages: numberOfpages,
              initialPage: currentPage,
              onPageChange: (int index) {
                context.read<PDInboxBloc>().add(
                  PDInboxFetchEvent(
                    request: PdInboxRequest(
                      userId: '',
                      token: '',
                      pageNo: index,
                      pageCount: 20,
                      orgId: [],
                    ),
                  ),
                );
              },

              child: const SizedBox(
                width: 250,
                height: 35,
                child: Row(
                  children: [
                    PrevButton(),
                    Expanded(child: NumberContent()),
                    NextButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String proposal) {
    openBottomSheet(context, 0.6, 0.4, 0.9, (context, scrollController) {
      return SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            const SizedBox(height: 12),
            OptionsSheet(
              icon: Icons.document_scanner,
              title: "PD Assessment",
              subtitle: "PD Assessment Details",
              status: 'pending',
              onTap: () {
                context.pop();
                print('selectedProp: $proposal');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            AssessmentHomePage(proposalNumber: proposal),
                  ),
                );
              },
            ),
            OptionsSheet(
              icon: Icons.description,
              title: "Document Upload",
              subtitle: "Pre-Sanctioned Documents Upload",
              status: 'pending',
              onTap: () {
                context.pop();
                context.pushNamed(
                  'document',
                  extra: {'proposal': proposal, 'fromPage': 'pd'},
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
