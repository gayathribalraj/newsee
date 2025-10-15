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

