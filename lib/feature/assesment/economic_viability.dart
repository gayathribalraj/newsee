import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/dynamic_form/form_mapper.dart';
import 'package:reactive_forms/reactive_forms.dart';

final List<FormMapper> economicViabilityFormMapper = [

  //  Existing Crop Details
  FormMapper(
    formName: "season_existing",
    formType: "Dropdown",
    label: "Season (Existing)",
    options: ["Kharif", "Rabi", "Zaid"],
  ),
  FormMapper(
    formName: "crop_existing",
    formType: "Dropdown",
    label: "Crops Grown (Existing)",
    options: ["Yes", "No"], 
  ),
  FormMapper(
    formName: "area_acres_existing",
    formType: "IntegerTextField",
    label: "Area in Acres (Existing)",
  ),
  FormMapper(
    formName: "cost_cultivation_existing",
    formType: "IntegerTextField",
    label: "Cost of Cultivation (Existing)",
  ),
  FormMapper(
    formName: "total_cost_existing",
    formType: "CustomTextField",
    label: "Total Cost",
  ),
  FormMapper(
    formName: "yield_per_acre_existing",
    formType: "IntegerTextField",
    label: "Yield per Acre (qtl)",
  ),
  FormMapper(
    formName: "total_yield_existing",
    formType: "CustomTextField",
    label: "Total Yield ",
  ),
  FormMapper(
    formName: "price_per_qtl_existing",
    formType: "IntegerTextField",
    label: "Price / Qtl (Rs.)",
  ),
  FormMapper(
    formName: "total_value_existing",
    formType: "CustomTextField",
    label: "Total Value (Existing)",
  ),
  FormMapper(
    formName: "gross_surplus_existing",
    formType: "CustomTextField",
    label: "Gross Surplus",
  ),
  FormMapper(
    formName: "existing_crop_total_gross_surplus",
    formType: "CustomTextField",
    label: "Existing Crop Total Gross Surplus (A)",
  ),
 
  FormMapper(
  formName: "none",
  formType: "Label",
    label: "PROPOSED CROP DETAILS",
),
  FormMapper(
    formName: "season_proposed",
    formType: "Dropdown",
    label: "Season",
    options: ["Kharif", "Rabi", "Zaid"],
  ),
  FormMapper(
    formName: "crop_proposed",
    formType: "Dropdown",
    label: "Crops Grown ",
    options: ["Yes", "No"], 
  ),
  FormMapper(
    formName: "area_acres_proposed",
    formType: "IntegerTextField",
    label: "Area in Acres ",
  ),
  FormMapper(
    formName: "cost_cultivation_proposed",
    formType: "IntegerTextField",
    label: "Cost of Cultivation ",
  ),
  FormMapper(
    formName: "total_cost_proposed",
    formType: "IntegerTextField",
    label: "Total Cost ",
  ),
  FormMapper(
    formName: "yield_per_acre_proposed",
    formType: "IntegerTextField",
    label: "Yield per Acre (qtl) ",
  ),
  FormMapper(
    formName: "total_yield_proposed",
    formType: "IntegerTextField",
    label: "Total Yield",
  ),
  FormMapper(
    formName: "price_per_qtl_proposed",
    formType: "IntegerTextField",
    label: "Price / Qtl (Rs.)",
  ),
  FormMapper(
    formName: "total_value_proposed",
    formType: "IntegerTextField",
    label: "Total Value ",
  ),
  FormMapper(
    formName: "gross_surplus_proposed",
    formType: "IntegerTextField",
    label: "Gross Surplus ",
  ),
  FormMapper(
    formName: "proposed_crop_total_gross_surplus",
    formType: "IntegerTextField",
    label: "Proposed Crop Total Gross Surplus (B)",
  ),

  FormMapper(
    formName: "holiday_period",
    formType: "CustomTextField",
    label: "Holiday Period Recommended",
  ),
  FormMapper(
    formName: "repayment_schedule",
    formType: "CustomTextField",
    label: "Proposed Repayment Schedule",
  ),
];
void attachCropDetailsListeners(FormGroup form) {
  form.valueChanges.listen((values) {

    //  Existing Crop
   
   final areaExisting = int.tryParse(values?['area_acres_existing']?.toString() ?? '') ?? 0;
    final costCultivationExisting = int.tryParse(values?['cost_cultivation_existing']?.toString() ?? '') ?? 0;
    final yieldPerAcreExisting = int.tryParse(values?['yield_per_acre_existing']?.toString() ?? '') ?? 0;
    final pricePerQtlExisting = int.tryParse(values?['price_per_qtl_existing']?.toString() ?? '') ?? 0;
 
     
    int totalCostExisting = areaExisting * costCultivationExisting;
    int totalYieldExisting = areaExisting * yieldPerAcreExisting;
    int totalValueExisting = totalYieldExisting * pricePerQtlExisting;
    int grossSurplusExisting = totalValueExisting - totalCostExisting;

    form.control('total_cost_existing').updateValue(totalCostExisting);
    form.control('total_yield_existing').updateValue(totalYieldExisting);
    form.control('total_value_existing').updateValue(totalValueExisting);
    form.control('gross_surplus_existing').updateValue(grossSurplusExisting);
    form.control('existing_crop_total_gross_surplus').updateValue(grossSurplusExisting); // if multiple rows -> sum

    // ---- Proposed Crop ----
    
   final areaProposed = int.tryParse(values?['area_acres_proposed']?.toString() ?? '') ?? 0;
    final costCultivationProposed = int.tryParse(values?['cost_cultivation_proposed']?.toString() ?? '') ?? 0;
    final yieldPerAcreProposed = int.tryParse(values?['yield_per_acre_proposed']?.toString() ?? '') ?? 0;
    final pricePerQtlProposed = int.tryParse(values?['price_per_qtl_proposed']?.toString() ?? '') ?? 0;

    
    int totalCostProposed = areaProposed * costCultivationProposed;
    int totalYieldProposed = areaProposed * yieldPerAcreProposed;
    int totalValueProposed = totalYieldProposed * pricePerQtlProposed;
    int grossSurplusProposed = totalValueProposed - totalCostProposed;

    form.control('total_cost_proposed').updateValue(totalCostProposed);
    form.control('total_yield_proposed').updateValue(totalYieldProposed);
    form.control('total_value_proposed').updateValue(totalValueProposed);
    form.control('gross_surplus_proposed').updateValue(grossSurplusProposed);
    form.control('proposed_crop_total_gross_surplus').updateValue(grossSurplusProposed);

    
  });
}
