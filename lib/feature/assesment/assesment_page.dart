import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/feature/assesment/particulars_of_investment.dart';
import 'package:newsee/feature/assesment/technicaldetails/digging_form.dart';
import 'package:newsee/feature/assesment/technicaldetails/laying_form.dart';
import 'package:newsee/feature/assesment/technicaldetails/pumpset_form_mapper.dart';
import 'package:newsee/feature/assesment/technicaldetails/sprinkler_form.dart';
import 'package:newsee/feature/dynamic_form/dynamic_form_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/widgets/cupertino_expansion_tile.dart';
import 'package:newsee/widgets/expansion_controller.dart';
import 'package:newsee/widgets/sysmo_alert.dart';

class AssmentDetails extends StatelessWidget {
  final String leadId;
  const AssmentDetails({super.key, required this.leadId});

  @override
  Widget build(BuildContext context) {

    // Create form groups dynamically
    
    final particularsOfInvestmentForm = FormGroup({
      for (var field in particularsOfInvestmentFormMapper)
        field.formName: FormControl<String>(validators: [Validators.required]),
    });

    final diggingForm = FormGroup({
      for (var field in diggingFormMapper)
        field.formName: FormControl<String>(validators: [Validators.required]),
    });

    final pumpSetForm = FormGroup({
      for (var field in pumpSetFormMapper)
        field.formName: FormControl<String>(validators: [Validators.required]),
    });

    final layingForm = FormGroup({
      for (var field in layingFormMapper)
        field.formName: FormControl<String>(validators: [Validators.required]),
    });

    final sprinklerForm = FormGroup({
      for (var field in sprinklerFormMapper)
        field.formName: FormControl<String>(validators: [Validators.required]),
    });

    // Attach totalCost listener

    attachTotalCostListener(particularsOfInvestmentForm);

    final controller = ExpansionController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assessment Details"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            /// 1. Particulars Of Investment
            ReactiveForm(
              formGroup: particularsOfInvestmentForm,
              child: CupertinoExpansionTile(
                index: 0,
                icon: Icons.work_outline,
                controller: controller,
                title: "Particulars Of Investment",
                subtitle: "Add your particulars of investment details here",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        "Particulars Of Investment Form",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (var field in particularsOfInvestmentFormMapper)
                      buildField(field, particularsOfInvestmentForm),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            /// 2. Digging Form
            ReactiveForm(
              formGroup: diggingForm,
              child: CupertinoExpansionTile(
                index: 1,
                icon: Icons.construction,
                controller: controller,
                title: "Digging Details",
                subtitle: "Add your digging details here",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        "Digging Form",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (var field in diggingFormMapper)
                      buildField(field, diggingForm),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            /// 3. Pump Set Form
            ReactiveForm(
              formGroup: pumpSetForm,
              child: CupertinoExpansionTile(
                index: 2,
                icon: Icons.power,
                controller: controller,
                title: "Pump Set Details",
                subtitle: "Add your pump set details here",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        "Pump Set Form",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (var field in pumpSetFormMapper)
                      buildField(field, pumpSetForm),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            /// 4. Laying Form
            ReactiveForm(
              formGroup: layingForm,
              child: CupertinoExpansionTile(
                index: 3,
                icon: Icons.water,
                controller: controller,
                title: "Laying Details",
                subtitle: "Add your laying details here",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        "Laying Form",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (var field in layingFormMapper)
                      buildField(field, layingForm),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            /// 5. Sprinkler Form
            ReactiveForm(
              formGroup: sprinklerForm,
              child: CupertinoExpansionTile(
                index: 4,
                icon: Icons.spa,
                controller: controller,
                title: "Sprinkler Details",
                subtitle: "Add your sprinkler details here",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        "Sprinkler Form",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (var field in sprinklerFormMapper)
                      buildField(field, sprinklerForm),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Save button
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Color.fromARGB(255, 2, 59, 105)),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              onPressed: () {
                if (particularsOfInvestmentForm.valid &&
                    diggingForm.valid &&
                    pumpSetForm.valid &&
                    layingForm.valid &&
                    sprinklerForm.valid) {
                  showDialog(
                    context: context,
                    builder: (_) => SysmoAlert.success(
                      message: 'All forms saved successfully!',
                      onButtonPressed: () => context.pop(),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => SysmoAlert.warning(
                      message: 'Please fill all forms before adding details',
                      onButtonPressed: () => context.pop(),
                    ),
                  );
                  particularsOfInvestmentForm.markAllAsTouched();
                  diggingForm.markAllAsTouched();
                  pumpSetForm.markAllAsTouched();
                  layingForm.markAllAsTouched();
                  sprinklerForm.markAllAsTouched();
                }
              },
              child: const Text("Save"),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
