/*
  @author   : karthick.d  06/10/2025
  @desc     : custom standard widget for dropdown control
              use this widget in place of flutter dropdown
              customized for consistant look and feel
              across the application
*/
import 'package:flutter/material.dart';

class KeyValueDropdown extends StatefulWidget {
  final double width;
  final String labeltext;
  final List<DropdownMenuEntry> dropdownEntries;
  final dynamic initialSelection;
  final ValueChanged? onSelected;
  const KeyValueDropdown({
    super.key,
    required this.width,
    required this.labeltext,
    required this.dropdownEntries,
    this.initialSelection = 'false',
    this.onSelected,
  });

  @override
  State<KeyValueDropdown> createState() => _KeyValueDropdownState();
}

class _KeyValueDropdownState extends State<KeyValueDropdown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            width: widget.width * 0.25,
            child: Text(
              widget.labeltext,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        SizedBox(
          width: widget.width * 0.5,
          height: 25,

          child: DropdownMenu(
            width: widget.width * 0.5,
            initialSelection: widget.initialSelection,
            dropdownMenuEntries: widget.dropdownEntries,
            trailingIcon: Transform.translate(
              offset: Offset(0, -6),
              child: Icon(Icons.arrow_drop_down, size: 18),
            ),
            textStyle: TextStyle(fontSize: 12),

            inputDecorationTheme: InputDecorationTheme(
              constraints: BoxConstraints(maxHeight: 25),

              contentPadding: EdgeInsets.only(left: 10),
              border: OutlineInputBorder(),
            ),

            onSelected: widget.onSelected,
          ),
        ),
      ],
    );
  }
}
