import 'package:flutter/material.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/radio.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/AppData/app_forms.dart';

class LandInfoFormPage extends StatelessWidget {
  final String title;

  LandInfoFormPage({required this.title, super.key});

  // final FormGroup form = FormGroup({
  //   'applicantName': FormControl<String>(validators: [Validators.required]),
  //   'locationOfFarm': FormControl<String>(validators: [Validators.required]),
  //   'state': FormControl<String>(validators: [Validators.required]),
  //   'taluk': FormControl<String>(validators: [Validators.required]),
  //   'firka': FormControl<String>(validators: [Validators.required]),
  //   'totalAcreage': FormControl<String>(validators: [Validators.required]),
  //   'irrigatedLand': FormControl<String>(validators: [Validators.required]),
  //   'compactBlocks': FormControl<String>(validators: [Validators.required]),
  //   'holdingsTally': FormControl<String>(validators: [Validators.required]),
  //   'landOwnedByApplicant': FormControl<bool>(
  //     validators: [Validators.required],
  //   ),
  //   'distanceFromBranch': FormControl<String>(
  //     validators: [Validators.required],
  //   ),
  //   'district': FormControl<String>(validators: [Validators.required]),
  //   'village': FormControl<String>(validators: [Validators.required]),
  //   'surveyNo': FormControl<String>(validators: [Validators.required]),
  //   'natureOfRight': FormControl<String>(validators: [Validators.required]),
  //   'irrigationFacilities': FormControl<String>(
  //     validators: [Validators.required],
  //   ),
  //   'affectedByCeiling': FormControl<String>(validators: [Validators.required]),
  //   'landAgriActive': FormControl<String>(validators: [Validators.required]),
  //   'guarantorapplicable': FormControl<String>(
  //     validators: [Validators.required],
  //   ),
  // });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Land Holding Details")),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Dropdown(
                  controlName: 'applicantName',
                  label: 'Applicant Name / Guarantor',
                  items: ['--Select--', 'Applicant 1', 'Applicant 2'],
                ),
                CustomTextField(
                  controlName: 'locationOfFarm',
                  label: 'Location of Farm',
                  mantatory: true,
                ),
                Dropdown(
                  controlName: 'state',
                  label: 'State',
                  items: ['--Select--', 'Tamil Nadu', 'Karnataka'],
                ),
                //  SearchableDropdown(
                //   controlName: 'state',
                //   label: 'State',
                //   items: state.stateCityMaster!,
                //   onChangeListener: (GeographyMaster val) {
                //     form.controls['state']?.updateValue(val.code);
                //     globalLoadingBloc.add(
                //       ShowLoading(message: "Fetching city..."),
                //     );
                //     context.read<AddressDetailsBloc>().add(
                //       OnStateCityChangeEvent(stateCode: val.code),
                //     );
                //   },
                //   selItem: () => null,
                // ),
                CustomTextField(
                  controlName: 'taluk',
                  label: 'Taluk',
                  mantatory: true,
                ),
                CustomTextField(
                  controlName: 'firka',
                  label: 'Firka (as per Adangal/Chitta/Patta)',
                  mantatory: true,
                ),
                CustomTextField(
                  controlName: 'totalAcreage',
                  label: 'Total Acreage (in Acres)',
                  mantatory: true,
                ),
                CustomTextField(
                  controlName: 'irrigatedLand',
                  label: 'Irrigated Land (in Acres)',
                  mantatory: true,
                ),
                Dropdown(
                  controlName: 'compactBlocks',
                  label: 'Lands situated in compact blocks',
                  items: ['Yes', 'No'],
                ),
                RadioButton(
                  'Land owned by the Applicant',
                  'landOwnedByApplicant',
                ),
                CustomTextField(
                  controlName: 'distanceFromBranch',
                  label: 'Distance from Branch (in Kms)',
                  mantatory: true,
                ),
                SearchableDropdown(
                  controlName: 'district',
                  label: 'District',
                  items: ['--Select--', 'District A', 'District B'],
                  selItem: () {},
                ),
                //   SearchableDropdown(
                //   controlName: 'area',
                //   label: 'District',
                //   items: state.districtMaster!,
                //   onChangeListener: (GeographyMaster val) {
                //     form.controls['area']?.updateValue(val.code);
                //   },
                //   selItem: () => null,
                // ),
                CustomTextField(
                  controlName: 'village',
                  label: 'Village',
                  mantatory: true,
                ),
                CustomTextField(
                  controlName: 'surveyNo',
                  label: 'Survey No.',
                  mantatory: true,
                ),
                SearchableDropdown(
                  controlName: 'natureOfRight',
                  label: 'Nature of Right',
                  items: ['--Select--', 'Owner', 'Leaseholder'],
                  selItem: () {},
                  mantatory: true,
                ),
                SearchableDropdown(
                  controlName: 'irrigationFacilities',
                  label: 'Nature of Irrigation facilities',
                  items: ['--Select--', 'Canal', 'Well'],
                  selItem: () {},
                ),
                Dropdown(
                  controlName: 'affectedByCeiling',
                  label: 'Affected by land ceiling enactments',
                  items: ['Yes', 'No'],
                ),
                Dropdown(
                  controlName: 'landAgriActive',
                  label: 'Whether Land Agriculturally Active',
                  items: ['Yes', 'No'],
                ),

                SizedBox(height: 30),
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
