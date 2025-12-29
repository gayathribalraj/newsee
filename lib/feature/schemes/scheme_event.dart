import 'package:newsee/feature/schemes/scheme_type.dart';

abstract class SchemeEvent {}

class SelectSchemeEvent extends SchemeEvent {
  final SchemeType scheme;
  SelectSchemeEvent(this.scheme);
}

/// Event to initialize form based on selected scheme
class InitializeSchemeFormEvent extends SchemeEvent {
  final SchemeType scheme;
  InitializeSchemeFormEvent(this.scheme);
}

