import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:newsee/feature/dairydetails/widgets/Incomeand_expenses_form_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';
part 'assement_form_state.dart';
part 'assement_form_event.dart';

class AssesementFormBloc extends Bloc<AssessmentFormEvent, AssessmentFormState> {
  AssesementFormBloc() : super(const AssessmentFormState()) {
    on<SaveParticulars>(_onSaveParticulars);
    on<SaveTechnical>(_onSaveTechnical);
    on<SaveEconomic>(_onSaveEconomic);
    on<SaveIncomeExpense>(_onSaveIncomeExpense);
    on<LoadAssessmentDetails>(_onLoadFormData);
  }
  Future<void> _onLoadFormData(LoadAssessmentDetails event, Emitter<AssessmentFormState>emit)async{
    final pref = await SharedPreferences.getInstance();

    final particularsString = pref.getString('particulars');
    final technicalString = pref.getString('technical');
    final economicString = pref.getString('economic');
    final incomeExpenseString = pref.getString('incomeExpense');
 final selectedParticular = pref.getString('selectedParticular') ?? " ";

final particularsData =
        particularsString != null ? jsonDecode(particularsString) : {};
    final technicalData =
        technicalString != null ? jsonDecode(technicalString) : {};
    final economicData =
        economicString != null ? jsonDecode(economicString) : {};
    final incomeExpenseData =
        incomeExpenseString != null ? jsonDecode(incomeExpenseString) : {};


    emit(state.copyWith(
      particularsData: particularsData,
      technicalData: technicalData,
      economicData: economicData,
      incomeExpenseData: incomeExpenseData,
      selectedParticular: selectedParticular,
    ));
  }
  

  Future<void> _onSaveParticulars(
    SaveParticulars event,
    Emitter<AssessmentFormState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('particulars', jsonEncode(event.data));
    prefs.setString('selectedParticular', event.selected);
    print('Particulars saved: ${event.data}');

      final emptyProgress = state.particularsData.isEmpty;

    emit(state.copyWith(
      particularsData: event.data,
      selectedParticular: event.selected, 
      progress:emptyProgress ? state.progress+1:state.progress
    ));
  }

  Future<void> _onSaveTechnical(
    SaveTechnical event,
    Emitter<AssessmentFormState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('technical', jsonEncode(event.data));
    print('Technical saved: ${event.data}');
    final emptyProgress = state.technicalData.isEmpty ;
    emit(state.copyWith(technicalData: event.data, progress: emptyProgress ?state.progress+1:state.progress));
  }

  Future<void> _onSaveEconomic(
    SaveEconomic event,
    Emitter<AssessmentFormState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('economic', jsonEncode(event.data));
    print('Economic saved: ${event.data}');
    final emptyProgress = state.economicData.isEmpty ;
    emit(state.copyWith(economicData: event.data,progress: emptyProgress?state.progress+1 :state.progress));
  }

  Future<void> _onSaveIncomeExpense(
    SaveIncomeExpense event,
    Emitter<AssessmentFormState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('incomeExpense', jsonEncode(event.data));
    print('Income & Expense saved: ${event.data}');
    final emptyProgress = state.incomeExpenseData.isEmpty ;
    emit(state.copyWith(incomeExpenseData: event.data,progress: emptyProgress?state.progress+1:state.progress));
  }
}
