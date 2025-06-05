import 'package:flutter/material.dart';
import 'package:keyboard_detection/keyboard_detection.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DedupeSearch extends StatefulWidget {
  @override
  State<DedupeSearch> createState() => DedupeSearchState();
}

class DedupeSearchState extends State<DedupeSearch> {
  bool keyboardVisible = false;
  final dedupeForm = FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'firstname': FormControl<String>(validators: [Validators.required]),
    'lastname': FormControl<String>(validators: [Validators.required]),
    'mobilenumber': FormControl<String>(validators: [Validators.required]),
    'pan': FormControl<String>(validators: [Validators.required]),
    'aadhaar': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    print("KeyboardDetectionController is keyboardVisible $keyboardVisible");
    return
    // KeyboardDetection(
    // controller: KeyboardDetectionController(
    //   onChanged: (value) {
    //     print("KeyboardDetectionController is keyboardVisibleState $value");
    //     if (value == KeyboardState.visible) {
    //       setState(() {
    //          keyboardVisible = true;
    //       });
    //     } else {
    //       setState(() {
    //          keyboardVisible = false;
    //       });
    //     }
    //   }
    // ),
    // child:
    // Scaffold(
    //   appBar: keyboardVisible ? null : AppBar(title: Text("Dedupe Search")),
    //   body:
    ReactiveForm(
      formGroup: dedupeForm,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Dropdown(
                controlName: 'title',
                label: 'Title',
                items: ['Mr', 'Mrs', 'Miss', 'Others'],
              ),
              CustomTextField('firstname', 'First Name'),
              CustomTextField('lastname', 'Last Name'),
              IntegerTextField('mobilenumber', 'Mobile Number'),
              CustomTextField('pan', 'PAN Number'),
              IntegerTextField('aadhaar', 'Aadhaar Number'),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 3, 9, 110),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text("Search"),
              ),
            ],
          ),
        ),
      ),
    );
    //   )
    // );
  }
}
