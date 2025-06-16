import 'package:flutter/material.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoanDetailsPage extends StatelessWidget {
  final String title;

  LoanDetailsPage(String s, {super.key, required this.title});

  final form = FormGroup({
    'maincategory': FormControl<String>(validators: [Validators.required]),
    'subcategory': FormControl<String>(validators: [Validators.required]),
    'loanproduct': FormControl<String>(validators: [Validators.required]),
    'loanamount': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Loan Details")),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Dropdown(
                  controlName: 'subcategory',
                  label: 'Sub Category',
                  items: ['', ''],
                ),
                Dropdown(
                  controlName: 'loanproduct',
                  label: 'Loan Product',
                  items: ['', ''],
                ),
                IntegerTextField(
                  controlName: 'loanamount',
                  label: 'Loan Amount Requested(₹)',
                  mantatory: true,
                ),
                Center(
                  child: ElevatedButton(
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
