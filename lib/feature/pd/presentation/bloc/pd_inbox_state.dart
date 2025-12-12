// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'pd_inbox_bloc.dart';

enum PDInboxStatus { init, loading, success, failure }
// we need following state status which is defines http init , loading
// success and failure

class PDInboxState extends Equatable {
  final PDInboxStatus status;
  final List<GroupProposalInbox>? proposalResponseModel;
  final String? errorMessage;
  final int currentPage;
  final int totalProposalApplication;
  final SaveStatus applicationStatus;
  final ApplicationStatusResponse? applicationStatusResponse;
  final Map<String, dynamic>? currentApplication;

  const PDInboxState({
    this.status = PDInboxStatus.init,
    this.proposalResponseModel,
    this.errorMessage,
    this.currentPage = 0,
    this.totalProposalApplication = 1,
    this.applicationStatus = SaveStatus.init,
    this.applicationStatusResponse,
    this.currentApplication,
  });

  factory PDInboxState.init() => const PDInboxState();

  PDInboxState copyWith({
    PDInboxStatus? status,
    List<GroupProposalInbox>? proposalResponseModel,
    String? errorMessage,
    int? currentPage,
    int? totalProposalApplication,
    SaveStatus? applicationStatus,
    ApplicationStatusResponse? applicationStatusResponse,
    Map<String, dynamic>? currentApplication,
  }) {
    return PDInboxState(
      status: status ?? this.status,
      proposalResponseModel:
          proposalResponseModel ?? this.proposalResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalProposalApplication:
          totalProposalApplication ?? this.totalProposalApplication,
      applicationStatus: applicationStatus ?? this.applicationStatus,
      applicationStatusResponse:
          applicationStatusResponse ?? this.applicationStatusResponse,
      currentApplication: currentApplication ?? this.currentApplication,
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      proposalResponseModel,
      errorMessage,
      currentPage,
      totalProposalApplication,
      applicationStatus,
      applicationStatusResponse,
      currentApplication,
    ];
  }
}
