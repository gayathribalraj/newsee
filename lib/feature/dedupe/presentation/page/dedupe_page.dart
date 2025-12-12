import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/page/bottom_sheet_container.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DedupeView extends StatelessWidget {
  final String title;
  DedupeView({required this.title, super.key});

  final dedupeForm = AppForms.DEDUPE_DETAILS_FORM;
  final cifForm = AppForms.CIF_DETAILS_FORM;
  final customerTypeForm = AppForms.CUSTOMER_TYPE_FORM;
  /* 
    @author     : ganeshkumar.b  9/06/2025
    @desc       : Open Existing or New Customer Form BottomSheet
    @param      : null
  */
  void _openModalSheet(
    BuildContext context,
    bool isNewCustomer,
    FormGroup form,
  ) {
    final tabController = DefaultTabController.of(context);
    final dedupebloc = context.read<DedupeBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (BuildContext context) => BlocProvider.value(
            value: dedupebloc,
            child: BottomSheetContainer(
              isNewCustomer: isNewCustomer,
              form: form,
              tabController: tabController,
            ),
          ),
    );
  }

  late BuildContext scaffoldContext;
  @override
  Widget build(BuildContext context) {
    return Kwillpopscope(
      routeContext: context,
      form: customerTypeForm,
      widget: Builder(
        builder: (context) {
          scaffoldContext = context;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Dedupe Details"),
              automaticallyImplyLeading: false,
            ),
            body: BlocConsumer<DedupeBloc, DedupeState>(
              listener:
                  (context, state) => {
                    // if (state.status == DedupeFetchStatus.change)
                    // {callOpenSheet(context, state), print('DedupeFetchStatus')},
                    if (state.status == DedupeFetchStatus.change)
                      {
                        // Open bottom sheet based on current isNewCustomer
                        if (state.isNewCustomer == true)
                          {
                            AppForms.DEDUPE_DETAILS_FORM.reset(),
                            _openModalSheet(
                              context,
                              true,
                              AppForms.DEDUPE_DETAILS_FORM,
                            ),
                          }
                        else
                          {
                            cifForm.reset(),
                            _openModalSheet(
                              context,
                              false,
                              AppForms.CIF_DETAILS_FORM,
                            ),
                          },
                      },
                    if (state.status == DedupeFetchStatus.failure)
                      {
                        showSnack(
                          scaffoldContext,
                          message:
                              state.errorMsg?.isNotEmpty == true
                                  ? state.errorMsg!
                                  : 'No response data from server',
                        ),
                      },
                  },
              builder: (context, state) {
                print("customerTypeForm ${customerTypeForm.value}, $state");
                if (state.status == DedupeFetchStatus.init) {
                  customerTypeForm.reset();
                } else if (state.status == DedupeFetchStatus.success) {
                  customerTypeForm
                      .control('constitution')
                      .updateValue(state.constitution);
                  customerTypeForm
                      .control('constitution')
                      .updateValueAndValidity();
                  customerTypeForm
                      .control('isNewCustomer')
                      .updateValue(state.isNewCustomer);
                  customerTypeForm
                      .control('isNewCustomer')
                      .updateValueAndValidity();
                }
                return ReactiveForm(
                  formGroup: customerTypeForm,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Select Customer Constution",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Colors.grey,
                                    blurStyle: BlurStyle.outer,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ReactiveRadioListTile<String>(
                                    title: const Text('Individual'),
                                    value: 'I',
                                    formControlName: 'constitution',
                                    onChanged: (control) {
                                      if (customerTypeForm.valid) {
                                        context.read<DedupeBloc>().add(
                                          OpenSheetEvent(
                                            request: customerTypeForm.value,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  //   child: Divider(),
                                  // ),
                                  // ReactiveRadioListTile<String>(
                                  //   title: const Text('Non-Individual'),
                                  //   value: 'NI',
                                  //   formControlName: 'constitution',
                                  //   onChanged: (control) {
                                  //     if (customerTypeForm.valid) {
                                  //       context.read<DedupeBloc>().add(
                                  //         OpenSheetEvent(
                                  //           request: customerTypeForm.value,
                                  //         ),
                                  //       );
                                  //     }
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(height: 50),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Select Customer Type",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 130,
                              // height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Colors.grey,
                                    blurStyle: BlurStyle.outer,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ReactiveRadioListTile<bool>(
                                    title: const Text('New Customer'),
                                    value: true,
                                    formControlName: 'isNewCustomer',
                                    onChanged: (control) {
                                      if (customerTypeForm.valid) {
                                        context.read<DedupeBloc>().add(
                                          OpenSheetEvent(
                                            request: customerTypeForm.value,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Divider(),
                                  ),
                                  // ToggleableRadioTile(
                                  //   formControlName: 'isNewCustomer',
                                  //   title: 'Existing Customer',
                                  //   form: customerTypeForm,
                                  // ),
                                  GestureDetector(
                                    onTap: () {
                                      print('clicked Existing Customer');
                                    },
                                    child: ReactiveRadioListTile<bool>(
                                      title: const Text('Existing Customer'),
                                      value: false,
                                      formControlName: 'isNewCustomer',

                                      onChanged: (control) {
                                        if (customerTypeForm.valid) {
                                          context.read<DedupeBloc>().add(
                                            OpenSheetEvent(
                                              request: customerTypeForm.value,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ToggleableRadioTile extends StatelessWidget {
  const ToggleableRadioTile({
    super.key,
    required this.formControlName,
    required this.title,
    required this.form,
  });

  final String formControlName;
  final String title;
  final FormGroup form;

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConsumer(
      builder: (context, form, child) {
        final control = form.control(formControlName) as FormControl<bool?>;
        final isChecked = control.value == false;

        return InkWell(
          onTap: () {
            if (isChecked) {
              // Uncheck
              control.value = null;
            } else {
              // Check and trigger bottom sheet
              control.value = false;
              if (form.valid) {
                context.read<DedupeBloc>().add(
                  OpenSheetEvent(request: form.value),
                );
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              children: [
                Icon(
                  isChecked
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Colors.indigo,
                ),
                const SizedBox(width: 12),
                Text(title, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}
