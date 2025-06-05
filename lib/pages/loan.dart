import 'package:flutter/material.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Loan extends StatelessWidget {
  final String title;

  Loan(String s, {super.key, required this.title});

  final form = FormGroup({
    'typeofloan': FormControl<String>(validators: [Validators.required]),
    'maincategory': FormControl<String>(validators: [Validators.required]),
    'subcategory': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loan Details"),
        automaticallyImplyLeading: false,
      ),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchableDropdown(
                  controlName: 'typeofloan',
                  label: 'Type Of Loan',
                  items: ['Kisan Credit Card', 'Agri Jewel Loan Scheme'],
                ),
                Dropdown(
                  controlName: 'maincategory',
                  label: 'Main Category',
                  items: ['Kisan Credit Card'],
                ),
                Dropdown(
                  controlName: 'subcategory',
                  label: 'Sub Category',
                  items: ['Kisan Credit Card'],
                ),
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
