/*
 @created on : May 16,2025
 @author : Akshayaa 
 Description : A reusable reactive text field integrated with the reactive forms package.
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomTextField extends StatelessWidget {
  final String controlName;
  final String label;
  final bool mantatory;
  bool? autoCapitalize;
  int? maxlength;
  final Key? fieldKey;
  final List<TextInputFormatter>? inputFormatters;
  CustomTextField({
    this.fieldKey,
    required this.controlName,
    required this.label,
    required this.mantatory,
    this.autoCapitalize,
    this.maxlength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ReactiveTextField<String>(
        key: fieldKey,
        autofocus: false,
        formControlName: controlName,
        maxLength: maxlength,
        inputFormatters: inputFormatters,
        textCapitalization:
            autoCapitalize == true
                ? TextCapitalization.characters
                : TextCapitalization.none,
        validationMessages: {
          ValidationMessage.required: (error) => '$label is required',
          ValidationMessage.email: (error) => 'Enter valid $label',
          ValidationMessage.pattern: (_) => 'Enter valid $label',
        },
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                  text: mantatory ? ' *' : '',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
