import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/radio.dart';

class LandInfoFormPage extends StatefulWidget {
  final String title;

  const LandInfoFormPage({required this.title, super.key});

  @override
  State<LandInfoFormPage> createState() => _LandInfoFormPageState();
}

class _LandInfoFormPageState extends State<LandInfoFormPage> {
  final FormGroup form = FormGroup({
    'applicantName': FormControl<String>(validators: [Validators.required]),
    'locationOfFarm': FormControl<String>(validators: [Validators.required]),
    'state': FormControl<String>(validators: [Validators.required]),
    'taluk': FormControl<String>(validators: [Validators.required]),
    'firka': FormControl<String>(validators: [Validators.required]),
    'totalAcreage': FormControl<String>(validators: [Validators.required]),
    'irrigatedLand': FormControl<String>(validators: [Validators.required]),
    'compactBlocks': FormControl<String>(validators: [Validators.required]),
    'landOwnedByApplicant': FormControl<bool>(
      validators: [Validators.required],
    ),
    'distanceFromBranch': FormControl<String>(
      validators: [Validators.required],
    ),
    'district': FormControl<String>(validators: [Validators.required]),
    'village': FormControl<String>(validators: [Validators.required]),
    'surveyNo': FormControl<String>(validators: [Validators.required]),
    'natureOfRight': FormControl<String>(validators: [Validators.required]),
    'irrigationFacilities': FormControl<String>(
      validators: [Validators.required],
    ),
    'affectedByCeiling': FormControl<String>(validators: [Validators.required]),
    'landAgriActive': FormControl<String>(validators: [Validators.required]),
  });

  int step = 0;

  void handleSubmit() {
    if (form.valid) {
      print("Form Submitted with: ${form.value}");
      setState(() {
        step++;
        form.reset();
      });
    } else {
      form.markAllAsTouched();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Land Holding Details")),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  children: [
                    Dropdown(
                      controlName: 'applicantName',
                      label: 'Applicant Name / Guarantor',
                      items: [
                        '--Select--',
                        'Ravi Kumar',
                        'Sita Devi',
                        'Vikram R',
                      ],
                    ),
                    CustomTextField(
                      controlName: 'locationOfFarm',
                      label: 'Location of Farm',
                      mantatory: true,
                    ),
                    Dropdown(
                      controlName: 'state',
                      label: 'State',
                      items: [
                        '--Select--',
                        'Tamil Nadu',
                        'Kerala',
                        'Karnataka',
                      ],
                    ),
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
                      items: ['--Select--', 'Yes', 'No'],
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
                    Dropdown(
                      controlName: 'district',
                      label: 'District',
                      items: ['--Select--', 'Chennai', 'Madurai', 'Coimbatore'],
                    ),
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
                    Dropdown(
                      controlName: 'natureOfRight',
                      label: 'Nature of Right',
                      items: [
                        '--Select--',
                        'Owned',
                        'Leaseholder',
                        'Ancestral',
                      ],
                    ),
                    Dropdown(
                      controlName: 'irrigationFacilities',
                      label: 'Nature of Irrigation facilities',
                      items: ['--Select--', 'Canal', 'Well', 'Tube Wells'],
                    ),
                    Dropdown(
                      controlName: 'affectedByCeiling',
                      label: 'Affected by land ceiling enactments',
                      items: ['--Select--', 'Yes', 'No'],
                    ),
                    Dropdown(
                      controlName: 'landAgriActive',
                      label: 'Whether Land Agriculturally Active',
                      items: ['--Select--', 'Yes', 'No'],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: handleSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Next'),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        '$step',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
