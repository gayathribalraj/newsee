
import 'package:reactive_forms/reactive_forms.dart';

abstract class PoultryEvent {}

class AddPoultryDetails extends PoultryEvent {
  final Map<String, dynamic> details;
  AddPoultryDetails(this.details);
}

class RemovePoultryDetails extends PoultryEvent {
  final int index;
  RemovePoultryDetails(this.index);
}

class PatchPoultryForm extends PoultryEvent {
  final FormGroup form;
  final Map<String, dynamic> details;
  PatchPoultryForm({required this.form, required this.details});
}
