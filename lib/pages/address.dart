import 'package:flutter/material.dart';
import 'package:newsee/widgets/alpha_text_field.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Address extends StatelessWidget {
  final String title;

  Address(String s, {required this.title, super.key});

  final form = FormGroup({
    'addresstype': FormControl<String>(validators: [Validators.required]),
    'address1': FormControl<String>(validators: [Validators.required]),
    'address2': FormControl<String>(validators: [Validators.required]),
    'address3': FormControl<String>(validators: [Validators.required]),
    'state': FormControl<String>(validators: [Validators.required]),
    'citydistrict': FormControl<String>(validators: [Validators.required]),
    'area': FormControl<String>(validators: [Validators.required]),
    'pincode': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address Details"),
        automaticallyImplyLeading: false,
      ),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Dropdown(
                  controlName: 'addresstype',
                  label: 'Address Type',
                  items: ['Present', 'Permanent'],
                ),
                CustomTextField('address1', 'Address 1'),
                CustomTextField('address2', 'Address 2'),
                CustomTextField('address3', 'Address 3'),
                SearchableDropdown(
                  controlName: 'state',
                  label: 'State',
                  items: ['Tamil Nadu', 'Kerala'],
                ),
                SearchableDropdown(
                  controlName: 'citydistrict',
                  label: 'City/District',
                  items: ['Chennai', 'Madurai'],
                ),
                SearchableDropdown(
                  controlName: 'area',
                  label: 'Area',
                  items: ['Sholinganallur', 'Navalur'],
                ),
                IntegerTextField('pincode', 'Pin Code'),
                SizedBox(height: 20),
                // ElevatedButton(onPressed: () {}, child: Text("ADD")),
                // SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 3, 9, 110),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (form.valid) {
                        final tabController = DefaultTabController.of(context);
                        if (tabController.index < tabController.length - 1) {
                          tabController.animateTo(tabController.index + 1);
                        }
                      } else {
                        form.markAllAsTouched();
                      }
                    },
                    child: Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
