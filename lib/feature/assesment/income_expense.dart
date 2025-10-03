import 'package:newsee/feature/dynamic_form/form_mapper.dart';
import 'package:reactive_forms/reactive_forms.dart';

final List<FormMapper> incomeExpenseFormMapper = [
  FormMapper(
    formName: "farm_income",
    formType: "CustomTextField",
    label: "Farm Income",
  ),
  FormMapper(
    formName: "other_income",
    formType: "IntegerTextField",
    label: "Other Income",
  ),
  FormMapper(
    formName: "gross_income",
    formType: "CustomTextField",
    label: "Gross Income",
  ),
 FormMapper(
  formName: "none",
  formType: "Label",
  label: "EXPENSE DETAILS",
),
  FormMapper(
    formName: "maintenance_charges",
    formType: "IntegerTextField",
    label: "Maintenance, Repair charges and Other charges",
  ),
  FormMapper(
    formName: "existing_loan_dues",
    formType: "CustomTextField",
    label: "Existing Loan Dues",
  ),
  FormMapper(
    formName: "remarks",
    formType: "CustomTextField",
    label: "Remarks",
  ),
  FormMapper(
    formName: "annual_family_expense",
    formType: "IntegerTextField",
    label: "Annual Family Expense",
  ),
  FormMapper(
    formName: "gross_expense",
    formType: "CustomTextField",
    label: "Gross Expense",
  ),
  FormMapper(
    formName: "depreciation",
    formType: "IntegerTextField",
    label: "Depreciation (%)",
  ),
  FormMapper(
    formName: "net_income",
    formType: "CustomTextField",
    label: "Net Income",
  ),
];

void attachIncomeExpenseListeners(FormGroup form, FormGroup cropForm) {
  form.valueChanges.listen((values) {
    final v = values ?? {};

    // --- Auto populate Farm Income ---
    int farmIncome = 0;
    try {
      int existingGross = int.tryParse(
            cropForm.control('existing_crop_total_gross_surplus').value?.toString() ?? '0',
          ) ??
          0;
      int proposedGross = int.tryParse(
            cropForm.control('proposed_crop_total_gross_surplus').value?.toString() ?? '0',
          ) ??
          0;
      farmIncome = existingGross + proposedGross;
    } catch (_) {}

    form.control('farm_income').updateValue(farmIncome, emitEvent: false);

    // --- Other Income (manual entry) ---
    int otherIncome = int.tryParse(v['other_income']?.toString() ?? '0') ?? 0;

    // --- Gross Income = Farm + Other ---
    int grossIncome = farmIncome + otherIncome;
    form.control('gross_income').updateValue(grossIncome, emitEvent: false);

    // --- Expense Section ---
    int maintenance = int.tryParse(v['maintenance_charges']?.toString() ?? '0') ?? 0;
    int existingLoanDues = int.tryParse(v['existing_loan_dues']?.toString() ?? '0') ?? 0;
    int familyExpense = int.tryParse(v['annual_family_expense']?.toString() ?? '0') ?? 0;

    int grossExpense = maintenance + existingLoanDues + familyExpense;
    form.control('gross_expense').updateValue(grossExpense, emitEvent: false);

    // --- Depreciation (percentage of gross income) ---
    int depreciationPercent = int.tryParse(v['depreciation']?.toString() ?? '0') ?? 0;
    int depreciationValue = (grossIncome * depreciationPercent) ~/ 100;

    // --- Net Income = Gross Income - Gross Expense - Depreciation ---
    int netIncome = grossIncome - grossExpense - depreciationValue;
    form.control('net_income').updateValue(netIncome, emitEvent: false);

    // --- Remarks enable/disable based on Existing Loan Dues ---
    if (existingLoanDues > 0) {
      form.control('remarks').markAsEnabled();
    } else {
      form.control('remarks').markAsDisabled();
    }
  });
}
