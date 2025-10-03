import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/feature/assesment/presentaion/assement_form_bloc.dart';
import 'package:newsee/feature/assesment/economic_viability.dart';
import 'package:newsee/feature/assesment/income_expense.dart';
import 'package:newsee/feature/assesment/particulars_of_investment.dart';
import 'package:newsee/feature/assesment/technicaldetails/digging_form.dart';
import 'package:newsee/feature/assesment/technicaldetails/laying_form.dart';
import 'package:newsee/feature/assesment/technicaldetails/pumpset_form_mapper.dart';
import 'package:newsee/feature/assesment/technicaldetails/sprinkler_form.dart';
import 'package:newsee/feature/dynamic_form/dynamic_form_widget.dart';
import 'package:newsee/feature/dynamic_form/form_mapper.dart';
import 'package:newsee/widgets/cupertino_expansion_tile.dart';
import 'package:newsee/widgets/expansion_controller.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

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
        if (field.formName != 'none')
          field.formName: FormControl<String>(
            validators: [Validators.required],
          ),
    });

    final layingForm = FormGroup({
      for (var field in layingFormMapper)
        if (field.formName != 'none')
          field.formName: FormControl<String>(
            validators: [Validators.required],
          ),
    });

    final pumpSetForm = FormGroup({
      for (var field in pumpSetFormMapper)
        if (field.formName != 'none')
          field.formName: FormControl<String>(
            validators: [Validators.required],
          ),
    });

    final sprinklerForm = FormGroup({
      for (var field in sprinklerFormMapper)
        if (field.formName != 'none')
          field.formName: FormControl<String>(
            validators: [Validators.required],
          ),
    });

    final incomeExpenseForm = FormGroup({
      for (var field in incomeExpenseFormMapper)
        if (field.formName != 'none')
          field.formName: FormControl<String>(
            validators: [Validators.required],
          ),
    });

    final economicViabilityForm = FormGroup({
      for (var field in economicViabilityFormMapper)
        if (field.formName != 'none')
          field.formName: FormControl<String>(
            validators: [Validators.required],
          ),
    });

    // Attach listeners if needed
    attachTotalCostListener(particularsOfInvestmentForm);
    attachCropDetailsListeners(economicViabilityForm);

    final controller = ExpansionController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assessment Details"),
        backgroundColor: Colors.teal,
      ),
      body: BlocProvider(
        create: (context) => AssesementFormBloc()..add(LoadAssessmentDetails(leadId: leadId)),
        child: BlocBuilder<AssesementFormBloc, AssessmentFormState>(
          builder: (context, state) {
            const totalSection = 4;

      particularsOfInvestmentForm.patchValue(state.particularsData);
      
  if(state.selectedParticular == "Digging / Repair of well & Drilling bore / tube wells"){
    diggingForm.patchValue(state.technicalData);

  }
  else if(state.selectedParticular == "Laying of water pipelines and others"){
    layingForm.patchValue(state.technicalData);

  }
  else if(state.selectedParticular == "Purchase of Electric motor / pump set"){
    pumpSetForm.patchValue(state.technicalData);

  }
  else if(state.selectedParticular == "Sprinkler / Drip Irrigation systems"){
    sprinklerForm.patchValue(state.technicalData);

  }
  else{
    diggingForm.patchValue(state.technicalData);

  }



      // switch(state.selectedParticular){
      //  case "Digging / Repair of well & Drilling bore / tube wells":
      //  diggingForm.patchValue(state.technicalData);
      //  break;
      //  case "Laying of water pipelines and others":
      //  layingForm.patchValue(state.technicalData);
      //  break;
      //  case "purchase of Electric motor / pump set":
      //  pumpSetForm.patchValue(state.technicalData);
      //  break;
      //  case "Sprinkler / Drip Irrigation systems":
      //  sprinklerForm.patchValue(state.technicalData);
      //  default:
      //  diggingForm.patchValue(state.technicalData);

      // }
      economicViabilityForm.patchValue(state.economicData);
      incomeExpenseForm.patchValue(state.incomeExpenseData);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  buildProgressIndicator(state.progress, totalSection),
               
                  //  Particulars Of Investment
                  ReactiveForm(
                    formGroup: particularsOfInvestmentForm,
                    child: CupertinoExpansionTile(
                      index: 0,
                      icon: Icons.work_outline,
                      controller: controller,
                      title: "Particulars Of Investment",
                      subtitle:
                          "Add your particulars of investment details here",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 2, 59, 105),
                              ),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                            ),
                            onPressed: () {
                              if (particularsOfInvestmentForm.valid) {
                                final data = particularsOfInvestmentForm.value;
                                final selected =
                                    data["particulars"] as String? ?? "";
                                context.read<AssesementFormBloc>().add(
                                      SaveParticulars(data, selected)
                                    );
                                showDialog(
                                  context: context,
                                  builder: (_) => SysmoAlert.success(
                                    message:
                                        'Particulars saved successfully!',
                                    onButtonPressed: () => context.pop(),
                                  ),
                                );
                              } else {
                                particularsOfInvestmentForm.markAllAsTouched();
                                showDialog(
                                  context: context,
                                  builder: (_) => SysmoAlert.warning(
                                    message:
                                        'Please fill all particulars before saving',
                                    onButtonPressed: () => context.pop(),
                                  ),
                                );
                              }
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //  Technical Details (dynamic based on selection)
                  CupertinoExpansionTile(
                    index: 1,
                    icon: Icons.construction,
                    controller: controller,
                    title: "Technical Details",
                    subtitle: "Add your Technical details here",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (state.selectedParticular ==
                            "Digging / Repair of well & Drilling bore / tube wells")
                          buildTechnicalForm(
                            title:
                                "For Digging / Repair of Well and Drilling of Bore Well",
                            form: diggingForm,
                            fields: diggingFormMapper,
                            onSave: () => context
                                .read<AssesementFormBloc>()
                                .add(SaveTechnical(diggingForm.value)),
                                 context: context,
                          ),
                        if (state.selectedParticular ==
                            "Laying of water pipelines and others")
                          buildTechnicalForm(
                            title: "For Laying of water pipelines and others",
                            form: layingForm,
                            fields: layingFormMapper,
                            onSave: () => context
                                .read<AssesementFormBloc>()
                                .add(SaveTechnical(layingForm.value)),
                                 context: context,
                          ),
                        if (state.selectedParticular ==
                            "Purchase of Electric motor / pump set")
                          buildTechnicalForm(
                            title: "For Purchase of Electric Motor / Pump Set",
                            form: pumpSetForm,
                            fields: pumpSetFormMapper,
                            onSave: () => context
                                .read<AssesementFormBloc>()
                                .add(SaveTechnical(pumpSetForm.value)),
                                 context: context,
                          ),
                          if (state.selectedParticular ==
                            "Sprinkler / Drip Irrigation systems")
                          buildTechnicalForm(
                            title: "For Sprinkler / Drip Irrigation Systems",
                            form: sprinklerForm,
                            fields: sprinklerFormMapper,
                            onSave: () => context
                                .read<AssesementFormBloc>()
                                .add(SaveTechnical(sprinklerForm.value)),
                                 context: context,
                          ),
                        if ( state.selectedParticular.isNotEmpty) 
                           buildTechnicalForm(
                            title:
                                "For Digging / Repair of Well and Drilling of Bore Well",
                            form: diggingForm,
                            fields: diggingFormMapper,
                            onSave: () => context
                                .read<AssesementFormBloc>()
                                .add(SaveTechnical(diggingForm.value)),
                                 context: context,
                          ),
                      ],
                    ),
                    
                  ),

                  //  Economic Viability
                  ReactiveForm(
                    formGroup: economicViabilityForm,
                    child: CupertinoExpansionTile(
                      index: 2,
                      icon: Icons.eco_rounded,
                      controller: controller,
                      title: "Economic Viability Details",
                      subtitle: "Add your economic viability details here",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              "EXISTING CROP DETAILS",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          for (var field in economicViabilityFormMapper)
                            buildField(field, economicViabilityForm),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 2, 59, 105),
                              ),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                            ),
                            onPressed: () {
                              if (economicViabilityForm.valid) {
                                context.read<AssesementFormBloc>().add(
                                    SaveEconomic(economicViabilityForm.value));
                                showDialog(
                                  context: context,
                                  builder: (_) => SysmoAlert.success(
                                    message:
                                        'Economic details saved successfully!',
                                    onButtonPressed: () => context.pop(),
                                  ),
                                );
                              } else {
                                economicViabilityForm.markAllAsTouched();
                                showDialog(
                                  context: context,
                                  builder: (_) => SysmoAlert.warning(
                                    message:
                                        'Please fill all economic details',
                                    onButtonPressed: () => context.pop(),
                                  ),
                                );
                              }
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //  Income & Expense
                  ReactiveForm(
                    formGroup: incomeExpenseForm,
                    child: CupertinoExpansionTile(
                      index: 3,
                      icon: Icons.incomplete_circle,
                      controller: controller,
                      title: "Income & Expense Form",
                      subtitle: "Add your income/expense details here",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              "INCOME DETAILS",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          for (var field in incomeExpenseFormMapper)
                            buildField(field, incomeExpenseForm),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 2, 59, 105),
                              ),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                            ),
                            onPressed: () {
                              if (incomeExpenseForm.valid) {
                                context.read<AssesementFormBloc>().add(
                                    SaveIncomeExpense(incomeExpenseForm.value));
                                showDialog(
                                  context: context,
                                  builder: (_) => SysmoAlert.success(
                                    message:
                                        'Income & Expense saved successfully!',
                                    onButtonPressed: () => context.pop(),
                                  ),
                                );
                              } else {
                                incomeExpenseForm.markAllAsTouched();
                                showDialog(
                                  context: context,
                                  builder: (_) => SysmoAlert.warning(
                                    message:
                                        'Please fill all income & expense details',
                                    onButtonPressed: () => context.pop(),
                                  ),
                                );
                              }
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // widget for building technical forms
  Widget buildTechnicalForm({
    required String title,
    required FormGroup form,
    required List<FormMapper> fields,
    required VoidCallback onSave,
      required BuildContext context
  }) {
    return ReactiveForm(
      formGroup: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          for (var field in fields) buildField(field, form),
          const SizedBox(height: 16),
          ElevatedButton(
            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 2, 59, 105),
                              ),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                            ),
            onPressed: () {
              if (form.valid) {
                onSave();
                 showDialog(
                context: context,
                builder: (_) => SysmoAlert.success(
                  message: 'Technical details saved successfully!',
                  onButtonPressed: () => context.pop(),
                ),
              );
              } else {
                print("data not valid ${form.value}");
                form.markAllAsTouched();
                 showDialog(
                context: context,
                builder: (_) => SysmoAlert.warning(
                  message: 'Please fill all technical details',
                  onButtonPressed: () => context.pop(),
                ),
              );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
Widget buildProgressIndicator(int currentStep, int totalSteps) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        // Linear Progress Indicator
        Expanded(
          child: LinearProgressIndicator(
            value: currentStep / totalSteps,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 8
            
          ),
        ),
        const SizedBox(width: 12),

        Text(
          "$currentStep/$totalSteps",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
