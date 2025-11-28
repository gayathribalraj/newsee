import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:newsee/AppData/app_constants.dart';

import 'package:sysmo_verification/kyc_validation.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/draft/draft_service.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/personaldetails/presentation/bloc/personal_details_bloc.dart';
import 'package:newsee/widgets/SearchableMultiSelectDropdown.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';

class Personal extends StatelessWidget {
  final String title;
  // scrollcontroller is required to scroll to errorformfield
  final _scrollController = ScrollController();
  Personal({required this.title, super.key});

  final FormGroup form = AppForms.GET_PERSONAL_DETAILS_FORM();
  final _titleKey = GlobalKey();
  final _firstNameKey = GlobalKey();
  final _middleNameKey = GlobalKey();
  final _lastNameKey = GlobalKey();
  final _dobKey = GlobalKey();
  final _residentialStatusKey = GlobalKey();
  final _primaryMobileNumberKey = GlobalKey();
  final _secondaryMobileNumberKey = GlobalKey();
  final _emailKey = GlobalKey();
  final _aadhaarKey = GlobalKey();
  // final _aadhaarRefNo = GlobalKey();
  final _loanAmountRequestedKey = GlobalKey();
  final _natureOfActivityKey = GlobalKey();
  final _occupationTypeKey = GlobalKey();
  final _agriculturistTypeKey = GlobalKey();
  final _farmerCategoryKey = GlobalKey();
  final _farmerTypeKey = GlobalKey();
  final _religionKey = GlobalKey();
  final _casteKey = GlobalKey();
  final _genderKey = GlobalKey();
  final _subActivityKey = GlobalKey();
  final _voteridKey = GlobalKey();
  final _panKey = GlobalKey();
  final _gstKey = GlobalKey();
  final _passportKey = GlobalKey();
  // final _aadhaarNumberKey = GlobalKey();
  bool refAadhaar = true;
  // bool isVerified = false;

  /* 
    @author     : ganeshkumar.b  13/06/2025
    @desc       : map Aadhaar response in personal form
    @param      : {AadharvalidateResponse val} - aadhaar response
  */
  mapAadhaarData(val) {
    try {
      if (val != null) {
        // form.control('aadharRefNo').updateValue(val?.referenceId);
        refAadhaar = true;
        if (val.name != null) {
          String fullname = val?.name;
          List getNameArray = fullname.split(' ');
          if (getNameArray.length > 2) {
            String fullname = getNameArray.sublist(2).join();
            form.control('firstName').updateValue(getNameArray[0]);
            form.control('middleName').updateValue(getNameArray[1]);
            form.control('lastName').updateValue(fullname);
          } else if (getNameArray.length == 2) {
            form.control('firstName').updateValue(getNameArray[0]);
            form.control('lastName').updateValue(getNameArray[1]);
          } else if (getNameArray.length == 1) {
            form.control('firstName').updateValue(getNameArray[0]);
          }
        }
        final formattedDate = getDateFormatedByProvided(
          val?.dateOfBirth!,
          from: AppConstants.Format_dd_MM_yyyy,
          to: AppConstants.Format_yyyy_MM_dd,
        );
        print('formattedDate in personal page => $formattedDate');

        form.control('dob').updateValue(formattedDate);
        form.control('email').updateValue(val?.email!);
      }
    } catch (error) {
      print("autoPopulateData-catch-error $error");
    }
  }

  /* 
    @author     : ganeshkumar.b  13/06/2025
    @desc       : map cif response in personal form
    @param      : {CifResponse val} - cifresponse
  */
  mapCifDate(val) {
    datamapperCif(val);
  }

  void datamapperCif(val) {
    try {
      form.control('firstName').updateValue(val.lleadfrstname!);
      form.control('middleName').updateValue(val.lleadmidname!);
      form.control('lastName').updateValue(val.lleadlastname!);
      form.control('dob').updateValue(getDateFormat(val.lleaddob!));
      form.control('primaryMobileNumber').updateValue(val.lleadmobno!);
      form.control('email').updateValue(val.lleademailid!);

      if (val.lleadadharno != null) {
        form.control('aadhaar').updateValue(val.lleadadharno);
      }
      if (val.lleadpanno != null) {
        form.control('pan').updateValue(val.lleadpanno);
      }
      if(val.lleadvoterid != null) {
        form.control('voterid').updateValue(val.lleadvoterid);
      }
      if(val.lleadgstin != null) {
        form.control('gst').updateValue(val.lleadgstin);
      }
      if(val.lleadpassportno != null) {
        form.control('passport').updateValue(val.lleadpassportno);
      }
    } catch (error) {
      print("autoPopulateData-catch-error $error");
    }
  }

  mapPersonalData(val) {
    try {
      form.control('title').updateValue(val['title']);
      form.control('firstName').updateValue(val['firstName']);
      form.control('middleName').updateValue(val['middleName']);
      form.control('lastName').updateValue(val['lastName']);
      form.control('dob').updateValue(getDateFormat(val['dob']));
      form.control('residentialStatus').updateValue(val['residentialStatus']);
      form
          .control('primaryMobileNumber')
          .updateValue(val['primaryMobileNumber']);
      form
          .control('secondaryMobileNumber')
          .updateValue(val['secondaryMobileNumber']);
      form.control('email').updateValue(val['email']);

      form
          .control('secondaryMobileNumber')
          .updateValue(val['secondaryMobileNumber']);
      form
          .control('loanAmountRequested')
          .updateValue(val['loanAmountRequested']);
      form.control('natureOfActivity').updateValue(val['natureOfActivity']);
      form.control('occupationType').updateValue(val['occupationType']);
      form.control('agriculturistType').updateValue(val['agriculturistType']);
      form.control('farmerCategory').updateValue(val['farmerCategory']);
      form.control('farmerType').updateValue(val['farmerType']);
      form.control('religion').updateValue(val['religion']);
      form.control('caste').updateValue(val['caste']);
      form.control('gender').updateValue(val['gender']);
      form.control('subActivity').updateValue(val['subActivity']);
      form.control('aadhaar').updateValue(val['aadhaar']);
      form.control('pan').updateValue(val['pan']);
      form.control('voterid').updateValue(val['voterid']);
      form.control('gst').updateValue(val['gst']);
      form.control('passport').updateValue(val['passport']);


      final leadref = DraftService().getCurrentLeadRef();
      if (leadref == '' && leadref.isEmpty) {
        form.markAsDisabled();
      }
    } catch (error) {
      print("mapPersonalData-catch-error $error");
    }
  }

  /* 
    @author : karthick.d  
    @desc   : scroll to error field which identified first in the widget tree
              
   */

  void scrollToErrorField() async {
    final fields = [
      {'key': _titleKey, 'controlName': 'title'},
      {'key': _firstNameKey, 'controlName': 'firstName'},
      {'key': _middleNameKey, 'controlName': 'middleName'},
      {'key': _lastNameKey, 'controlName': 'lastName'},
      {'key': _dobKey, 'controlName': 'dob'},
      {'key': _primaryMobileNumberKey, 'controlName': 'primaryMobileNumber'},
      {
        'key': _secondaryMobileNumberKey,
        'controlName': 'secondaryMobileNumber',
      },
      {'key': _emailKey, 'controlName': 'email'},
      {'key': _aadhaarKey, 'controlName': 'aadhaar'},
      {'key': _loanAmountRequestedKey, 'controlName': 'loanAmountRequested'},
      {'key': _residentialStatusKey, 'controlName': 'residentialStatus'},
      {'key': _natureOfActivityKey, 'controlName': 'natureOfActivity'},
      {'key': _occupationTypeKey, 'controlName': 'occupationType'},
      {'key': _agriculturistTypeKey, 'controlName': 'agriculturistType'},
      {'key': _farmerCategoryKey, 'controlName': 'farmerCategory'},
      {'key': _farmerTypeKey, 'controlName': 'farmerType'},
      {'key': _religionKey, 'controlName': 'religion'},
      {'key': _casteKey, 'controlName': 'caste'},
      {'key': _genderKey, 'controlName': 'gender'},
      {'key': _subActivityKey, 'controlName': 'subActivity'},
      {'key': _gstKey, 'controlName': 'gst'},
      {'key': _voteridKey, 'controlName': 'voterid'},
      {'key': _passportKey, 'controlName': 'passport'},
      {'key': _panKey, 'controlName': 'pan'},
    ];

    for (var field in fields) {
      final control = form.control(field['controlName'] as String);
      if (control.invalid && control.touched) {
        final context = (field['key'] as GlobalKey).currentContext;
        if (context != null) {
          await Scrollable.ensureVisible(
            context,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.1,
          );
          control.focus();
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Kwillpopscope(
      routeContext: context,
      form: form,
      widget: Scaffold(
        appBar: AppBar(
          title: Text("Personal Details"),
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<PersonalDetailsBloc, PersonalDetailsState>(
          listener: (context, state) {
            print(
              'personaldetail::BlocConsumer:listen => ${state.lovList} ${state.personalData} ${state.status?.name}',
            );
            if (state.status == SaveStatus.success &&
                (state.getLead == false || state.getLead == null)) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => SysmoAlert.success(
                      message: "Personal Details Saved Successfully",
                      onButtonPressed: () {
                        Navigator.pop(context);
                        goToNextTab(context: context);
                      },
                    ),
              );
            } else if (state.status == SaveStatus.failure) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => SysmoAlert.failure(
                      message: "Failed to save Loan Details",
                      onButtonPressed: () => Navigator.pop(context),
                    ),
              );
            }
          },
          builder: (context, state) {
            final loanBloc = context.watch<LoanproductBloc>().state;
            final loanTypeLabel =
                loanBloc.selectedProductScheme == null
                    ? "SHG"
                    : loanBloc.selectedProductScheme!.optionValue == "61"
                    ? "SHG"
                    : "JLG";
            DedupeState? dedupeState;
            if (state.status == SaveStatus.init && state.aadhaarData != null) {
              mapAadhaarData(state.aadhaarData);
            } else if (state.status == SaveStatus.init) {
              dedupeState = context.watch<DedupeBloc>().state;
              if (dedupeState.cifResponse != null) {
                print(
                  'cif response title => ${dedupeState.cifResponse?.lleadtitle}',
                );
                print('state.lovList =>${state.lovList}');
                mapCifDate(dedupeState.cifResponse);
              } else if (dedupeState.aadharvalidateResponse != null) {
                mapAadhaarData(dedupeState.aadharvalidateResponse);
              } else if (dedupeState.aadharvalidateResponse != null) {
                mapAadhaarData(dedupeState.aadharvalidateResponse);
              }
            } else if (state.status == SaveStatus.success &&
                state.getLead == false) {
              print('saved personal data =>${state.personalData}');
              Map<String, dynamic> personalDetails =
                  state.personalData!.toMap();
              mapPersonalData(personalDetails);
            } else if (state.status == SaveStatus.success &&
                state.getLead == true) {
              Map<String, dynamic> personalDetails =
                  state.personalData!.toMap();
              mapPersonalData(personalDetails);
            }
            return ReactiveForm(
              formGroup: form,
              child: SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      SearchableDropdown(
                        fieldKey: _titleKey,
                        controlName: 'title',
                        label: 'Title',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'Title')
                                .toList(),
                        selItem: () {
                          if (dedupeState?.cifResponse != null) {
                            Lov? lov = state.lovList?.firstWhere(
                              (lov) =>
                                  lov.Header == 'Title' &&
                                  lov.optvalue ==
                                      dedupeState?.cifResponse?.lleadtitle,
                            );
                            form.controls['title']?.updateValue(lov?.optvalue);
                            return lov;
                          } else if (state.personalData != null) {
                            Lov? lov = state.lovList?.firstWhere(
                              (lov) =>
                                  lov.Header == 'Title' &&
                                  lov.optvalue == state.personalData?.title,
                            );
                            form.controls['title']?.updateValue(lov?.optvalue);
                            return lov;
                          } else {
                            return null;
                          }
                        },
                        onChangeListener:
                            (Lov val) => form.controls['title']?.updateValue(
                              val.optvalue,
                            ),
                      ),
                      CustomTextField(
                        fieldKey: _firstNameKey,
                        controlName: 'firstName',
                        label: 'Name of the $loanTypeLabel',
                        mantatory: true,
                      ),
                      SizedBox(
                        height: 1,
                        child: Opacity(
                          opacity: 0,
                          child: CustomTextField(
                            fieldKey: _middleNameKey,
                            controlName: 'middleName',
                            label: 'Middle Name',
                            mantatory: false,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: Opacity(
                          opacity: 0,
                          child: CustomTextField(
                            fieldKey: _lastNameKey,
                            controlName: 'lastName',
                            label: 'Last Name',
                            mantatory: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ReactiveTextField<String>(
                          key: _dobKey,
                          formControlName: 'dob',
                          validationMessages: {
                            ValidationMessage.required:
                                (error) => 'Date of Formation',
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Date of Formation',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: (control) async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().subtract(
                                Duration(days: 365 * 18),
                              ),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              final formatted =
                                  "${pickedDate.year}-"
                                  "${pickedDate.month.toString().padLeft(2, '0')}-"
                                  "${pickedDate.day.toString().padLeft(2, '0')}";
                              form.control('dob').value = formatted;
                            }
                          },
                        ),
                      ),
                      IntegerTextField(
                        fieldKey: _primaryMobileNumberKey,
                        controlName: 'primaryMobileNumber',
                        label: 'Primary Mobile Number',
                        mantatory: true,
                        maxlength: 10,
                        minlength: 10,
                      ),
                      IntegerTextField(
                        fieldKey: _secondaryMobileNumberKey,
                        controlName: 'secondaryMobileNumber',
                        label: 'Secondary Mobile Number',
                        mantatory: true,
                        maxlength: 10,
                        minlength: 10,
                      ),
                      SizedBox(height: 10),

                      AadhaarVerification(
                        kycTextBox: KYCTextBox(
                          fieldKey: _aadhaarKey,
                          validationPatternErrorMessage:
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
                          isOffline: Globalconfig.isOffline,

                          onSuccess: (value) async {
                            print('onSuccess ${value.data}');
                          },
                          onError: (value) {
                            print(" onerror $value");
                          },
                          assetPath: AppConstants.aadhaarResponse,
                          verificationType:VerificationType.aadhaar,
                          kycNumber:
                              form.controls['aadhaar']?.value != null
                                  ? form.controls['aadhaar']!.value.toString()
                                  : null,
                                  validationPattern:AppConstants.AADHAAR_PATTERN
                        ),
                      ),

                      VoterVerification(
                        kycTextBox: KYCTextBox(
                          fieldKey: _voteridKey,
                          validationPatternErrorMessage:
                              'Please enter a valid Voter ID (e.g. ABC1234567)',

                          formProps: FormProps(
                            formControlName: 'voterid',
                            label: 'VoterId No',
                            mandatory: true,
                            maxLength: 10,
                          ),
                          styleProps: StyleProps(),
                          apiUrl: '',
                          // apiUrl:
                          //     'https://dev.connectperfect.io/cloud_gateway/api/v1.0/karza/voterid/v3',
                          buttonProps: ButtonProps(
                            label: 'verify',
                            foregroundColor: Colors.white,
                          ),
                          isOffline: Globalconfig.isOffline,
                          onSuccess: (value) async {
                            print('onSuccess ${value.data}');
                          },
                          onError: (value) {
                            print(" onerror $value");
                          },
                          assetPath: AppConstants.voterResponse,
                          verificationType: VerificationType.voter,
                          kycNumber:
                              form.controls['voterid']?.value != null
                                  ? form.controls['voterid']!.value.toString()
                                  : null,
                                  validationPattern:AppConstants.VOTER_PATTERN,
                        ),
                      ),

                      PassportVerification(
                        kycTextBox: KYCTextBox(
                          fieldKey: _passportKey,
                          validationPatternErrorMessage:
                              'Please enter a valid Passport ID (e.g. A1234567)',
                          formProps: FormProps(
                            formControlName: 'passport',
                            label: 'PassportNo',
                            mandatory: true,
                            maxLength: 8,
                          ),
                          styleProps: StyleProps(),

                          apiUrl: '',
                          buttonProps: ButtonProps(
                            label: 'verify',
                            foregroundColor: Colors.white,
                          ),
                          isOffline: Globalconfig.isOffline,
                          onSuccess: (value) async {
                            print('onSuccess ${value.data}');
                          },
                          onError: (value) {
                            print(" onerror $value");
                          },
                          assetPath: AppConstants.passportResponse,
                          verificationType: VerificationType.passport,
                          kycNumber:
                              form.controls['passport']?.value != null
                                  ? form.controls['passport']!.value.toString()
                                  : null,
                                  validationPattern: AppConstants.PASSPORT_PATTERN,
                        ),
                      ),

                      PanVerification(
                        kycTextBox: KYCTextBox(
                          fieldKey: _panKey,
                          validationPatternErrorMessage:
                              'Please enter a valid PanNumber (e.g. AAAAA1234R)',
                          formProps: FormProps(
                            formControlName: 'pan',
                            label: 'panNumber',
                            mandatory: true,
                            maxLength: 10,
                          ),
                          styleProps: StyleProps(),
                          // apiUrl:
                          //     'https://dev.connectperfect.io/cloud_gateway/api/v1.0/karza/pancard',
                          apiUrl: '',
                          buttonProps: ButtonProps(
                            label: 'verify',
                            foregroundColor: Colors.white,
                          ),
                          isOffline: Globalconfig.isOffline,
                          onSuccess: (value) async {
                            print('onSuccess ${value.data}');
                          },
                          onError: (value) {
                            print(" onerror $value");
                          },
                          assetPath: AppConstants.panResponse,
                          verificationType: VerificationType.pan,
                          kycNumber:
                              form.controls['pan']?.value != null
                                  ? form.controls['pan']!.value.toString()
                                  : null,
                          validationPattern: AppConstants.PAN_PATTERN
                        ),
                      ),

                      GSTVerification(
                        kycTextBox: KYCTextBox(
                          fieldKey: _gstKey,
                          validationPatternErrorMessage:
                              'Please enter a valid GST Number(e.g.11AAECS6891A1ZG)',

                          formProps: FormProps(
                            formControlName: 'gst',
                            label: 'GST',
                            mandatory: true,
                            maxLength: 15,
                          ),
                          styleProps: StyleProps(),
                          apiUrl: '',
                          buttonProps: ButtonProps(
                            label: 'verify',
                            foregroundColor: Colors.white,
                          ),
                          isOffline: Globalconfig.isOffline,
                          onSuccess: (value) async {
                            print('onSuccess ${value.data}');
                          },
                          onError: (value) {
                            print(" onerror $value");
                          },
                          assetPath: AppConstants.gstResponse,
                          verificationType: VerificationType.gst,
                          kycNumber:
                              form.controls['gst']?.value != null
                                  ? form.controls['gst']!.value.toString()
                                  : null,
                                  validationPattern:AppConstants.GST_PATTERN
                        ),

                      ),

                      CustomTextField(
                        fieldKey: _emailKey,
                        controlName: 'email',
                        label: 'Email Id',
                        mantatory: true,
                      ),
                      // SizedBox(
                      //   height: 1,
                      //   child: Opacity(
                      //     opacity: 0,
                      //     child: CustomTextField(
                      //       fieldKey: _panNumberKey,
                      //       controlName: 'panNumber',
                      //       label: 'Pan No',
                      //       mantatory: true,
                      //       autoCapitalize: true,
                      //       maxlength: 10,
                      //     ),
                      //   ),
                      // ),

                      // SizedBox(
                      //   height: 1,
                      //   child: Opacity(
                      //     opacity: 0,
                      //     child:
                      //         refAadhaar
                      //             ? Row(
                      //               children: [
                      //                 Expanded(
                      //                   child: IntegerTextField(
                      //                     fieldKey: _aadharRefNoKey,
                      //                     controlName: 'aadharRefNo',
                      //                     label: 'Aadhaar No',
                      //                     mantatory: true,
                      //                     maxlength: 12,
                      //                     minlength: 12,
                      //                   ),
                      //                 ),
                      //                 const SizedBox(width: 8),
                      //                 ElevatedButton.icon(
                      //                   icon: Icon(Icons.qr_code_scanner),
                      //                   label: Text('Scan'),
                      //                   onPressed:
                      //                       () => showScannerOptions(context),
                      //                 ),
                      //               ],
                      //             )
                      //             : Row(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: [
                      //                 Expanded(
                      //                   child: IntegerTextField(
                      //                     fieldKey: _aadhaarKey,
                      //                     controlName: 'aadhaar',
                      //                     label: 'Aadhaar Number',
                      //                     mantatory: true,
                      //                     maxlength: 12,
                      //                     minlength: 12,
                      //                   ),
                      //                 ),
                      //                 const SizedBox(width: 8),
                      //                 ElevatedButton(
                      //                   style: ElevatedButton.styleFrom(
                      //                     backgroundColor: const Color.fromARGB(
                      //                       255,
                      //                       3,
                      //                       9,
                      //                       110,
                      //                     ),
                      //                     foregroundColor: Colors.white,
                      //                     padding: const EdgeInsets.symmetric(
                      //                       horizontal: 16,
                      //                       vertical: 10,
                      //                     ),
                      //                     shape: RoundedRectangleBorder(
                      //                       borderRadius: BorderRadius.circular(
                      //                         8,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   onPressed: () {
                      //                     final AadharvalidateRequest
                      //                     aadharvalidateRequest =
                      //                         AadharvalidateRequest(
                      //                           aadhaarNumber:
                      //                               form
                      //                                   .control('aadhaar')
                      //                                   .value,
                      //                         );
                      //                     context
                      //                         .read<PersonalDetailsBloc>()
                      //                         .add(
                      //                           AadhaarValidateEvent(
                      //                             request:
                      //                                 aadharvalidateRequest,
                      //                           ),
                      //                         );
                      //                   },
                      //                   child:
                      //                       state.status == SaveStatus.loading
                      //                           ? CircularProgressIndicator()
                      //                           : const Text("Validate"),
                      //                 ),
                      //               ],
                      //             ),
                      //   ),
                      // ),
                      IntegerTextField(
                        fieldKey: _loanAmountRequestedKey,
                        controlName: 'loanAmountRequested',
                        label: 'Loan Amount Required',
                        mantatory: true,
                        isRupeeFormat: true,
                      ),

                      SizedBox(
                        height: 1,
                        child: Opacity(
                          opacity: 0,
                          child: SearchableDropdown<Lov>(
                            fieldKey: _residentialStatusKey,
                            controlName: 'residentialStatus',
                            label: 'Residential Status',
                            items:
                                state.lovList!
                                    .where(
                                      (v) => v.Header == 'ResidentialStatus',
                                    )
                                    .toList(),
                            onChangeListener: (Lov val) {
                              form.controls['residentialStatus']?.updateValue(
                                val.optvalue,
                              );
                            },
                            selItem: () {
                              final value =
                                  form.control('residentialStatus').value;
                              if (value == null || value.toString().isEmpty) {
                                return null;
                              }
                              return state.lovList!
                                  .where((v) => v.Header == 'ResidentialStatus')
                                  .firstWhere(
                                    (lov) => lov.optvalue == value,
                                    orElse:
                                        () => Lov(
                                          Header: 'ResidentialStatus',
                                          optvalue: '',
                                          optDesc: '',
                                          optCode: '',
                                        ),
                                  );
                            },
                          ),
                        ),
                      ),

                      SearchableDropdown<Lov>(
                        fieldKey: _natureOfActivityKey,
                        controlName: 'natureOfActivity',
                        label: 'Purpose of Loan',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'NatureOfActivity')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['natureOfActivity']?.updateValue(
                            val.optvalue,
                          );
                        },
                        selItem: () {
                          final value = form.control('natureOfActivity').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'NatureOfActivity')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'NatureOfActivity',
                                      optDesc: '',
                                      optvalue: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),
                      SizedBox(
                        height: 1,
                        child: Opacity(
                          opacity: 0,
                          child: SearchableDropdown<Lov>(
                            fieldKey: _occupationTypeKey,
                            controlName: 'occupationType',
                            label: 'Occupation Type',
                            items:
                                state.lovList!
                                    .where((v) => v.Header == 'OccupationType')
                                    .toList(),
                            onChangeListener: (Lov val) {
                              form.controls['occupationType']?.updateValue(
                                val.optvalue,
                              );
                            },
                            selItem: () {
                              form.controls['occupationType']?.updateValue("1");
                              return Lov(
                                Header: "OccupationType",
                                optvalue: "01",
                                optDesc: "SALARIED",
                                optCode: "01",
                              );
                            },
                            // selItem: () {
                            //   final value = form.control('occupationType').value;
                            //   if (value == null || value.toString().isEmpty) {
                            //     return null;
                            //   }
                            //   return state.lovList!
                            //       .where((v) => v.Header == 'OccupationType')
                            //       .firstWhere(
                            //         (lov) => lov.optvalue == value,
                            //         orElse:
                            //             () => Lov(
                            //               Header: 'OccupationType',
                            //               optvalue: '',
                            //               optDesc: '',
                            //               optCode: '',
                            //             ),
                            //       );
                            // },
                          ),
                        ),
                      ),
                      SearchableDropdown<Lov>(
                        fieldKey: _agriculturistTypeKey,
                        controlName: 'agriculturistType',
                        label: 'Proposed Linkage',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'AgricultType')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['agriculturistType']?.updateValue(
                            val.optvalue,
                          );
                        },
                        selItem: () {
                          final value = form.control('agriculturistType').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'AgricultType')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'AgricultType',
                                      optvalue: '',
                                      optDesc: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),
                      SizedBox(
                        height: 1,
                        child: Opacity(
                          opacity: 0,
                          child: SearchableDropdown<Lov>(
                            fieldKey: _farmerCategoryKey,
                            controlName: 'farmerCategory',
                            label: 'Farmer Category',
                            items:
                                state.lovList!
                                    .where((v) => v.Header == 'FarmerCategory')
                                    .toList(),
                            onChangeListener: (Lov val) {
                              form.controls['farmerCategory']?.updateValue(
                                val.optvalue,
                              );
                            },
                            // selItem: () {
                            //   final value = form.control('farmerCategory').value;
                            //   if (value == null || value.toString().isEmpty) {
                            //     return null;
                            //   }
                            //   return state.lovList!
                            //       .where((v) => v.Header == 'FarmerCategory')
                            //       .firstWhere(
                            //         (lov) => lov.optvalue == value,
                            //         orElse:
                            //             () => Lov(
                            //               Header: 'FarmerCategory',
                            //               optvalue: '',
                            //               optDesc: '',
                            //               optCode: '',
                            //             ),
                            //       );
                            // },
                            selItem: () {
                              form.controls['farmerCategory']?.updateValue("1");
                              return Lov(
                                Header: "FarmerCategory",
                                optvalue: "2",
                                optDesc: "Sharecropper",
                                optCode: "1",
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: Opacity(
                          opacity: 0,
                          child: SearchableDropdown<Lov>(
                            fieldKey: _farmerTypeKey,
                            controlName: 'farmerType',
                            label: 'Farmer Type',
                            items:
                                state.lovList!
                                    .where((v) => v.Header == 'FarmerType')
                                    .toList(),
                            onChangeListener: (Lov val) {
                              form.controls['farmerType']?.updateValue(
                                val.optvalue,
                              );
                            },
                            // selItem: () {
                            //   final value = form.control('farmerType').value;
                            //   if (value == null || value.toString().isEmpty) {
                            //     return null;
                            //   }
                            //   return state.lovList!
                            //       .where((v) => v.Header == 'FarmerType')
                            //       .firstWhere(
                            //         (lov) => lov.optvalue == value,
                            //         orElse:
                            //             () => Lov(
                            //               Header: 'FarmerType',
                            //               optvalue: '',
                            //               optDesc: '',
                            //               optCode: '',
                            //             ),
                            //       );
                            // },
                            selItem: () {
                              form.controls['farmerType']?.updateValue("1");
                              return Lov(
                                Header: "FarmerType",
                                optvalue: "2",
                                optDesc: "Marginal",
                                optCode: "1",
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: Opacity(
                          opacity: 0,
                          child: SearchableDropdown<Lov>(
                            fieldKey: _religionKey,
                            controlName: 'religion',
                            label: 'Religion',
                            items:
                                state.lovList!
                                    .where((v) => v.Header == 'Religion')
                                    .toList(),
                            onChangeListener: (Lov val) {
                              form.controls['religion']?.updateValue(
                                val.optvalue,
                              );
                            },
                            // selItem: () {
                            //   final value = form.control('religion').value;
                            //   if (value == null || value.toString().isEmpty) {
                            //     return null;
                            //   }
                            //   return state.lovList!
                            //       .where((v) => v.Header == 'Religion')
                            //       .firstWhere(
                            //         (lov) => lov.optvalue == value,
                            //         orElse:
                            //             () => Lov(
                            //               Header: 'Religion',
                            //               optvalue: '',
                            //               optDesc: '',
                            //               optCode: '',
                            //             ),
                            //       );
                            // },
                            selItem: () {
                              form.controls['religion']?.updateValue("1");
                              return Lov(
                                Header: "Religion",
                                optvalue: "1",
                                optDesc: "Buddhist",
                                optCode: "1",
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: Opacity(
                          opacity: 0,
                          child: SearchableDropdown<Lov>(
                            fieldKey: _casteKey,
                            controlName: 'caste',
                            label: 'Caste',
                            items:
                                state.lovList!
                                    .where((v) => v.Header == 'Caste')
                                    .toList(),
                            onChangeListener: (Lov val) {
                              form.controls['caste']?.updateValue(val.optvalue);
                            },

                            // selItem: () {
                            //   final value = form.control('caste').value;
                            //   if (value == null || value.toString().isEmpty) {
                            //     return null;
                            //   }
                            //   return state.lovList!
                            //       .where((v) => v.Header == 'Caste')
                            //       .firstWhere(
                            //         (lov) => lov.optvalue == value,
                            //         orElse:
                            //             () => Lov(
                            //               Header: 'Caste',
                            //               optvalue: '',
                            //               optDesc: '',
                            //               optCode: '',
                            //             ),
                            //       );
                            // },
                            selItem: () {
                              form.controls['caste']?.updateValue("1");
                              return Lov(
                                Header: "Caste",
                                optvalue: "CAS000001",
                                optDesc: "GENERAL",
                                optCode: "CAS000001",
                              );
                            },
                          ),
                        ),
                      ),
                      SearchableDropdown<Lov>(
                        fieldKey: _genderKey,
                        controlName: 'gender',
                        label: 'Whether classified as special $loanTypeLabel',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'Gender')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['gender']?.updateValue(val.optvalue);
                        },
                        selItem: () {
                          final value = form.control('gender').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'Gender')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'Gender',
                                      optvalue: '',
                                      optDesc: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),
                      SizedBox(
                        height: 1,
                        child: Opacity(
                          opacity: 0,
                          child: SearchableMultiSelectDropdown<Lov>(
                            fieldKey: _subActivityKey,
                            controlName: 'subActivity',
                            label: 'Sub Activity',
                            items:
                                state.lovList!
                                    .where((v) => v.Header == 'SubActivity')
                                    .toList(),
                            selItems: () {
                              final currentValues =
                                  form.control('subActivity').value;
                              if (currentValues == null ||
                                  currentValues.isEmpty) {
                                return <Lov>[];
                              }
                              return state.lovList!
                                  .where(
                                    (v) =>
                                        v.Header == 'SubActivity' &&
                                        currentValues.contains(v.optvalue),
                                  )
                                  .toList();
                            },

                            onChangeListener: (List<Lov>? selectedItems) {
                              final selectedValues =
                                  selectedItems
                                      ?.map((e) => e.optvalue)
                                      .toList() ??
                                  [];
                              String subactivities = selectedValues.join(',');
                              form.controls['subActivity']?.updateValue(
                                subactivities,
                              );
                            },
                          ),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
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
                            if (state.getLead == null ||
                                state.getLead == false) {
                              // if (form.valid && form.pending) {
                              if (form.valid) {
                                PersonalData personalData =
                                    PersonalData.fromMap(form.value);
                                PersonalData personalDataFormatted =
                                    personalData.copyWith(
                                      dob: getDateFormatedByProvided(
                                        personalData.dob,
                                        from: AppConstants.Format_dd_MM_yyyy,
                                        to: AppConstants.Format_yyyy_MM_dd,
                                      ),
                                    );

                                context.read<PersonalDetailsBloc>().add(
                                  PersonalDetailsSaveEvent(
                                    personalData: personalDataFormatted,
                                  ),
                                );
                                print('personalData $personalData');
                              } else {
                                form.markAllAsTouched();
                                scrollToErrorField();
                              }
                            }
                          },
                          child: Text('Next'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
