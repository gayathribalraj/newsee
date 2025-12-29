import 'package:newsee/AppData/app_constants.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Form builders for different product schemes (JLG, SHG, Other)
/// Each scheme can have different form fields and validations

class FormBuilders {
  /// Base form fields common to all schemes
  static Map<String, FormControl> _getBaseFields() => {
    'title': FormControl<String>(validators: [Validators.required]),
    'firstName': FormControl<String>(validators: [Validators.required]),
    'middleName': FormControl<String>(validators: []),
    'lastName': FormControl<String>(validators: []),
    'dob': FormControl<String>(validators: [Validators.required]),
    'residentialStatus': FormControl<String>(validators: []),
    'primaryMobileNumber': FormControl<String>(
      validators: [Validators.required, Validators.minLength(10)],
    ),
    'secondaryMobileNumber': FormControl<String>(
      validators: [Validators.required, Validators.minLength(10)],
    ),
    'email': FormControl<String>(validators: [Validators.email]),
    'aadhaar': FormControl<String>(validators: []),
    'panNumber': FormControl<String>(
      validators: [
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
    'loanAmountRequested': FormControl<String>(
      validators: [Validators.required],
    ),
  };

  /// SHG (Self-Help Group) specific form
  /// Includes fields relevant for SHG lending
  static FormGroup buildSHGForm() {
    return FormGroup({
      ..._getBaseFields(),
      'natureOfActivity': FormControl<String>(
        validators: [Validators.required],
      ),
      'occupationType': FormControl<String>(validators: []),
      'subActivity': FormControl<String>(validators: []),
      'shgGroupName': FormControl<String>(validators: []),
      'shgMemberCount': FormControl<String>(validators: []),
      'shgRegistrationNumber': FormControl<String>(validators: []),
      'shgRegistrationDate': FormControl<String>(validators: []),
    });
  }

  /// JLG (Joint Liability Group) specific form
  /// Includes fields relevant for JLG lending
  static FormGroup buildJLGForm() {
    return FormGroup({
      ..._getBaseFields(),
      'natureOfActivity': FormControl<String>(
        validators: [Validators.required],
      ),
      'occupationType': FormControl<String>(validators: []),
      'agriculturistType': FormControl<String>(validators: []),
      'farmerCategory': FormControl<String>(validators: []),
      'farmerType': FormControl<String>(validators: []),
      'jlgGroupName': FormControl<String>(validators: []),
      'jlgMemberCount': FormControl<String>(validators: []),
      'jlgRegistrationNumber': FormControl<String>(validators: []),
      'jlgRegistrationDate': FormControl<String>(validators: []),
      'religion': FormControl<String>(validators: []),
      'caste': FormControl<String>(validators: []),
      'gender': FormControl<String>(validators: []),
    });
  }

  /// Other products form
  /// General form for other product types
  static FormGroup buildOtherForm() {
    return FormGroup({
      ..._getBaseFields(),
      'natureOfActivity': FormControl<String>(validators: []),
      'occupationType': FormControl<String>(validators: []),
      'agriculturistType': FormControl<String>(validators: []),
      'farmerCategory': FormControl<String>(validators: []),
      'farmerType': FormControl<String>(validators: []),
      'religion': FormControl<String>(validators: []),
      'caste': FormControl<String>(validators: []),
      'gender': FormControl<String>(validators: []),
      'subActivity': FormControl<String>(validators: []),
    });
  }

  /// Get form builder based on scheme type
  /// Returns the appropriate FormGroup for the selected scheme
  static FormGroup getFormForScheme(String schemeType) {
    switch (schemeType.toUpperCase()) {
      case 'SHG':
        return buildSHGForm();
      case 'JLG':
        return buildJLGForm();
      default:
        return buildOtherForm();
    }
  }
}
