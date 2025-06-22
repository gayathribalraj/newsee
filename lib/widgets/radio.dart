import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

Widget RadioButton(String label, String controlName, String yes, String no) {
  return Padding(
    padding: const EdgeInsets.all(17),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Row(
          children: [
            Expanded(
              child: ReactiveRadioListTile<bool>(
                formControlName: controlName,
                title: Text(yes),
                value: true,
              ),
            ),
            Expanded(
              child: ReactiveRadioListTile<bool>(
                formControlName: controlName,
                title: Text(no),
                value: false,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
