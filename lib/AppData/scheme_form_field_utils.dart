import 'package:newsee/feature/schemes/scheme_type.dart';

/// Utility class to manage form fields visibility and requirements
/// based on the selected scheme type (JLG, SHG, Other)
class SchemeFormFieldUtils {
  /// Fields visible for SHG form
  static const List<String> shgFields = [
    'title',
    'firstName',
    'middleName',
    'lastName',
    'dob',
    'residentialStatus',
    'primaryMobileNumber',
    'secondaryMobileNumber',
    'email',
    'aadhaar',
    'panNumber',
    'aadharRefNo',
    'loanAmountRequested',
    'natureOfActivity',
    'occupationType',
    'subActivity',
    'shgGroupName',
    'shgMemberCount',
    'shgRegistrationNumber',
    'shgRegistrationDate',
  ];

  /// Fields visible for JLG form
  static const List<String> jlgFields = [
    'title',
    'firstName',
    'middleName',
    'lastName',
    'dob',
    'residentialStatus',
    'primaryMobileNumber',
    'secondaryMobileNumber',
    'email',
    'aadhaar',
    'panNumber',
    'aadharRefNo',
    'loanAmountRequested',
    'natureOfActivity',
    'occupationType',
    'agriculturistType',
    'farmerCategory',
    'farmerType',
    'jlgGroupName',
    'jlgMemberCount',
    'jlgRegistrationNumber',
    'jlgRegistrationDate',
    'religion',
    'caste',
    'gender',
  ];

  /// Fields visible for Other product form
  static const List<String> otherFields = [
    'title',
    'firstName',
    'middleName',
    'lastName',
    'dob',
    'residentialStatus',
    'primaryMobileNumber',
    'secondaryMobileNumber',
    'email',
    'aadhaar',
    'panNumber',
    'aadharRefNo',
    'loanAmountRequested',
    'natureOfActivity',
    'occupationType',
    'agriculturistType',
    'farmerCategory',
    'farmerType',
    'religion',
    'caste',
    'gender',
    'subActivity',
  ];

  /// Get visible fields for a scheme type
  static List<String> getVisibleFieldsForScheme(SchemeType scheme) {
    switch (scheme) {
      case SchemeType.shg:
        return shgFields;
      case SchemeType.jlg:
        return jlgFields;
      case SchemeType.other:
        return otherFields;
    }
  }

  /// Check if a field should be visible for the given scheme
  static bool isFieldVisibleForScheme(String fieldName, SchemeType scheme) {
    return getVisibleFieldsForScheme(scheme).contains(fieldName);
  }

  /// Get mandatory fields for a scheme type
  static List<String> getMandatoryFieldsForScheme(SchemeType scheme) {
    const baseMandatory = [
      'title',
      'firstName',
      'dob',
      'primaryMobileNumber',
      'secondaryMobileNumber',
      'loanAmountRequested',
    ];

    switch (scheme) {
      case SchemeType.shg:
        return [...baseMandatory, 'natureOfActivity', 'occupationType'];
      case SchemeType.jlg:
        return [
          ...baseMandatory,
          'natureOfActivity',
          'occupationType',
          'agriculturistType',
        ];
      case SchemeType.other:
        return baseMandatory;
    }
  }

  /// Check if field is mandatory for scheme
  static bool isFieldMandatoryForScheme(String fieldName, SchemeType scheme) {
    return getMandatoryFieldsForScheme(scheme).contains(fieldName);
  }
}
