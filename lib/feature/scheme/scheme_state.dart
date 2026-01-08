
import 'package:newsee/feature/scheme/widget/scheme_type.dart';

class SchemeState {
  final SchemeType selectedScheme;

  const SchemeState({required this.selectedScheme});

  bool get isSHG => selectedScheme == SchemeType.shg;
  bool get isJLG => selectedScheme == SchemeType.jlg;
  bool get isBase => selectedScheme == SchemeType.base;

  SchemeState copyWith({SchemeType? selectedScheme}) {
    return SchemeState(selectedScheme: selectedScheme ?? this.selectedScheme);
  }
}
