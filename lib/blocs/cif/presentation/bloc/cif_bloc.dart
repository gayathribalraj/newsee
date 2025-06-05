import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/blocs/cif/domain/repository/cif_repository.dart';
import 'package:newsee/blocs/cif/domain/model/user/cif_response_model.dart';
import 'package:equatable/equatable.dart';

part 'cif_event.dart';
part 'cif_state.dart';

final class CifBloc extends Bloc<SearchCif, CifState> {
  final CifRepository cifRepository;

  CifBloc({required this.cifRepository}) : super(CifState.init()) {
    on<SearchCif>(_onSearchCif);
  }

  Future _onSearchCif(SearchCif event, Emitter<CifState> emit) async {
    emit(state.copyWith(status: CifStatus.loading));

    final response = await cifRepository.searchCif(event.request);

    if (response.isRight()) {
      emit(
        state.copyWith(
          status: CifStatus.success,
          cifResponseModel: response.right,
        ),
      );
    } else {
      print('cif failure response.left ');
      emit(
        state.copyWith(
          status: CifStatus.failure,
          errorMessage: response.left.message,
        ),
      );
    }
  }
}
