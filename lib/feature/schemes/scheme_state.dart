
import 'package:newsee/feature/schemes/scheme_type.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SchemeState {
  final SchemeType selectedScheme;
  final FormGroup? dynamicForm;
  final String formType;

  const SchemeState({
    required this.selectedScheme,
    this.dynamicForm,
    this.formType = '',
  });

  bool get isSHG => selectedScheme == SchemeType.shg;
  bool get isJLG => selectedScheme == SchemeType.jlg;
  bool get isOther => selectedScheme == SchemeType.other;

  String get schemeLabel {
    switch (selectedScheme) {
      case SchemeType.shg:
        return 'SHG';
      case SchemeType.jlg:
        return 'JLG';
      case SchemeType.other:
        return 'Other';
    }
  }

  SchemeState copyWith({
    SchemeType? selectedScheme,
    FormGroup? dynamicForm,
    String? formType,
  }) {
    return SchemeState(
      selectedScheme: selectedScheme ?? this.selectedScheme,
      dynamicForm: dynamicForm ?? this.dynamicForm,
      formType: formType ?? this.formType,
    );
  }
}
