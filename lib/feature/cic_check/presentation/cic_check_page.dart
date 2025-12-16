import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/cibil_report_utils.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_bloc.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_event.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_state.dart';
import 'package:newsee/feature/cic_check/presentation/widgets/score_meter_card.dart';
import 'package:newsee/widgets/loader.dart';
import 'package:newsee/widgets/sysmo_alert.dart';

class CicCheckPage extends StatelessWidget {
  final Map<String, dynamic>? selectedProp;
  final bool? isApplicantCibilCheck;
  final String? applicantName;
  final bool? isLandCompleted;
  const CicCheckPage({
    super.key,
    this.selectedProp,
    this.applicantName,
    this.isApplicantCibilCheck,
    this.isLandCompleted,
  });

  @override
  Widget build(BuildContext context) {
    // final ValueNotifier<bool> applicantCibilCheck = ValueNotifier(
    //   isApplicantCibilCheck!,
    // );
    final applicantCibilCheck = ValueNotifier<bool>(
      isApplicantCibilCheck ?? false,
    );

    final ValueNotifier<bool> applicantCrifCheck = ValueNotifier(false);
    return BlocProvider(
      create:
          (_) =>
              CicCheckBloc()..add(
                CibilDataFetchFromDBEvent(
                  proposal: selectedProp?['propNo'] ?? "",
                  cibilStatu: isApplicantCibilCheck,
                ),
              ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CIC Check'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: BlocListener<CicCheckBloc, CicCheckState>(
          listener: (context, state) {
            if (state.status == CicCheckStatus.loading) {
              presentLoading(context, AppConstants.creatingCibil);
            } else if (state.status == CicCheckStatus.success) {
              dismissLoading(context);
              applicantCibilCheck.value = state.isApplicantCibilCheck;
              showSnack(context, message: 'Fetched Cibil Details Successfully');
            } else if (state.status == CicCheckStatus.failure) {
              dismissLoading(context);
              showDialog(
                context: context,
                builder:
                    (_) => SysmoAlert(
                      message: AppConstants.FAILED_TO_CHECK_CIBIL_MESSAGE,
                      icon: Icons.error_outline,
                      iconColor: Colors.red,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      buttonText: AppConstants.OK,
                      onButtonPressed: () => Navigator.pop(context),
                    ),
              );
            }
          },
          child: BlocBuilder<CicCheckBloc, CicCheckState>(
            builder: (context, state) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.teal,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppConstants.appLabelApplicant,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if ((selectedProp!['applicantName'] ??
                                                  '')
                                              .isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4,
                                              ),
                                              child: Text(
                                                '${selectedProp!['applicantName']} (${selectedProp!['propNo'] ?? ''})',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                    255,
                                                    58,
                                                    57,
                                                    57,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                if (state.cibilScore != null) ...[
                                  const SizedBox(height: 14),

                                  ScoreMeterCard(
                                    score:
                                        int.tryParse(
                                          state.cibilScore!,
                                        )!.toDouble(),
                                    label: "CIBIL Score",
                                  ),
                                ],
                                const SizedBox(height: 14),
                                ValueListenableBuilder<bool>(
                                  valueListenable: applicantCibilCheck,
                                  builder: (context, cibilChecked, _) {
                                    return ValueListenableBuilder<bool>(
                                      valueListenable: applicantCrifCheck,
                                      builder: (context, crifChecked, _) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                if (!cibilChecked) {
                                                  context
                                                      .read<CicCheckBloc>()
                                                      .add(
                                                        CicFetchEvent(
                                                          proposalData:
                                                              selectedProp,
                                                          reportType: 'cibil',
                                                          applicantType: 'A',
                                                        ),
                                                      );
                                                } else {
                                                  viewCibilHtml(
                                                    context,
                                                    selectedProp?['propNo'],
                                                    'A',
                                                    'cibil',
                                                    state.cibilDataFromTable,
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    cibilChecked
                                                        ? const Color.fromARGB(
                                                          255,
                                                          44,
                                                          193,
                                                          15,
                                                        )
                                                        : const Color.fromARGB(
                                                          255,
                                                          3,
                                                          9,
                                                          110,
                                                        ),
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    cibilChecked
                                                        ? Icons.picture_as_pdf
                                                        : Icons.check,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    cibilChecked
                                                        ? 'View CIBIL'
                                                        : 'Check CIBIL',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                  const SizedBox(height: 180),
                  // navigating to land holding page once get success response show button
                  ValueListenableBuilder<bool>(
                    valueListenable: applicantCibilCheck,
                    builder: (context, cibilChecked, _) {
                      if (!cibilChecked) return const SizedBox.shrink();
                      return Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              context.pushNamed(
                                'landholdings',
                                extra: {
                                  'applicantName':
                                      selectedProp?['applicantName'],
                                  'proposalNumber': selectedProp?['propNo'],
                                  'isCompleted': isLandCompleted,
                                  'custId': selectedProp?['borrCustId'],
                                },
                              );
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text(
                              'Next',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
