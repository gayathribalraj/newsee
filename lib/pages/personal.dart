import 'package:flutter/material.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Personal extends StatelessWidget {
  final String title;

  Personal(String s, {required this.title, super.key});

  final form = FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'firstname': FormControl<String>(validators: [Validators.required]),
    'middlename': FormControl<String>(validators: [Validators.required]),
    'lastname': FormControl<String>(validators: [Validators.required]),
    'dateofbirth': FormControl<String>(validators: [Validators.required]),
    'primarymobilenumber': FormControl<String>(
      validators: [Validators.required],
    ),
    'secondarymobilenumber': FormControl<String>(
      validators: [Validators.required],
    ),
    'emailid': FormControl<String>(validators: [Validators.email]),
    'panno': FormControl<String>(validators: [Validators.required]),
    'aadhaarno': FormControl<String>(validators: [Validators.required]),
    'loanamount': FormControl<String>(validators: [Validators.required]),
    'natureofactivity': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Details"),
        automaticallyImplyLeading: false,
      ),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchableDropdown(
                  controlName: 'title',
                  label: 'Title',
                  items: [
                    'COLONEL',
                    'DR',
                    'LT.COL',
                    'M/S',
                    'MAJOR',
                    'MASTER(MINOR)',
                    'MESSERS',
                    'MIGRATION DEFAULT',
                    'MISS',
                    'MOHAMMAD',
                    'MR',
                    'MRS',
                    'MX',
                    'SHEIKH',
                    'SIR',
                  ],
                ),
                CustomTextField('firstname', 'First Name'),
                CustomTextField('middlename', 'Middle Name'),
                CustomTextField('lastname', 'Last Name'),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ReactiveTextField<String>(
                    formControlName: 'dateofbirth',
                    validationMessages: {
                      ValidationMessage.required:
                          (error) => 'Date of Birth is required',
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date Of Birth',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: (control) async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(
                          Duration(days: 365 * 18),
                        ),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        final formatted =
                            "${pickedDate.day.toString().padLeft(2, '0')}/"
                            "${pickedDate.month.toString().padLeft(2, '0')}/"
                            "${pickedDate.year}";
                        form.control('dateofbirth').value = formatted;
                      }
                    },
                  ),
                ),
                IntegerTextField(
                  'primarymobilenumber',
                  'Primary Mobile Number',
                ),
                IntegerTextField(
                  'secondarymobilenumber',
                  'Secondary Mobile Number',
                ),
                CustomTextField('emailid', 'Email ID'),
                CustomTextField('panno', 'PAN No'),
                IntegerTextField('aadhaarno', 'Aadhaar No'),
                IntegerTextField('loanamount', 'Loan Amount Required'),
                Dropdown(
                  controlName: 'natureofactivity',
                  label: 'Nature Of Activity',
                  items: [],
                ),
                SizedBox(height: 20),
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
