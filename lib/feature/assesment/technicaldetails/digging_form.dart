import 'package:newsee/feature/dynamic_form/form_mapper.dart';

final List<FormMapper> diggingFormMapper = [
  FormMapper(
    formName: "groundwater",
    formType: "Dropdown",
    label: "Is the area clearance (Block / Taluk / Mandal) for groundwater extraction available?",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "spacing_norms",
    formType: "Dropdown",
    label: "Whether the proposed point fulfils the spacing norms prescribed by the State Groundwater Department / NABARD ",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "distance_nearest_well",
    formType: "IntegerTextField",
    label: "Distance of the proposed site/point from the nearest well (in metres)",
  ),
  FormMapper(
    formName: "sufficient_groundwater",
    formType: "Dropdown",
    label: "Whether sufficient groundwater potential available in the proposed point for extraction?",
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
    label: "Is the quality of water in the neighbouring wells good and suitable for agricultural purpose and state the water level during the summer in these wells",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "cropping_pattern",
    formType: "Dropdown",
    label: "Is the cropping pattern proposed after development feasible with reference to yield of the well, recharging capacity etc.",
    options: ["Yes", "No"],
  ),
  FormMapper(
    formName: "pump_set_possession",
    formType: "Dropdown",
    label: "Is the applicant in possession of pump set with electric motor/oil engine with required H.P",
    options: ["Yes", "No"],
  ),
  
  FormMapper(
    formName: "survey_number",
    formType: "CustomTextField",
    label: "Survey / Khasara No",
  ),
  FormMapper(
    formName: "proposed_well_type",
    formType: "CustomTextField",
    label: "Type of Proposed well",
  ),
  FormMapper(
    formName: "proposed_repairs",
    formType: "CustomTextField",
    label: "Particulars of proposed repairs",
  ),
  FormMapper(
    formName: "deepening_cost",
    formType: "IntegerTextField",
    label: "Deepening (Estimated Cost in Rs)",
  ),
  FormMapper(
    formName: "walls_cost",
    formType: "IntegerTextField",
    label: "Walls (Estimated Cost in Rs)",
  ),
  FormMapper(
    formName: "others_cost",
    formType: "IntegerTextField",
    label: "Others (Estimated Cost in Rs)",
  ),
  FormMapper(
  formName: "size_of_well_label",
  formType: "Label",
  label: "Size of the proposed well",
),

  FormMapper(
    formName: "depth",
    formType: "IntegerTextField",
    label: "Depth",
  ),
  
  FormMapper(
    formName: "diameter_surface",
    formType: "IntegerTextField",
    label: "Diameter / Surface",
  ),
  FormMapper(
    formName: "lifting_method",
    formType: "AlphatextField",
    label: "How water is proposed to be lifted from the proposed well",
  ),
  FormMapper(
    formName: "area_benefited",
    formType: "IntegerTextField",
    label: "Area to be benefited (in acres)",
  ),
  FormMapper(
    formName: "estimated_cost",
    formType: "IntegerTextField",
    label: "Estimated Cost (in Rs)",
  ),
];
