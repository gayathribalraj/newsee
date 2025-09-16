import 'package:newsee/feature/dynamic_form/form_mapper.dart';

final List<FormMapper> pumpSetFormMapper = [
  FormMapper(
    formName: "groundwater_clearance",
    formType: "Dropdown",
    label: "Is the area clearance (Block / Taluk / Mandal) for groundwater extraction available?",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "electricity_certificate",
    formType: "Dropdown",
    label: "Whether Electricity Feasibility Certificate produced",
    options: ["Yes", "No", "NA"],
  ),
  FormMapper(
    formName: "hp_pipe_sufficiency",
    formType: "Dropdown",
    label: "Whether the H.P. of the motor/engine and length of the pipe proposed to be purchased are sufficient with reference to the availability of water and depth of the well",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "complete_pumping_system",
    formType: "Dropdown",
    label: "Whether the loan is for complete pumping system?",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "river_permission",
    formType: "Dropdown",
    label: "In case the pump set is to be installed in river/riverbeds/stream etc. Whether permission from the Government Department concerned obtained?",
    options: ["Yes", "No", "NA"],
  ),
  FormMapper(
    formName: "water_suitability",
    formType: "Dropdown",
    label: "Is the water in the well suitable for irrigation and state the depth of the water level in summer",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "adequate_supply",
    formType: "Dropdown",
    label: "Whether in the neighbouring wells already fitted with pump sets, there is adequate supply of water for at-least 4 hours of pumping in a day",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "cropping_pattern",
    formType: "Dropdown",
    label: "Is the cropping pattern proposed after development feasible with reference to yield of the well, re-charging capacity, soil conditions etc.",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "pumproom_arrangement",
    formType: "AlphaTextField",
    label: "Arrangements for construction of pumproom",
  ),
  FormMapper(
    formName: "survey_number",
    formType: "CustomTextField",
    label: "Survey / Khasara No",
  ),
  FormMapper(
    formName: "pump_set_particulars",
    formType: "CustomTextField",
    label: "Give particulars of pump set proposed to be purchased",
  ),
  FormMapper(
    formName: "water_source",
    formType: "AlphaTextField",
    label: "Indicate the source of water",
  ),
  FormMapper(
    formName: "area_benefited",
    formType: "IntegerTextField",
    label: "Area to be benefited (in acres)",
  ),
  FormMapper(
    formName: "estimated_cost",
    formType: "IntegerTextField",
    label: "Estimated Cost",
  ),
];
