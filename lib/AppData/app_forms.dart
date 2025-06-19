import 'package:newsee/AppData/app_constants.dart';
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
    'title': FormControl<String>(validators: [Validators.required]),
    'firstname': FormControl<String>(validators: [Validators.required]),
    'lastname': FormControl<String>(validators: [Validators.required]),
    'mobilenumber': FormControl<String>(
      validators: [Validators.maxLength(10), Validators.minLength(10)],
    ),
    'pan': FormControl<String>(
      validators: [Validators.pattern(AppConstants.PAN_PATTERN)],
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
    'constitution': FormControl<String>(validators: [Validators.required]),
    'isNewCustomer': FormControl<bool>(validators: [Validators.required]),
  });
}

//Land holding Form Group

final FormGroup form = FormGroup({
  'applicantName': FormControl<String>(validators: [Validators.required]),
  'locationOfFarm': FormControl<String>(validators: [Validators.required]),
  'state': FormControl<String>(validators: [Validators.required]),
  'taluk': FormControl<String>(validators: [Validators.required]),
  'firka': FormControl<String>(validators: [Validators.required]),
  'totalAcreage': FormControl<String>(validators: [Validators.required]),
  'irrigatedLand': FormControl<String>(validators: [Validators.required]),
  'compactBlocks': FormControl<String>(validators: [Validators.required]),
  'holdingsTally': FormControl<String>(validators: [Validators.required]),
  'landOwnedByApplicant': FormControl<bool>(validators: [Validators.required]),
  'distanceFromBranch': FormControl<String>(validators: [Validators.required]),
  'district': FormControl<String>(validators: [Validators.required]),
  'village': FormControl<String>(validators: [Validators.required]),
  'surveyNo': FormControl<String>(validators: [Validators.required]),
  'natureOfRight': FormControl<String>(validators: [Validators.required]),
  'irrigationFacilities': FormControl<String>(
    validators: [Validators.required],
  ),
  'affectedByCeiling': FormControl<String>(validators: [Validators.required]),
  'landAgriActive': FormControl<String>(validators: [Validators.required]),
});
