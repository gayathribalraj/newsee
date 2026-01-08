import 'package:newsee/feature/scheme/widget/scheme_type.dart';

abstract class SchemeEvent {}

class SelectSchemeEvent extends SchemeEvent {
  final SchemeType scheme;
  SelectSchemeEvent(this.scheme);
}
