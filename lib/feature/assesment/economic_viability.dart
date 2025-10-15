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
void attachEconomicTotalCostListener(FormGroup form) {
  form.valueChanges.listen((values) {

    //  Existing Crop

  final areaExistingstr = values?['area_acres_existing']?.toString() ?? '';
    final costCultivationExistingstr = values?['cost_cultivation_existing']?.toString() ?? '';
    final yieldPerAcreExistingstr = values?['yield_per_acre_existing']?.toString() ?? '';
    final pricePerQtlExistingstr = values?['price_per_qtl_existing']?.toString() ?? '';
   
  final areaExisting = int.tryParse(areaExistingstr.replaceAll(RegExp(r'[^\d]'), ''))?? 0;
    final costCultExisting = int.tryParse(costCultivationExistingstr.replaceAll(RegExp(r'[^\d]'), ''))?? 0;
    final yieldPerAcreExisting = int.tryParse(yieldPerAcreExistingstr.replaceAll(RegExp(r'[^\d]'), ''))?? 0;
    final pricePerQtlExisting = int.tryParse(pricePerQtlExistingstr.replaceAll(RegExp(r'[^\d]'), ''))?? 0;

  
     
    int totalCostExisting = areaExisting * costCultExisting;
    int totalYieldExisting = areaExisting * yieldPerAcreExisting;
    int totalValueExisting = totalYieldExisting * pricePerQtlExisting;
    int grossSurplusExisting = totalValueExisting - totalCostExisting;

  final formattedTotalExisting = formatAmount(totalCostExisting.toString());
  final formattedYieldExisting = formatAmount(totalYieldExisting.toString());
  final formattedTotalValueExisting = formatAmount(totalValueExisting.toString());
  final formattedGrossSurplusExisting = formatAmount(grossSurplusExisting.toString());

  form.control('total_cost_existing').updateValue(formattedTotalExisting);
  form.control('total_yield_existing').updateValue(formattedYieldExisting);
  form.control('total_value_existing').updateValue(formattedTotalValueExisting);
  form.control('gross_surplus_existing').updateValue(formattedGrossSurplusExisting);
  form.control('existing_crop_total_gross_surplus').updateValue(formattedGrossSurplusExisting); 

    // Proposed Crop


    final areaProposedstr = values?['area_acres_proposed']?.toString() ?? '';
    final costCultivationProposedstr = values?['cost_cultivation_proposed']?.toString() ?? '';
    final yieldPerAcreProposedstr = values?['yield_per_acre_proposed']?.toString() ?? '';
    final pricePerQtlProposedstr = values?['price_per_qtl_proposed']?.toString() ?? '';
   
   
   final areaProposed = int.tryParse(areaProposedstr.replaceAll(RegExp(r'[^\d]'), ''))?? 0;
    final costCultivationProposed = int.tryParse(costCultivationProposedstr.replaceAll(RegExp(r'[^\d]'), ''))?? 0;
    final yieldPerAcreProposed = int.tryParse(yieldPerAcreProposedstr.replaceAll(RegExp(r'[^\d]'), ''))?? 0;
    final pricePerQtlProposed = int.tryParse(pricePerQtlProposedstr.replaceAll(RegExp(r'[^\d]'), ''))?? 0;
   
   
    

  int totalCostProposed = areaProposed * costCultivationProposed;
  int totalYieldProposed = areaProposed * yieldPerAcreProposed;
  int totalValueProposed = totalYieldProposed * pricePerQtlProposed;
  int grossSurplusProposed = totalValueProposed - totalCostProposed;

  final formattedTotalProposed = formatAmount(totalCostProposed.toString());
  final formattedYieldProposed = formatAmount(totalYieldProposed.toString());
  final formattedTotalValueProposed = formatAmount(totalValueProposed.toString());
  final formattedGrossSurplus = formatAmount(grossSurplusProposed.toString());


  form.control('total_cost_proposed').updateValue(formattedTotalProposed);
  form.control('total_yield_proposed').updateValue(formattedYieldProposed);
  form.control('total_value_proposed').updateValue(formattedTotalValueProposed);
  form.control('proposed_crop_total_gross_surplus').updateValue(formattedGrossSurplus);

    
  });
}
