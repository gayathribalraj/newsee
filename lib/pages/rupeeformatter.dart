/*
 @created on : May 16, 2025
 @author : Akshayaa 
 @description : A custom TextInputFormatter that applies Indian Rupee style
                comma formatting (e.g. 1,00,000) while typing and allows
                only numeric digits.
*/

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Rupeeformatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-numeric characters except for the decimal separator
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d,.]'), '');
    print('cleanText $cleanText');

    // Handle decimal separator (replace comma with empty if needed)
    String formattedText = cleanText.replaceAll(',', '');
    print('formattedText $formattedText');
    // Format with thousands separators and two decimal places
    try {
      final number = double.parse(formattedText);
      final formatter = NumberFormat(
        '#,##,##0.00',
        'en_US',
      ); // Adjust locale as needed
      String newFormattedText = formatter.format(number);
      print('newFormattedText $newFormattedText');

      // find position just before ".00"
      final int decimalIndex = newFormattedText.indexOf('.00');
      final int cursorPosition =
          decimalIndex > 0 ? decimalIndex : newFormattedText.length;

      return TextEditingValue(
        text: newFormattedText,
        selection: TextSelection.collapsed(offset: cursorPosition),
      );
    } catch (e) {
      print('oldValue $oldValue');
      // If parsing fails return original value
      return oldValue;
    }
  }
}
