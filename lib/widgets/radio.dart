import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

Widget RadioButton(String label, String controlName) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: [
            Expanded(
              child: ReactiveRadioListTile<bool>(
                formControlName: controlName,
                title: Text('Yes'),
                value: true,
              ),
            ),
            Expanded(
              child: ReactiveRadioListTile<bool>(
                formControlName: controlName,
                title: Text('No'),
                value: false,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
