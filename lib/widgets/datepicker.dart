import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DatePickerField extends StatelessWidget {
  final String formControlName;
  final String label;

  const DatePickerField({
    super.key,
    required this.formControlName,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ReactiveTextField<String>(
        formControlName: formControlName,
        readOnly: true,
        validationMessages: {
          ValidationMessage.required: (_) => '$label is required',
        },
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: (control) async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            final formatted =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            control.value = formatted; 
          }
        },
      ),
    );
  }
}
