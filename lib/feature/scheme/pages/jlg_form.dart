import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/Utils/qr_nav_utils.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_request.dart';
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
import 'package:reactive_forms/reactive_forms.dart';

class JlgForm extends StatelessWidget {
  final String title;
  // scrollcontroller is required to scroll to errorformfield
  final _scrollController = ScrollController();
  JlgForm({required this.title, super.key});

  final FormGroup form = AppForms.JLG_DETAILS_FORM();
  final _titleKey = GlobalKey();
  final _firstNameKey = GlobalKey();
  final _dobKey = GlobalKey();
  final _primaryMobileNumberKey = GlobalKey();
  final _secondaryMobileNumberKey = GlobalKey();
  final _emailKey = GlobalKey();
  final _loanAmountRequestedKey = GlobalKey();
  final _natureOfActivityKey = GlobalKey();
  final _agriculturistTypeKey = GlobalKey();
  final _religionKey = GlobalKey();
  final _genderKey = GlobalKey();
  final _residentialStatusKey = GlobalKey();

  /* 
    @author     : ganeshkumar.b  13/06/2025
    @desc       : map Aadhaar response in personal form
    @param      : {AadharvalidateResponse val} - aadhaar response
  */

  mapCifDate(val) {
    datamapperCif(val);
  }

  void datamapperCif(val) {
    try {
      form.control('firstName').updateValue(val.lleadfrstname!);
      form.control('dob').updateValue(getDateFormat(val.lleaddob!));
      form.control('primaryMobileNumber').updateValue(val.lleadmobno!);
      form.control('email').updateValue(val.lleademailid!);
    } catch (error) {
      print("autoPopulateData-catch-error $error");
    }
  }

  mapPersonalData(val) {
    try {
      form.control('title').updateValue(val['title']);
      form.control('firstName').updateValue(val['firstName']);
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
      form.control('agriculturistType').updateValue(val['agriculturistType']);
      form.control('gender').updateValue(val['gender']);
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

      {'key': _dobKey, 'controlName': 'dob'},
      {'key': _primaryMobileNumberKey, 'controlName': 'primaryMobileNumber'},
      {
        'key': _secondaryMobileNumberKey,
        'controlName': 'secondaryMobileNumber',
      },
      {'key': _emailKey, 'controlName': 'email'},

      {'key': _loanAmountRequestedKey, 'controlName': 'loanAmountRequested'},
      {'key': _natureOfActivityKey, 'controlName': 'natureOfActivity'},
      {'key': _agriculturistTypeKey, 'controlName': 'agriculturistType'},
      {'key': _religionKey, 'controlName': 'religion'},
      {'key': _genderKey, 'controlName': 'gender'},
      {'key': _residentialStatusKey, 'controlName': 'residentialStatus'},
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
          title: Text("JLG Details"),
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
            // final loanBloc = context.watch<LoanproductBloc>().state;
            // final loanTypeLabel = loanBloc.selectedProductScheme == null ? "SHG" : loanBloc.selectedProductScheme!.optionValue == "61" ? "SHG" : "JLG" ;
            DedupeState? dedupeState;
            if (state.status == SaveStatus.init && state.aadhaarData != null) {
              // mapAadhaarData(state.aadhaarData);
            } else if (state.status == SaveStatus.init) {
              dedupeState = context.watch<DedupeBloc>().state;
              if (dedupeState.cifResponse != null) {
                print(
                  'cif response title => ${dedupeState.cifResponse?.lleadtitle}',
                );
                print('state.lovList =>${state.lovList}');
                mapCifDate(dedupeState.cifResponse);
              } else if (dedupeState.aadharvalidateResponse != null) {
                // mapAadhaarData(dedupeState.aadharvalidateResponse);
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
                        label: 'Name of the JLG',
                        mantatory: true,
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
                      CustomTextField(
                        fieldKey: _emailKey,
                        controlName: 'email',
                        label: 'Email Id',
                        mantatory: true,
                      ),

                      IntegerTextField(
                        fieldKey: _loanAmountRequestedKey,
                        controlName: 'loanAmountRequested',
                        label: 'Loan Amount Required',
                        mantatory: true,
                        isRupeeFormat: true,
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

                      SearchableDropdown<Lov>(
                        fieldKey: _genderKey,
                        controlName: 'gender',
                        label: 'Whether classified as special JLG',
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

                      SizedBox(height: 20),

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
