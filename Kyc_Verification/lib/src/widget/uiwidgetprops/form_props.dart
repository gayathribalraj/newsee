/*
  @author   : Gayathri
  @created  : 08/11/2025
  @desc     : Reusable class for handling form field properties like label, hint, mandatory flag, max length, keyboard type, etc.
*/
import 'package:reactive_forms/reactive_forms.dart';

typedef ValidationFunction = String Function(AbstractControl control);

class FormProps {
  final String formControlName;
  final String label;
  final String? hint;
  final bool mandatory;
  final int? maxLength;
  final ValidationFunction? validator;


  const FormProps({
    required this.formControlName,
    required this.label,
    this.hint,
    this.mandatory = false,
    this.maxLength,
    this.validator,

  });
}
