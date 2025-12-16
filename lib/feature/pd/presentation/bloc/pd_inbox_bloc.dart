import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/pd/domain/modal/pd_inbox_request.dart';
import 'package:newsee/feature/proposal_inbox/data/repository/proposal_inbox_repository_impl.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/application_status_response.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/group_proposal_inbox.dart';
import 'package:newsee/feature/proposal_inbox/domain/repository/proposal_inbox_repository.dart';

part 'pd_inbox_event.dart';
part 'pd_inbox_state.dart';

class PDInboxBloc extends Bloc<PDInboxEvent, PDInboxState> {
  final ProposalInboxRepository proposalInboxRepository;

  PDInboxBloc({ProposalInboxRepository? repository})
    : proposalInboxRepository = repository ?? ProposalInboxRepositoryImpl(),
      super(PDInboxState()) {
    on<SearchProposalInboxEvent>(onSearchProposalInbox);
    on<ApplicationStatusCheckEvent>(onCheckStatus);
    on<PDInboxFetchEvent>(onSearchPDInbox);
  }

  Future<void> onSearchProposalInbox(
    SearchProposalInboxEvent event,
    Emitter<PDInboxState> emit,
  ) async {
    emit(state.copyWith(status: PDInboxStatus.loading));
    UserDetails? userDetails = await loadUser();
    LeadInboxRequest request = LeadInboxRequest(
      userid: userDetails!.LPuserID,
      token: ApiConstants.api_qa_token,
      pageNo: event.request.pageNo,
      pageCount: event.request.pageCount,
    );

    final response = await proposalInboxRepository.searchProposalInbox(request);
    // check if response i success and contains valid data , success status is emitted

    if (response.isRight()) {
      emit(
        state.copyWith(
          status: PDInboxStatus.success,
          proposalResponseModel: response.right.proposalDetails,
          currentPage: event.request.pageNo,
          totalProposalApplication: response.right.totalProposals,
        ),
      );
    } else {
      print('Proposal failure response.left');
      emit(
        state.copyWith(
          status: PDInboxStatus.failure,
          errorMessage: response.left.message,
        ),
      );
    }
  }

  Future<void> onCheckStatus(
    ApplicationStatusCheckEvent event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(applicationStatus: SaveStatus.loading));
      final req = {
        'proposalNumber': event.currentApplication['propNo'],
        'token': ApiConstants.api_qa_token,
      };
      final response = await proposalInboxRepository.getApplicationStatus(req);
      if (response.isRight()) {
        emit(
          state.copyWith(
            applicationStatus: SaveStatus.success,
            applicationStatusResponse: response.right,
            currentApplication: event.currentApplication,
          ),
        );
        Future.delayed(Duration(seconds: 1));
        emit(state.copyWith(applicationStatus: SaveStatus.update));
      } else {
        print('Proposal failure response.left');
        emit(
          state.copyWith(
            applicationStatus: SaveStatus.failure,
            errorMessage: response.left.message,
            currentApplication: event.currentApplication,
          ),
        );
        Future.delayed(Duration(seconds: 1));
        emit(state.copyWith(applicationStatus: SaveStatus.update));
      }
    } catch (error) {
      print("onCheckStatus-error $error");
      emit(state.copyWith(applicationStatus: SaveStatus.failure));
      Future.delayed(Duration(seconds: 1));
      emit(state.copyWith(applicationStatus: SaveStatus.update));
    }
  }

  /// @author : karthick.d  10/12/2025
  /// @desc   : Fetch PD Inbox - when PDInboxFetchEvent is added

  Future<void> onSearchPDInbox(
    PDInboxFetchEvent event,
    Emitter<PDInboxState> emit,
  ) async {
    emit(state.copyWith(status: PDInboxStatus.loading));
    UserDetails? userDetails = await loadUser();
    final request = PdInboxRequest(
      userId: userDetails!.LPuserID,
      token: ApiConstants.api_qa_token,
      pageNo: event.request.pageNo,
      pageCount: event.request.pageCount,
      orgId: ["14356"],
    );

    final response = await proposalInboxRepository.searchPDInbox(request);
    // check if response i success and contains valid data , success status is emitted

    if (response.isRight()) {
      final updateDetails = response.right.proposalDetails.map((res) async {
        final updatedData = Map<String, dynamic>.from(res.finalList);
        if (updatedData['polygonDetails'] != null &&
            updatedData['polygonDetails'] is List) {
          final polygrons = updatedData['polygonDetails'] as List<dynamic>;
          final firstPolygron = polygrons[0] as Map<String, dynamic>;

          final latitude = firstPolygron['lppLatitude'] as double?;
          final longitude = firstPolygron['lppLongitude'] as double?;

          if (latitude != null && longitude != null) {
            final Position currentPosition =
                await Geolocator.getCurrentPosition(
                  locationSettings: const LocationSettings(
                    accuracy: LocationAccuracy.high,
                    distanceFilter: 0,
                  ),
                );

            double calculateDistance = Geolocator.distanceBetween(
              currentPosition.latitude,
              currentPosition.longitude,
              latitude,
              longitude,
            );
            updatedData['distance'] = calculateDistance;
          }
        }return GroupProposalInbox(finalList: updatedData);
      }
           
      );
      emit(
        state.copyWith(
          status: PDInboxStatus.success,
          proposalResponseModel: response.right.proposalDetails,
          currentPage: event.request.pageNo,
          totalProposalApplication: response.right.totalProposals,
        ),
      );
    } else {
      print('Proposal failure response.left');
      emit(
        state.copyWith(
          status: PDInboxStatus.failure,
          errorMessage: response.left.message,
        ),
      );
    }
  }
}
