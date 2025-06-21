import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/landholding/domain/modal/LandData.dart';
import 'package:newsee/feature/landholding/presentation/bloc/land_holding_bloc.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/radio.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';

class LandInfoFormPage extends StatelessWidget {
  final String title;

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

  LandInfoFormPage({super.key, required this.title});

  void handleSubmit(BuildContext context, LandHoldingState state) {
    if (form.valid) {
      final landFormData = Landdata.fromMap(form.value);
      context.read<LandHoldingBloc>().add(
        LandDetailsSaveEvent(landData: landFormData),
      );
    } else {
      form.markAllAsTouched();
    }
  }

  void showBottomSheet(BuildContext context, LandHoldingState state) {
    final entries = state.landData ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => SizedBox(
            height: 300,
            child:
                entries.isEmpty
                    ? const Center(child: Text('No saved entries.'))
                    : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: entries.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (ctx, index) {
                        final item = entries[index];
                        return ListTile(
                          title: Text(item.applicantName ?? ''),
                          subtitle: Text(item.locationOfFarm ?? ''),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            context.read<LandHoldingBloc>().add(
                              LandDetailsLoadEvent(landData: item),
                            );
                          },
                        );
                      },
                    ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocProvider(
        create: (_) => LandHoldingBloc(),
        child: BlocConsumer<LandHoldingBloc, LandHoldingState>(
          listener: (context, state) {
            if (state.status == SaveState.success) {
              form.reset();
            }

            if (state.selectedLandData != null) {
              form.patchValue(state.selectedLandData!.toMap());
            }
          },
          builder: (context, state) {
            return ReactiveForm(
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
                          // Dropdown(
                          //   controlName: 'state',
                          //   label: 'State',
                          //   items: [
                          //     '--Select--',
                          //     'Tamil Nadu',
                          //     'Kerala',
                          //     'Karnataka',
                          //   ],
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
                            items: ['--Select--', 'Yes', 'No'],
                          ),
                          RadioButton(
                            'Land owned by the Applicant',
                            'landOwnedByApplicant',
                            'Yes',
                            'No',
                          ),
                          CustomTextField(
                            controlName: 'distanceFromBranch',
                            label: 'Distance from Branch (in Kms)',
                            mantatory: true,
                          ),
                          // Dropdown(
                          //   controlName: 'district',
                          //   label: 'District',
                          //   items: [
                          //     '--Select--',
                          //     'Chennai',
                          //     'Madurai',
                          //     'Coimbatore',
                          //   ],
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
                            items: [
                              '--Select--',
                              'Canal',
                              'Well',
                              'Tube Wells',
                            ],
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
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () => handleSubmit(context, state),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 90,
                      right: 16,
                      child: FloatingActionButton(
                        heroTag: 'view_button',
                        backgroundColor: Colors.white,
                        onPressed: () => showBottomSheet(context, state),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.remove_red_eye,
                              color: Colors.blue,
                              size: 28,
                            ),
                            if (state.landData != null)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${state.landData?.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
