// assement_form_state.dart
part of 'assement_form_bloc.dart';

enum AssessmentFormStatus {
  init, 
  loading,  
  success,  
  failure,  
}

class AssessmentFormState extends Equatable {
  final Map<String, dynamic> particularsData;
  final Map<String, dynamic> technicalData;
  final Map<String, dynamic> economicData;
  final Map<String, dynamic> incomeExpenseData;
  final String selectedParticular;
  final int progress;
  final AssessmentFormStatus status;
  final String? error;



  const AssessmentFormState({
    this.particularsData = const {},
    this.technicalData = const {},
    this.economicData = const {},
    this.incomeExpenseData = const {},
    this.selectedParticular = " ",
    this.progress=0,
    this.status =AssessmentFormStatus.init,
    this.error,
   


     }
    
    
    );

  AssessmentFormState copyWith({
    Map<String, dynamic>? particularsData,
    Map<String, dynamic>? technicalData,
    Map<String, dynamic>? economicData,
    Map<String, dynamic>? incomeExpenseData,
    String? selectedParticular,
    int?progress,
    AssessmentFormStatus?status,
    String?error,
  }) {
    return AssessmentFormState(
      particularsData: particularsData ?? this.particularsData,
      technicalData: technicalData ?? this.technicalData,
      economicData: economicData ?? this.economicData,
      incomeExpenseData: incomeExpenseData ?? this.incomeExpenseData,
      selectedParticular: selectedParticular ?? this.selectedParticular,
      progress:progress?? this.progress,
      status:status?? this.status,
      error: error??this.error
    );
  }

  @override
  List<Object?> get props => [particularsData, technicalData, economicData, incomeExpenseData, selectedParticular,progress];
}
