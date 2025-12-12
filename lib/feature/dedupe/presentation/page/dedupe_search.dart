import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_request.dart';
import 'package:newsee/feature/dedupe/domain/model/deduperequest.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/draft/draft_service.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:newsee/widgets/response_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

// Kyc verification Plugin Imports
import 'package:kyc_verification/kyc_validation.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/button_props.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/form_props.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/style_props.dart';

import '../../../../Utils/qr_nav_utils.dart';

class DedupeSearch extends StatelessWidget {
  final FormGroup dedupeForm;
  final TabController tabController;
  final void Function(DedupeState state)? onSuccess;
  DedupeSearch({
    super.key,
    required this.dedupeForm,
    required this.tabController,
    this.onSuccess,
  });

  disposeResponse(context, state) async {
    print("Welcome here for you $state");
    Navigator.of(context).pop();
    if (state.dedupeResponse?.remarksFlag) {
      dedupeForm.reset();
      Navigator.of(context).pop();
      if (tabController.index < tabController.length - 1) {
        tabController.animateTo(tabController.index + 1);
      }
    } else if (state.aadharvalidateResponse != null) {
      dedupeForm.reset();
      Navigator.of(context).pop();
      if (tabController.index < tabController.length - 1) {
        tabController.animateTo(tabController.index + 1);
      }
    }

    if (onSuccess == null) {
      final draftService = DraftService();
      await draftService.saveOrUpdateTabData(
        tabKey: 'dedupe',
        tabData: {
          'aadharvalidateResponse': state.aadharvalidateResponse,
          'isNewCustomer': state.isNewCustomer,
          'constitution': state.constitution,
        },
      );
    }

    if (onSuccess != null) {
      onSuccess!(state);
    }
  }

  @override
  Widget build(context) {
    List<Map<String, dynamic>> dataList;
    return Kwillpopscope(
      routeContext: context,
      form: dedupeForm,
      widget: BlocConsumer<DedupeBloc, DedupeState>(
        listener:
            (context, state) => {
              if (state.status == DedupeFetchStatus.success)
                {
                  /* If aadharvalidateResponse is not null, show the response(name,dob,address etc) 
              in card */
                  if (state.aadharvalidateResponse != null)
                    {
                      dataList = [
                        {
                          "icon": Icons.person,
                          "label": "Name",
                          "value": state.aadharvalidateResponse?.name as String,
                        },
                        {
                          "icon":
                              state.aadharvalidateResponse?.gender == "MALE"
                                  ? Icons.male
                                  : Icons.female,
                          "label": "Gender",
                          "value":
                              state.aadharvalidateResponse?.gender as String,
                        },
                        {
                          "icon": Icons.calendar_month,
                          "label": "DOB",
                          "value":
                              state.aadharvalidateResponse?.dateOfBirth
                                  as String,
                        },
                        {
                          "icon": Icons.contact_phone,
                          "label": "Mobile",
                          "value": state.aadharvalidateResponse?.mobile,
                        },
                        {
                          "icon": Icons.home,
                          "label": "Address",
                          "value":
                              '${state.aadharvalidateResponse?.house} ${state.aadharvalidateResponse?.street} ${state.aadharvalidateResponse?.locality} ${state.aadharvalidateResponse?.vtcName} ${state.aadharvalidateResponse?.postOfficeName}',
                        },
                      ],
                    }
                  else
                    {
                      dataList = [
                        {
                          "icon": Icons.check_box_rounded,
                          "label": "CBS",
                          "value": "true",
                        },
                        {
                          "icon": Icons.assignment_add,
                          "label": "Remarks",
                          "value": state.dedupeResponse?.remarks as String,
                        },
                      ],
                    },
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: ResponseWidget(
                          heightSize:
                              state.aadharvalidateResponse != null ? 0.5 : 0.32,
                          dataList: dataList,
                          buttonshow: true,
                          onpressed:
                              () => disposeResponse(dialogContext, state),
                        ),
                      );
                    },
                  ),
                }
              else if (state.status == DedupeFetchStatus.scan) 
                {
                  dedupeForm.control('aadhaar').updateValue(state.dedupeResponse!.remarks)
                }
              else if (state.status == DedupeFetchStatus.failure)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.errorMsg?.isNotEmpty == true
                            ? state.errorMsg!
                            : 'No response data from server',
                      ),
                    ),
                  ),
                  if (onSuccess != null) {onSuccess!(state)},
                },
            },
        builder: (context, state) {
          return ReactiveForm(
            formGroup: dedupeForm,

            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        "Dedupe Search",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Dropdown(
                          controlName: 'title',
                          label: 'Title',
                          mantatory: dedupeForm
                              .control('title')
                              .validators
                              .contains(RequiredValidator()),
                          items: ['Mr', 'Mrs', 'Miss', 'Others'],
                        ),
                        CustomTextField(
                          controlName: 'firstname',
                          label: 'First Name',
                          mantatory: dedupeForm
                              .control('firstname')
                              .validators
                              .contains(RequiredValidator()),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              AppConstants.NameInputFormatter,
                            ),
                          ],
                        ),
                        CustomTextField(
                          controlName: 'lastname',
                          label: 'Last Name',
                          mantatory: dedupeForm
                              .control('lastname')
                              .validators
                              .contains(RequiredValidator()),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              AppConstants.NameInputFormatter,
                            ),
                          ],
                        ),
                        IntegerTextField(
                          controlName: 'mobilenumber',
                          label: 'Mobile Number',
                          mantatory: dedupeForm
                              .control('mobilenumber')
                              .validators
                              .contains(RequiredValidator()),
                          maxlength: 10,
                          minlength: 10,
                        ),
                        CustomTextField(
                          controlName: 'pan',
                          label: 'PAN Number',
                          mantatory: dedupeForm
                              .control('pan')
                              .validators
                              .contains(RequiredValidator()),
                          maxlength: 10,
                          autoCapitalize: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Z0-9]'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: AadhaarVerification(
                                kycTextBox: KYCTextBox(
                                  fieldKey: GlobalKey(),
                                  validationPattern:
                                      'Please enter a valid AadhaarNumber (e.g. 123456789012)',
                              
                                  formProps: FormProps(
                                    formControlName: 'aadhaar',
                                    label: 'Aadhaar',
                                    mandatory: true,
                                    maxLength: 12,
                                  ),
                                  styleProps: StyleProps(),
                                  apiUrl: '',
                                  buttonProps: ButtonProps(
                                    label: 'verify',
                                    foregroundColor: Colors.white,
                                  ),
                                  isOffline: true,
                                  onSuccess: (value) async {
                                    print('onSuccess ${value.data}');
                                    context.read<DedupeBloc>().add(ValiateAadharFromPluginEvent(
                                      responseData: value
                                    ));
                                  },
                                  onError: (value) {
                                    print(" onerror $value");
                                  },
                                  assetPath: AppConstants.aadhaarResponse,
                                  verificationType: VerificationType.aadhaar,
                                  kycNumber:
                                      dedupeForm.controls['aadhaar']?.value != null
                                          ? dedupeForm.controls['aadhaar']!.value.toString()
                                          : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            // ElevatedButton.icon(
                            //   icon: Icon(Icons.qr_code_scanner),
                            //   label: Text('Scan'),
                            //   onPressed: () => showScannerOptions(context),
                            // ),
                            // Center(
                              // child: 
                            
                              Ink(
                                decoration: ShapeDecoration(
                                  color: Colors.blue,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  onPressed:  () => showScannerOptions(context, 'dedupe'),
                                  icon: Icon(Icons.qr_code)
                                ),
                              )
                            // )
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 3, 9, 110),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            print("Click function passed ${dedupeForm.value}");
                            if (dedupeForm.valid) {
                              print(
                                "Click function passed go here, ${dedupeForm.valid}",
                              );
                              final DedupeRequest
                              request = DedupeRequest().copyWith(
                                aadharCard: dedupeForm.control('aadhaar').value,
                                panCard: dedupeForm.control('pan').value,
                                mobileno:
                                    dedupeForm.control('mobilenumber').value,
                              );

                              context.read<DedupeBloc>().add(
                                FetchDedupeEvent(request: request),
                              );
                            } else {
                              print(
                                "Click function passed go here, ${dedupeForm.valid}",
                              );
                              dedupeForm.markAllAsTouched();
                            }
                          },
                          child:
                              state.status == DedupeFetchStatus.loading
                                  ? CircularProgressIndicator()
                                  : Text("Search"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
