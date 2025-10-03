// assement_form_event.dart
part of 'assement_form_bloc.dart';

abstract class AssessmentFormEvent {}
class LoadAssessmentDetails extends AssessmentFormEvent {
    final String leadId;
   LoadAssessmentDetails({required this.leadId});

}


class SaveParticulars extends AssessmentFormEvent {
  final Map<String, dynamic> data;
  final dynamic  selected;
  SaveParticulars(this.data,this.selected );
}


class SaveTechnical extends AssessmentFormEvent {
  final Map<String, dynamic> data;
  
  SaveTechnical(this.data,);
}

class SaveEconomic extends AssessmentFormEvent {
  final Map<String, dynamic> data;
  SaveEconomic(this.data);
}

class SaveIncomeExpense extends AssessmentFormEvent {
  final Map<String, dynamic> data;
  SaveIncomeExpense(this.data);
}
