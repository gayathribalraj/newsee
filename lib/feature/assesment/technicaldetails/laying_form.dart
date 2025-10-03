import 'package:newsee/feature/dynamic_form/form_mapper.dart';

final List<FormMapper> layingFormMapper = [
  FormMapper(
    formName: "groundwater_clearance",
    formType: "Dropdown",
    label:
        "Is the area clearance (Block / Taluk / Mandal) for groundwater extraction available?",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "spacing_norms",
    formType: "Dropdown",
    label:
        "Whether the proposed point fulfils the spacing norms prescribed by the State Groundwater Department / NABARD/",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "distance_nearest_well",
    formType: "IntegerTextField",
    label:
        "Distance of the proposed site/point from the nearest well (in metres)",
  ),
  FormMapper(
    formName: "sufficient_groundwater",
    formType: "Dropdown",
    label:
        "Whether sufficient groundwater potential available in the proposed point for extraction?",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "area_commanded",
    formType: "IntegerTextField",
    label: "Area that could be commanded by the proposed well",
  ),
  FormMapper(
    formName: "water_quality",
    formType: "Dropdown",
    label:
        "Is the quality of water in the neighbouring wells good and suitable for agricultural purpose and state the water level during the summer in these wells",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "cropping_pattern",
    formType: "Dropdown",
    label:
        "Is the cropping pattern proposed after development feasible with reference to yield of the well, recharging capacity etc.",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "pump_set_possession",
    formType: "Dropdown",
    label:
        "Is the applicant in possession of pump set with electric motor/oil engine with required H.P",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "electricity_certificate",
    formType: "Dropdown",
    label: "Whether Electricity Feasibility Certificate produced",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "hp_pipe_sufficiency",
    formType: "Dropdown",
    label:
        "Whether the H.P. of the motor/engine and length of the pipe proposed to be purchased are sufficient with reference to the availability of water and depth of the well",
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
    label:
        "In case the pump set is to be installed in river/riverbeds/stream etc. Whether permission from the Government Department concerned obtained?",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "water_suitability",
    formType: "Dropdown",
    label:
        "Is the water in the well suitable for irrigation and state the depth of the water level in summer",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "adequate_supply",
    formType: "Dropdown",
    label:
        "Whether in the neighbouring wells already fitted with pump sets, there is adequate supply of water for at-least 4 hours of pumping in a day",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "pumproom_arrangement",
    formType: "CustomTextField",
    label: "Arrangements for construction of pumproom",
  ),
  FormMapper(
    formName: "survey_number",
    formType: "CustomTextField",
    label: "Survey / Khasara No",
  ),

  /// Section label
  FormMapper(
    formName: "none",
    formType: "Label",
    label: "Size of tube well / borewell / filter point",
  ),

  FormMapper(
    formName: "diameter",
    formType: "IntegerTextField",
    label: "Diameter",
  ),
  FormMapper(
    formName: "depth",
    formType: "IntegerTextField",
    label: "Depth",
  ),
  FormMapper(
    formName: "boring_pipe_size",
    formType: "IntegerTextField",
    label: "Size of boring pipe (Diameter)",
  ),
  FormMapper(
    formName: "delivery_pipe_size",
    formType: "IntegerTextField",
    label: "Size of delivery pipe (Diameter)",
  ),
  FormMapper(
    formName: "motor_engine_hp",
    formType: "IntegerTextField",
    label: "Motor or Engine (HP)",
  ),
  FormMapper(
    formName: "pump_set_particulars",
    formType: "AlphaTextField",
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
