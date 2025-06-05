import 'package:flutter/material.dart';
import 'package:keyboard_detection/keyboard_detection.dart';
import 'package:newsee/pages/page/cif_search.dart';
import 'package:newsee/pages/page/dedup_search.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomerType extends StatefulWidget {
  @override
  State<CustomerType> createState() => CustomerTypeState();
}

class CustomerTypeState extends State<CustomerType> {
  bool keyboardVisible = false;
  String? customerType;
  final customerTypeForm = FormGroup({
    'customertype': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    print("KeyboardDetectionController is keyboardVisible $keyboardVisible");
    return KeyboardDetection(
      controller: KeyboardDetectionController(
        onChanged: (value) {
          print("KeyboardDetectionController is keyboardVisibleState $value");
          if (value == KeyboardState.visible) {
            setState(() {
              keyboardVisible = true;
            });
          } else {
            setState(() {
              keyboardVisible = false;
            });
          }
        },
      ),
      child: Scaffold(
        appBar: keyboardVisible ? null : AppBar(title: Text("Dedupe Search")),
        body: ReactiveForm(
          formGroup: customerTypeForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Dropdown(
                controlName: 'customertype',
                label: 'Customer Type',
                items: ['Existing Customer', 'New Customer'],

                // onchange: (value) {
                //   print("onChange function called, $value");
                //   setState(() {
                //     print("customerTypeForm.control('customertype').value => ${customerTypeForm.control('customertype').value}");
                //     customerType = customerTypeForm.control('customertype').value;
                //   });
                // }
              ),
              _buildCustomerWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerWidget() {
    if (customerType == null) return SizedBox(height: 10);
    if (customerType == "New Customer") return DedupeSearch();
    return CifSearchPage();
  }
}
