part of 'cif_bloc.dart';

// we need following state status which is defines http init , loading
// success and failure

enum CifStatus { initial, loading, success, failure }

class CifState extends Equatable {
  final CifStatus status;
  final CifResponseModel? cifResponseModel;
  final String errorMessage;
  // final bool isResponseValid;

  // private constructor for instance initialisation

  const CifState({
    required this.status,
    this.cifResponseModel,
    this.errorMessage = '',
    // this.isResponseValid = false,
  });

  factory CifState.init() => const CifState(status: CifStatus.initial);
  // setting state of instance variable On CifEvents

  CifState copyWith({
    CifStatus? status,
    CifResponseModel? cifResponseModel,
    String? errorMessage,
  }) {
    return CifState(
      status: status ?? this.status,
      cifResponseModel: cifResponseModel ?? this.cifResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cifResponseModel, errorMessage];
}
