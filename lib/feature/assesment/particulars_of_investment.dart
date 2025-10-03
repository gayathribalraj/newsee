import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/dynamic_form/form_mapper.dart';
import 'package:reactive_forms/reactive_forms.dart';

final List<FormMapper> particularsOfInvestmentFormMapper = [
  FormMapper(
    formName: "particulars",
    formType: "Dropdown",  
    label: "Particulars",
    options: [
      "Digging / Repair of well & Drilling bore / tube wells",
      "Purchase of Electric motor / pump set",
      "Laying of water pipelines and others",
      "Sprinkler / Drip Irrigation systems",

    ],
  ),
  FormMapper(
    formName: "supplierName",
    formType: "AlphaTextField",
    label: "Name of Supplier",
  ),
  FormMapper(
    formName: "supplierAddress",
    formType: "CustomTextField",
    label: "Supplier Address",
  ),
  FormMapper(
    formName: "dateOfQuotation",
    formType: "DatePickerField",
    label: "Date of Quotation",
  ),
  FormMapper(
    formName: "quotationNumber",
    formType: "IntegerTextField",
    label: "Quotation Number",
  ),
  FormMapper(
    formName: "unitCost",
    formType: "IntegerTextField",
    label: "Unit Cost",
  ),
  FormMapper(
    formName: "quantity",
    formType: "IntegerTextField",
    label: "No. of Unit / Quantity",
  ),
  FormMapper(
  formName: "totalCost",
  formType: "CustomTextField",
  label: "Total Cost",
  readOnly: true,
)
];
 void attachTotalCostListener(FormGroup form) {
  form.valueChanges.listen((values) {
    
    final unitCostStr = values?['unitCost']?.toString() ?? '';
    final quantityStr = values?['quantity']?.toString() ?? '';

    final unitCost = int.tryParse(unitCostStr.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    final quantity = int.tryParse(quantityStr.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

    final total = unitCost * quantity;
    final formattedTotal = formatAmount(total.toString());

    form.control('totalCost').updateValue(formattedTotal);
  });
}
