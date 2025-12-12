/*
  @author   : karthick.d  06/10/2025
  @desc     : custom standard widget for dropdown control
              use this widget in place of flutter dropdown
              customized for consistant look and feel
              across the application
*/
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class KeyValueReactiveDropdown extends StatefulWidget {
  final double width;
  final String labeltext;
  final List<dynamic> dropdownEntries;
  final dynamic initialSelection;
  final ValueChanged? onSelected;
  final String formControlName;
  const KeyValueReactiveDropdown({
    super.key,
    required this.width,
    required this.labeltext,
    required this.dropdownEntries,
    this.initialSelection = 'false',
    this.onSelected,
    required this.formControlName,
  });

  @override
  State<KeyValueReactiveDropdown> createState() => _KeyValueDropdownState();
}

class _KeyValueDropdownState extends State<KeyValueReactiveDropdown> {
  late final List<DropdownMenuItem> dropdownItems;

  @override
  void initState() {
    dropdownItems = renderDropDownItems();
  }

  List<DropdownMenuItem> renderDropDownItems() {
    return List.from(widget.dropdownEntries).asMap().entries.map((e) {
      return DropdownMenuItem(
        value: e.value.toString().toLowerCase(),
        child: Text(e.value, style: TextStyle(fontSize: 12)),
      );
    }).toList();
  }

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

          child: ReactiveDropdownField(
            formControlName: widget.formControlName,
            // width: widget.width * 0.5,
            // initialSelection: widget.initialSelection,
            items: dropdownItems,

            // trailingIcon: Transform.translate(
            //   offset: Offset(0, -6),
            //   child: Icon(Icons.arrow_drop_down, size: 18),
            // ),
            // textStyle: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              constraints: BoxConstraints(maxHeight: 25),

              contentPadding: EdgeInsets.only(left: 10),
              border: OutlineInputBorder(),
            ),

            onChanged: widget.onSelected,
          ),
        ),
      ],
    );
  }
}
