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
    formType: "DatePicker",
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
  ),
];
 void attachTotalCostListener(FormGroup form) {
    form.valueChanges.listen((values) {
      final formValues = values ?? {};

      // Extract and sanitize unitCost
      String? unitCostStr = formValues['unitCost']?.toString();
      String? sanitizedUnitCost = unitCostStr?.replaceAll(RegExp(r'[^\d]'), '');
      int unitCost = int.tryParse(sanitizedUnitCost ?? '0') ?? 0;

      // Extract and sanitize quantity
      String? quantityStr = formValues['quantity']?.toString();
      String? sanitizedQty = quantityStr?.replaceAll(RegExp(r'[^\d]'), '');
      int quantity = int.tryParse(sanitizedQty ?? '0') ?? 0;

      // Calculate total cost
      final total = unitCost * quantity;
      final formattedTotal = formatAmount(total.toString());

      // Update totalCost control
      form.control('totalCost').updateValue(formattedTotal);
    });
  }