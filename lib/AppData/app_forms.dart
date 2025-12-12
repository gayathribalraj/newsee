import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppForms {
  static FormGroup SOURCING_DETAILS_FORM = FormGroup({
    'businessdescription': FormControl<String>(
      validators: [Validators.required],
    ),
    'sourcingchannel': FormControl<String>(validators: [Validators.required]),
    'sourcingid': FormControl<String>(validators: [Validators.required]),
    'sourcingname': FormControl<String>(validators: [Validators.required]),
    'preferredbranch': FormControl<String>(validators: [Validators.required]),
    'branchcode': FormControl<String>(validators: [Validators.required]),
    'leadgeneratedby': FormControl<String>(validators: [Validators.required]),
    'leadid': FormControl<String>(validators: [Validators.required]),
    'customername': FormControl<String>(validators: [Validators.required]),
    'dateofbirth': FormControl<String>(validators: [Validators.required]),
    'mobilenumber': FormControl<String>(validators: [Validators.required]),
    'productinterest': FormControl<String>(validators: [Validators.required]),
  });

  static FormGroup DEDUPE_DETAILS_FORM = FormGroup({
    'title': FormControl<String>(
      validators: [
        // Validators.required
      ],
    ),
    'firstname': FormControl<String>(
      validators: [
        // Validators.required,
        Validators.pattern(AppConstants.Name_Pattern),
      ],
    ),
    'lastname': FormControl<String>(
      validators: [
        // Validators.required,
        Validators.pattern(AppConstants.Name_Pattern),
      ],
    ),
    'mobilenumber': FormControl<String>(
      validators: [
        Validators.maxLength(10),
        Validators.minLength(10),
        Validators.pattern(AppConstants.mobileNumber),
        // Validators.required,
      ],
    ),
    'pan': FormControl<String>(
      validators: [
        Validators.pattern(AppConstants.PAN_PATTERN),
        // Validators.required,
      ],
    ),
    'aadhaar': FormControl<String>(
      validators: [
        Validators.required,
        Validators.maxLength(12),
        Validators.minLength(12),
        Validators.pattern(AppConstants.AADHAAR_PATTERN),
      ],
    ),
  });

  static FormGroup CIF_DETAILS_FORM = FormGroup({
    'cifid': FormControl<String>(validators: [Validators.required]),
  });

  static FormGroup CUSTOMER_TYPE_FORM = FormGroup({
    'constitution': FormControl<String>(
      value: 'I',
      validators: [Validators.required],
    ),
    'isNewCustomer': FormControl<bool>(
      value: null,
      validators: [Validators.required],
    ),
  });

  static FormGroup GET_PERSONAL_DETAILS_FORM() => FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'firstName': FormControl<String>(validators: [Validators.required]),
    'middleName': FormControl<String>(validators: [Validators.required]),
    'lastName': FormControl<String>(validators: [Validators.required]),
    'dob': FormControl<String>(validators: [Validators.required]),
    'residentialStatus': FormControl<String>(validators: []),
    'primaryMobileNumber': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(10),
        Validators.pattern(AppConstants.mobileNumber),
      ],
    ),
    'secondaryMobileNumber': FormControl<String>(
      validators: [
        // Validators.required,
        Validators.minLength(10),
        Validators.pattern(AppConstants.mobileNumber),
      ],
    ),
    'email': FormControl<String>(validators: [Validators.email]),
    'aadhaar': FormControl<String>(validators: []),
    'panNumber': FormControl<String>(
      validators: [
        Validators.pattern(AppConstants.PAN_PATTERN),
        Validators.minLength(10),
        Validators.required,
      ],
    ),
    'aadharRefNo': FormControl<String>(
      validators: [
        // Validators.pattern(AppConstants.AADHAAR_PATTERN),
        // Validators.minLength(10),
      ],
    ),
    'loanAmountRequested': FormControl<String>(
      validators: [Validators.required],
      asyncValidators: [
        Validators.delegateAsync((control) async {
          final rawValue = control.value;

          // Skip validation if empty or null
          if (rawValue == null || rawValue.trim().isEmpty) {
            return null;
          }

          // Remove all non-digit characters (commas, spaces, ₹ etc.)
          String cleanValue = rawValue.replaceAll(RegExp(r'[^\d.]'), '');
          print('loanAmountRequested => $cleanValue');
          // If the value contains a decimal point, keep only the integer part
          if (cleanValue.contains('.')) {
            cleanValue = cleanValue.split('.').first;
          }

          if (cleanValue.isEmpty) return null;

          // Parse safely
          final loanAmountEntered = int.tryParse(cleanValue) ?? 0;
          print('loanAmountRequested::delegateAsync => $loanAmountEntered');
          // Compare with configured maximum
          if (loanAmountEntered > Globalconfig.loanAmountMaximum) {
            print(
              'loanAmountRequested::delegateAsync => ${Globalconfig.loanAmountMaximum}',
            );
            // Return a properly structured validation error
            return {
              'max':
                  'Loan amount should not exceed '
                  '${Globalconfig.loanAmountMaximum.toString()}',
            };
          }

          return null;
        }),
      ],
    ),
    'natureOfActivity': FormControl<String>(validators: [Validators.required]),
    'occupationType': FormControl<String>(validators: [Validators.required]),
    'agriculturistType': FormControl<String>(validators: [Validators.required]),
    'farmerCategory': FormControl<String>(validators: [Validators.required]),
    'farmerType': FormControl<String>(validators: [Validators.required]),
    'religion': FormControl<String>(validators: [Validators.required]),
    'caste': FormControl<String>(validators: [Validators.required]),
    'gender': FormControl<String>(validators: [Validators.required]),
    'subActivity': FormControl<String>(validators: [Validators.required]),
  });

  static final FormGroup COAPPLICANT_DETAILS_FORM = FormGroup({
    'customertype': FormControl<String>(validators: []),
    'constitution': FormControl<String>(validators: []),
    'cifNumber': FormControl<String>(validators: []),
    'title': FormControl<String>(validators: [Validators.required]),
    'firstName': FormControl<String>(validators: [Validators.required]),
    'middleName': FormControl<String>(validators: [Validators.required]),
    'lastName': FormControl<String>(validators: [Validators.required]),
    'relationshipFirm': FormControl<String>(validators: [Validators.required]),
    'dob': FormControl<String>(validators: [Validators.required]),
    'primaryMobileNumber': FormControl<String>(
      validators: [Validators.required, Validators.minLength(10)],
    ),
    'secondaryMobileNumber': FormControl<String>(
      validators: [Validators.minLength(10)],
    ),
    'email': FormControl<String>(validators: [Validators.email]),
    'aadhaar': FormControl<String>(
      validators: [
        Validators.pattern(AppConstants.AADHAAR_PATTERN),
        Validators.minLength(10),
      ],
    ),
    'panNumber': FormControl<String>(
      validators: [
        Validators.required,
        Validators.pattern(AppConstants.PAN_PATTERN),
        Validators.minLength(10),
      ],
    ),
    'aadharRefNo': FormControl<String>(
      validators: [
        Validators.pattern(AppConstants.AADHAAR_PATTERN),
        Validators.minLength(10),
      ],
    ),
    'address1': FormControl<String>(validators: [Validators.required]),
    'address2': FormControl<String>(validators: [Validators.required]),
    'address3': FormControl<String>(validators: []),
    'state': FormControl<String>(validators: [Validators.required]),
    'cityDistrict': FormControl<String>(validators: [Validators.required]),
    'pincode': FormControl<String>(validators: [Validators.required]),
    'loanLiabilityCount': FormControl<String>(
      validators: [],
    ),
    'loanLiabilityAmount': FormControl<String>(
      validators: [],
    ),
    'depositCount': FormControl<String>(validators: []),
    'depositAmount': FormControl<String>(validators: []),
  });

  static FormGroup buildLandHoldingDetailsForm() {
    return FormGroup({
      'lslLandRowid': FormControl<String>(validators: []),
      'applicantName': FormControl<String>(validators: [Validators.required]),
      'locationOfFarm': FormControl<String>(validators: [], disabled: true),
      'state': FormControl<String>(validators: [Validators.required]),
      'taluk': FormControl<String>(validators: [Validators.required]),
      'firka': FormControl<String>(
        validators: [Validators.required, Validators.pattern(r'^\d+$')],
      ),
      'totalAcreage': FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(6),
          Validators.minLength(1),
        ],
      ),
      'irrigatedLand': FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(6),
          Validators.minLength(1),
        ],
      ),
      'compactBlocks': FormControl<bool>(validators: [Validators.required]),
      'landOwnedByApplicant': FormControl<bool>(
        validators: [Validators.required],
      ),
      'distanceFromBranch': FormControl<String>(
        validators: [Validators.required],
        disabled: true,
      ),
      'district': FormControl<String>(validators: [Validators.required]),
      'village': FormControl<String>(validators: [Validators.required]),
      'surveyNo': FormControl<String>(
        validators: [Validators.required, Validators.pattern(r'^\d+$')],
      ),
      'natureOfRight': FormControl<String>(validators: [Validators.required]),
      'irrigationFacilities': FormControl<String>(
        validators: [Validators.required],
      ),
      'affectedByCeiling': FormControl<bool>(validators: [Validators.required]),
      'landAgriActive': FormControl<bool>(validators: [Validators.required]),
      'villageOfficerCertified': FormControl<bool>(
        validators: [Validators.required],
      ),
      // 'latitude': FormControl<String>(validators: []),
      // 'longitude': FormControl<String>(validators: []),
    });
  }

  // static FormGroup buildLandHoldingForm() {
  //   return FormGroup({
  //     'rowId': FormControl<String>(validators: []),
  //     'applicantName': FormControl<String>(validators: [Validators.required]),
  //     'state': FormControl<String>(validators: [Validators.required]),
  //     'district': FormControl<String>(validators: [Validators.required]),
  //     'village': FormControl<String>(validators: [Validators.required]),
  //     'taluk': FormControl<String>(validators: [Validators.required]),
  //     'locationOfFarm': FormControl<String>(validators: []),
  //     'farmDistance': FormControl<String>(
  //       validators: [
  //         Validators.required,
  //         Validators.maxLength(3),
  //         Validators.minLength(1),
  //       ],
  //     ),
  //     'surveyNo': FormControl<String>(
  //       validators: [
  //         Validators.required,
  //         Validators.maxLength(10),
  //         Validators.minLength(1),
  //       ],
  //     ),
  //     'khasraNo': FormControl<String>(
  //       validators: [
  //         Validators.required,
  //         Validators.maxLength(10),
  //         Validators.minLength(1),
  //       ],
  //     ),
  //     'uccCode': FormControl<String>(
  //       validators: [
  //         Validators.required,
  //         Validators.maxLength(2),
  //         Validators.minLength(1),
  //       ],
  //     ),
  //     'totAcre': FormControl<String>(
  //       validators: [
  //         Validators.required,
  //         Validators.maxLength(6),
  //         Validators.minLength(1),
  //       ],
  //     ),
  //     'landType': FormControl<String>(validators: [Validators.required]),
  //     'sourceofIrrig': FormControl<String>(validators: [Validators.required]),
  //     'particulars': FormControl<String>(validators: [Validators.required]),
  //     'farmercategory': FormControl<String>(validators: [Validators.required]),

  //     'otherbanks': FormControl<bool>(validators: [Validators.required]),

  //     'primaryoccupation': FormControl<String>(
  //       validators: [Validators.required],
  //     ),
  //     'sumOfTotalAcreage': FormControl<String>(
  //       validators: [Validators.required],
  //       disabled: true,
  //     ),
  //   });
  // }

  // static FormGroup buildCropDetailsForm() {
  //   return FormGroup({
  //     'rowId': FormControl<String>(validators: []),
  //     'season': FormControl<String>(validators: [Validators.required]),
  //     'cropType': FormControl<String>(validators: [Validators.required]),
  //     'cropName': FormControl<String>(validators: [Validators.required]),
  //     'covOfCrop': FormControl<String>(validators: [Validators.required]),
  //     'typeOfLand': FormControl<String>(validators: [Validators.required]),
  //     'culAreaLand': FormControl<String>(
  //       validators: [Validators.required, Validators.maxLength(5)],
  //     ),
  //     'culAreaSize': FormControl<String>(
  //       validators: [Validators.required, Validators.maxLength(10)],
  //     ),
  //     'scaOfFin': FormControl<String>(
  //       validators: [Validators.required, Validators.maxLength(15)],
  //     ),
  //     'addSofByRo': FormControl<String>(
  //       validators: [Validators.required, Validators.maxLength(10)],
  //     ),
  //     'addSofAmount': FormControl<String>(
  //       validators: [Validators.maxLength(15)],
  //       disabled: true,
  //     ),
  //     'costOfCul': FormControl<String>(
  //       validators: [Validators.required, Validators.maxLength(15)],
  //       disabled: true,
  //     ),
  //     'cropIns': FormControl<String>(validators: [Validators.required]),
  //     'insPre': FormControl<String>(
  //       validators: [Validators.required, Validators.maxLength(15)],
  //       disabled: true,
  //     ),
  //     'dueDateOfRepay': FormControl<String>(
  //       validators: [Validators.required],
  //       disabled: true,
  //     ),
  //   });
  // }

  static FormGroup buildCropDetailsForm() {
    return FormGroup({
      'lasSeqno': FormControl<String>(validators: []),
      'lasSeason': FormControl<String>(validators: [Validators.required]),
      'lasCrop': FormControl<String>(validators: [Validators.required]),
      'lasAreaofculti': FormControl<String>(validators: [Validators.required]),
      'lasTypOfLand': FormControl<String>(validators: [Validators.required]),
      'lasScaloffin': FormControl<String>(validators: [Validators.required]),
      'lasReqScaloffin': FormControl<String>(validators: [Validators.required]),
      'notifiedCropFlag': FormControl<bool>(validators: [Validators.required]),
      'lasPrePerAcre': FormControl<String>(validators: [Validators.required]),
      'lasPreToCollect': FormControl<String>(validators: [Validators.required]),
    });
  }

  static FormGroup AUDIT_LOG_FORM() => FormGroup({
    'todayAndThisweek': FormControl<String>(value: ''),
    'startDate': FormControl<String>(value: null),
    'endDate': FormControl<String>(value: null),
    'startTime': FormControl<TimeOfDay>(value: null),
    'endTime': FormControl<TimeOfDay>(value: null),
  });
}
