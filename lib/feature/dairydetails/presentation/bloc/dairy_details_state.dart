import 'package:equatable/equatable.dart';

enum DairyDetailsStatus { initial, loading, success, failure }

class DairyDetailsState extends Equatable {
  final List<Map<String, dynamic>> addedDetails;
  final DairyDetailsStatus status;
  final String? error;

  const DairyDetailsState({
    this.addedDetails = const [],
    this.status = DairyDetailsStatus.initial,
    this.error,
  });

  DairyDetailsState copyWith({
    List<Map<String, dynamic>>? addedDetails,
    DairyDetailsStatus? status,
    String? error,
  }) {
    return DairyDetailsState(
      addedDetails: addedDetails ?? this.addedDetails,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [addedDetails, status, error];
}
