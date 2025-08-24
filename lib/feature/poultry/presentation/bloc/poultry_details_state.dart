
import 'package:equatable/equatable.dart';

class PoultryState extends Equatable {
  final List<Map<String, dynamic>> addedDetails;

  const PoultryState({required this.addedDetails});

  factory PoultryState.initial() => const PoultryState(addedDetails: []);

  PoultryState copyWith({List<Map<String, dynamic>>? addedDetails}) {
    return PoultryState(
      addedDetails: addedDetails ?? this.addedDetails,
    );
  }

  @override
  List<Object?> get props => [addedDetails];
}
