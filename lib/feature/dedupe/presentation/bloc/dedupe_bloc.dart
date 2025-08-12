import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/aadharvalidation/data/repository/aadhar_validate_impl.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_request.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_response.dart';
import 'package:newsee/feature/aadharvalidation/domain/repository/aadharvalidate_repo.dart';
import 'package:newsee/feature/cif/data/repository/cif_respository_impl.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_request.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response.dart';
import 'package:newsee/feature/cif/domain/repository/cif_repository.dart';
import 'package:newsee/feature/dedupe/data/repository/dedupe_search_repo_impl.dart';
import 'package:newsee/feature/dedupe/domain/model/deduperequest.dart';
import 'package:newsee/feature/dedupe/domain/model/deduperesponse.dart';
import 'package:newsee/feature/dedupe/domain/repositoy/deduperepository.dart';

part 'dedupe_event.dart';
part 'dedupe_state.dart';

class DedupeBloc extends Bloc<DedupeEvent, DedupeState> {
  DedupeBloc() : super(DedupeState()) {
    on<FetchDedupeEvent>(dedupeFetch);
    on<ValiateAadharEvent>(onValidateAadhar);
    on<SearchCifEvent>(onSearchCif);
    on<OpenSheetEvent>(openbottomsheet);
    on<DedupeDraftResponseFetch>(dedupeDraftResponse);
    on<DedupeDetailsInitEvent>(initDedupeDetails);
  }

  Future<void> initDedupeDetails(
    DedupeDetailsInitEvent event,
    Emitter emit,
  ) async {
    print('event');
    emit(
      state.copyWith(
        isNewCustomer: null,
        constitution: null,
        status: DedupeFetchStatus.init,
      ),
    );
  }

  Future<void> dedupeDraftResponse(
    DedupeDraftResponseFetch event,
    Emitter emit,
  ) async {
    print('dedupe: ${event.responseData}');
    if (event.responseData!.isNotEmpty) {
      if (event.responseData?['isNewCustomer'] == true) {
        emit(
          state.copyWith(
            status: DedupeFetchStatus.success,
            isNewCustomer: event.responseData?['isNewCustomer'] as bool?,
            constitution: event.responseData?['constitution'] as String?,
            aadharvalidateResponse:
                event.responseData?['aadharvalidateResponse'] != null
                    ? AadharvalidateResponse.fromJson(
                      event.responseData?['aadharvalidateResponse'] ?? {},
                    )
                    : null,
            isAadhaarValidated: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DedupeFetchStatus.success,
            isNewCustomer: event.responseData?['isNewCustomer'],
            constitution: event.responseData?['constitution'],
            cifResponse:
                event.responseData?['cifResponse'] != null
                    ? CifResponse.fromJson(
                      Map<String, dynamic>.from(
                        event.responseData!['cifResponse'],
                      ),
                    )
                    : null,
          ),
        );
      }
    }
  }

  Future<void> dedupeFetch(FetchDedupeEvent event, Emitter emit) async {
    emit(state.copyWith(status: DedupeFetchStatus.loading));
    final DedupeRequest dedupeReq = event.request;
    DedupeRepository dedupeRepository = DedupeSearchRepositoryimpl();
    var responseHandler = await dedupeRepository.dedupeSearchforCustomer(
      dedupeReq,
    );
    if (responseHandler.isRight()) {
      emit(
        state.copyWith(
          status: DedupeFetchStatus.success,
          dedupeResponse: responseHandler.right,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: DedupeFetchStatus.failure,
          errorMsg: responseHandler.left.message,
        ),
      );
    }
  }

  Future<void> onValidateAadhar(ValiateAadharEvent event, Emitter emit) async {
    emit(state.copyWith(status: DedupeFetchStatus.loading));
    final AadharvalidateRequest aadharvalidateRequest = event.request;
    AadharvalidateRepo aadharvalidateRepo = AadharValidateImpl();
    var responseHandler = await aadharvalidateRepo.validateAadhar(
      request: aadharvalidateRequest,
    );
    if (responseHandler.isRight()) {
      emit(
        state.copyWith(
          status: DedupeFetchStatus.success,
          aadharvalidateResponse: responseHandler.right,
          isAadhaarValidated: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: DedupeFetchStatus.failure,
          errorMsg: responseHandler.left.message,
          isAadhaarValidated: false,
        ),
      );
    }
  }

  Future onSearchCif(SearchCifEvent event, Emitter emit) async {
    emit(state.copyWith(status: DedupeFetchStatus.loading));
    CifRepository dedupeRepository = CifRepositoryImpl();
    final response = await dedupeRepository.searchCif(event.request);
    if (response.isRight()) {
      emit(
        state.copyWith(
          status: DedupeFetchStatus.success,
          cifResponse: response.right,
        ),
      );
    } else {
      print('cif failure response.left ');
      emit(
        state.copyWith(
          status: DedupeFetchStatus.failure,
          errorMsg: response.left.message,
        ),
      );
    }
  }

  Future openbottomsheet(OpenSheetEvent event, Emitter emit) async {
    print("open botton sheet call here");
    emit(
      state.copyWith(
        status: DedupeFetchStatus.change,
        constitution: event.request['constitution'],
        isNewCustomer: event.request['isNewCustomer'],
      ),
    );
  }
}
